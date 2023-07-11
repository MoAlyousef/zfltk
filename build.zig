const std = @import("std");
const Build = std.Build;
const CompileStep = std.build.CompileStep;
const utils = @import("build_utils.zig");

const Sdk = @This();
builder: *Build,
install_prefix: []const u8,
finalize_cfltk: *std.Build.Step,
use_wayland: bool,

inline fn thisDir() []const u8 {
    return comptime std.fs.path.dirname(@src().file) orelse @panic("error");
}

pub fn getZfltkModule(sdk: *Sdk, b: *Build) *Build.Module {
    _ = sdk;
    return b.createModule(.{
        .source_file = .{ .path = thisDir() ++ "/src/zfltk.zig" },
    });
}

pub const SdkOpts = struct {
    use_wayland: bool = false,
};

pub fn init(b: *Build) !*Sdk {
    return init_with_opts(b, .{});
}

pub fn init_with_opts(b: *Build, opts: SdkOpts) !*Sdk {
    const install_prefix = b.install_prefix;
    const use_wayland = b.option(bool, "zfltk-use-wayland", "build zfltk for wayland") orelse opts.use_wayland;
    const finalize_cfltk = b.step("finalize cfltk install", "Installs cfltk");
    try utils.cfltk_build_from_source(b, finalize_cfltk, install_prefix, use_wayland);
    b.default_step.dependOn(finalize_cfltk);
    const sdk = b.allocator.create(Sdk) catch @panic("out of memory");
    sdk.* = .{
        .builder = b,
        .install_prefix = install_prefix,
        .finalize_cfltk = finalize_cfltk,
        .use_wayland = use_wayland,
    };
    return sdk;
}

pub fn link(sdk: *Sdk, exe: *CompileStep) !void {
    exe.step.dependOn(sdk.finalize_cfltk);
    const install_prefix = sdk.install_prefix;
    try utils.cfltk_link(exe, install_prefix, sdk.use_wayland);
}

pub fn build(b: *Build) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardOptimizeOption(.{});
    const sdk = try Sdk.init(b);
    const zfltk_module = sdk.getZfltkModule(b);
    const examples_step = b.step("examples", "build the examples");
    b.default_step.dependOn(examples_step);

    for (utils.examples) |example| {
        const exe = b.addExecutable(.{
            .name = example.output,
            .root_source_file = .{ .path = example.input },
            .optimize = mode,
            .target = target,
        });
        exe.addModule("zfltk", zfltk_module);
        try sdk.link(exe);
        examples_step.dependOn(&exe.step);
        b.installArtifact(exe);

        const run_cmd = b.addRunArtifact(exe);
        const run_step = b.step(b.fmt("run-{s}", .{example.output}), example.description.?);
        run_step.dependOn(&run_cmd.step);
    }
}
