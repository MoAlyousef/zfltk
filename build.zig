const std = @import("std");
const utils = @import("build_utils.zig");

pub const SdkOpts = struct {
    use_wayland: bool = false,
    system_jpeg: bool = false,
    system_png: bool = false,
    system_zlib: bool = false,
    build_examples: bool = false,
};

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const opts = SdkOpts{
        .use_wayland = b.option(bool, "zfltk-use-wayland", "build zfltk for wayland") orelse false,
        .system_jpeg = b.option(bool, "zfltk-system-libjpeg", "link system libjpeg") orelse false,
        .system_png = b.option(bool, "zfltk-system-libpng", "link system libpng") orelse false,
        .system_zlib = b.option(bool, "zfltk-system-zlib", "link system zlib") orelse false,
        .build_examples = b.option(bool, "zfltk-build-examples", "Build zfltk examples") orelse false,
    };

    const finalize_cfltk = b.step("finalize cfltk", "Installs cfltk if needed");
    b.default_step.dependOn(finalize_cfltk);

    try utils.cfltk_build_from_source(b, finalize_cfltk, .{
        .use_wayland = opts.use_wayland,
        .system_jpeg = opts.system_jpeg,
        .system_png = opts.system_png,
        .system_zlib = opts.system_zlib,
        .build_examples = opts.build_examples,
        .use_fltk_config = false,
    });

    const zfltk_lib = b.addModule("zfltk", .{
        .root_source_file = b.path("src/zfltk.zig"),
        .target = target,
        .optimize = optimize,
    });

    try utils.cfltk_link_lib(b, zfltk_lib, .{
        .use_wayland = opts.use_wayland,
        .system_jpeg = opts.system_jpeg,
        .system_png = opts.system_png,
        .system_zlib = opts.system_zlib,
    });

    if (!b.modules.contains("zfltk")) {
        _ = b.addModule("zfltk", .{
            .root_source_file = b.path("src/zfltk.zig"),
            .target = target,
            .optimize = optimize,
        });
    }

    if (opts.build_examples) {
        const examples_step = b.step("examples", "build the zfltk examples");
        for (utils.examples) |ex| {
            const exe = b.addExecutable(.{
                .name = ex.output,
                .root_source_file = b.path(ex.input),
                .target = target,
                .optimize = optimize,
            });
            // Necessary for using cfltk headers directly if needed
            exe.addIncludePath(b.path("zig-out/cfltk/include"));
            exe.root_module.addImport("zfltk", b.modules.get("zfltk").?);
            exe.linkLibC();
            exe.linkLibCpp();
            examples_step.dependOn(&exe.step);
            b.installArtifact(exe);
        }
    }
}
