const std = @import("std");
const Build = std.Build;
const CompileStep = Build.Step.Compile;
const utils = @import("build_utils.zig");

pub const SdkOpts = struct {
    use_wayland: bool = false,
    system_jpeg: bool = false,
    system_png: bool = false,
    system_zlib: bool = false,
    use_fltk_config: bool = false,
    build_examples: bool = false,
    fn finalOpts(self: SdkOpts) utils.FinalOpts {
        return utils.FinalOpts{
            .use_wayland = self.use_wayland,
            .system_jpeg = self.system_jpeg,
            .system_png = self.system_png,
            .system_zlib = self.system_zlib,
            .build_examples = self.build_examples,
            .use_fltk_config = self.use_fltk_config,
        };
    }
};

const Sdk = @This();
builder: *Build,
install_prefix: []const u8,
finalize_cfltk: *std.Build.Step,
opts: SdkOpts,

pub fn init(b: *Build) !*Sdk {
    return initWithOpts(b, .{});
}

pub fn initWithOpts(b: *Build, opts: SdkOpts) !*Sdk {
    var final_opts = opts;
    final_opts.use_wayland = b.option(bool, "zfltk-use-wayland", "build zfltk for wayland") orelse opts.use_wayland;
    final_opts.system_jpeg = b.option(bool, "zfltk-system-libjpeg", "link system libjpeg") orelse opts.system_jpeg;
    final_opts.system_png = b.option(bool, "zfltk-system-libpng", "link system libpng") orelse opts.system_png;
    final_opts.system_zlib = b.option(bool, "zfltk-system-zlib", "link system zlib") orelse opts.system_zlib;
    final_opts.build_examples = b.option(bool, "zfltk-build-examples", "Build zfltk examples") orelse opts.build_examples;
    final_opts.use_fltk_config = b.option(bool, "zfltk-use-fltk-config", "use fltk-config instead of building fltk from source") orelse opts.use_fltk_config;
    const install_prefix = b.install_prefix;
    const finalize_cfltk = b.step("finalize cfltk install", "Installs cfltk");
    try utils.cfltk_build_from_source(b, finalize_cfltk, install_prefix, final_opts.finalOpts());
    b.default_step.dependOn(finalize_cfltk);
    const sdk = b.allocator.create(Sdk) catch @panic("out of memory");
    sdk.* = .{
        .builder = b,
        .install_prefix = install_prefix,
        .finalize_cfltk = finalize_cfltk,
        .opts = final_opts,
    };
    return sdk;
}

pub fn getZfltkModule(sdk: *Sdk, b: *Build) *Build.Module {
    _ = sdk;
    var mod = b.addModule("zfltk", .{
        .root_source_file = b.path("src/zfltk.zig"),
    });
    mod.addIncludePath(b.path("zig-out/cfltk/include"));
    return mod;
}

pub fn link(sdk: *Sdk, exe: *CompileStep) !void {
    exe.step.dependOn(sdk.finalize_cfltk);
    const install_prefix = sdk.install_prefix;
    if (sdk.opts.use_fltk_config) {
        try utils.link_using_fltk_config(sdk.builder, exe, sdk.finalize_cfltk, sdk.install_prefix);
    } else {
        try utils.cfltk_link(exe, install_prefix, sdk.opts.finalOpts());
    }
}

pub fn build(b: *Build) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardOptimizeOption(.{});
    const sdk = try Sdk.init(b);
    const zfltk_module = sdk.getZfltkModule(b);
    if (sdk.opts.build_examples) {
        const examples_step = b.step("examples", "build the examples");
        b.default_step.dependOn(examples_step);

        for (utils.examples) |example| {
            const exe = b.addExecutable(.{
                .name = example.output,
                .root_source_file = b.path(example.input),
                .optimize = mode,
                .target = target,
            });
            exe.root_module.addImport("zfltk", zfltk_module);
            try sdk.link(exe);
            examples_step.dependOn(&exe.step);
            b.installArtifact(exe);

            const run_cmd = b.addRunArtifact(exe);
            const run_step = b.step(b.fmt("run-{s}", .{example.output}), example.description.?);
            run_step.dependOn(&run_cmd.step);
        }
    }
}
