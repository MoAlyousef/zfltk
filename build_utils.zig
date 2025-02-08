const std = @import("std");
const Build = std.Build;
const CompileStep = Build.Step.Compile;

pub const FinalOpts = struct {
    use_wayland: bool = false,
    system_jpeg: bool = false,
    system_png: bool = false,
    system_zlib: bool = false,
    build_examples: bool = false,
    use_fltk_config: bool = false,
};

const Example = struct {
    description: ?[]const u8,
    output: []const u8,
    input: []const u8,

    pub fn init(output: []const u8, input: []const u8, desc: ?[]const u8) Example {
        return Example{
            .description = desc,
            .output = output,
            .input = input,
        };
    }
};

pub const examples = &[_]Example{
    Example.init("simple", "examples/simple.zig", "A simple hello world app"),
    Example.init("capi", "examples/capi.zig", "Using the C-api directly"),
    Example.init("customwidget", "examples/customwidget.zig", "Custom widget example"),
    Example.init("image", "examples/image.zig", "Simple image example"),
    Example.init("input", "examples/input.zig", "Simple input example"),
    Example.init("mixed", "examples/mixed.zig", "Mixing both c and zig apis"),
    Example.init("editor", "examples/editor.zig", "More complex example"),
    Example.init("layout", "examples/layout.zig", "Layout example"),
    Example.init("valuators", "examples/valuators.zig", "valuators example"),
    Example.init("channels", "examples/channels.zig", "Use messages to handle events"),
    Example.init("editormsgs", "examples/editormsgs.zig", "Use messages in the editor example"),
    Example.init("browser", "examples/browser.zig", "Browser example"),
    Example.init("flex", "examples/flex.zig", "Flex example"),
    Example.init("threadawake", "examples/threadawake.zig", "Thread awake example"),
    Example.init("handle", "examples/handle.zig", "Handle example"),
    Example.init("flutterlike", "examples/flutterlike.zig", "Flutter-like example"),
    Example.init("glwin", "examples/glwin.zig", "OpenGL window example"),
    Example.init("tile", "examples/tile.zig", "Tile group example"),
};

pub fn cfltk_build_from_source(
    b: *Build,
    finalize_cfltk: *Build.Step,
    opts: FinalOpts,
) !void {
    const target = try std.zig.system.resolveTargetQuery(.{});
    const sdk_lib_dir = "zig-out/cfltk/lib";

    _ = std.fs.cwd().openDir(sdk_lib_dir, .{}) catch |err| {
        std.debug.print(
            "Warning: {!}. The cfltk library will be rebuilt from source!\n",
            .{err},
        );

        const cmake_bin_path = "zig-out/cfltk/bin";
        const cmake_src_path = "zig-out/cfltk";
        const cmake_inst_path = "-DCMAKE_INSTALL_PREFIX=zig-out/cfltk/lib";

        const which_png = if (opts.system_png) "-DFLTK_USE_SYSTEM_LIBPNG=ON" else "-DFLTK_USE_SYSTEM_LIBPNG=OFF";
        const which_jpeg = if (opts.system_jpeg) "-DFLTK_USE_SYSTEM_LIBJPEG=ON" else "-DFLTK_USE_SYSTEM_LIBJPEG=OFF";
        const which_zlib = if (opts.system_zlib) "-DFLTK_USE_SYSTEM_ZLIB=ON" else "-DFLTK_USE_SYSTEM_ZLIB=OFF";

        var zfltk_config = blk: {
            if (target.os.tag == .windows) {
                break :blk b.addSystemCommand(&[_][]const u8{
                    "cmake",
                    "-B",
                    cmake_bin_path,
                    "-S",
                    cmake_src_path,
                    "-GNinja",
                    "-DCMAKE_BUILD_TYPE=Release",
                    cmake_inst_path,
                    "-DFLTK_BUILD_TEST=OFF",
                    which_png,
                    which_jpeg,
                    which_zlib,
                    "-DFLTK_BUILD_GL=ON",
                    "-DCFLTK_USE_OPENGL=ON",
                    "-DFLTK_BUILD_FLUID=OFF",
                    "-DFLTK_BUILD_FLTK_OPTIONS=OFF",
                });
            } else if (target.isDarwin()) {
                break :blk b.addSystemCommand(&[_][]const u8{
                    "cmake",
                    "-B",
                    cmake_bin_path,
                    "-S",
                    cmake_src_path,
                    "-DCMAKE_BUILD_TYPE=Release",
                    cmake_inst_path,
                    "-DFLTK_BUILD_TEST=OFF",
                    which_png,
                    which_jpeg,
                    which_zlib,
                    "-DFLTK_BUILD_GL=ON",
                    "-DCFLTK_USE_OPENGL=ON",
                    "-DFLTK_BUILD_FLUID=OFF",
                    "-DFLTK_BUILD_FLTK_OPTIONS=OFF",
                });
            } else {
                if (opts.use_wayland) {
                    break :blk b.addSystemCommand(&[_][]const u8{
                        "cmake",
                        "-B",
                        cmake_bin_path,
                        "-S",
                        cmake_src_path,
                        "-DCMAKE_BUILD_TYPE=Release",
                        cmake_inst_path,
                        "-DFLTK_BUILD_TEST=OFF",
                        which_png,
                        which_jpeg,
                        which_zlib,
                        "-DFLTK_BUILD_GL=ON",
                        "-DCFLTK_USE_OPENGL=ON",
                        "-DFLTK_BACKEND_WAYLAND=ON",
                        "-DFLTK_BUILD_FLUID=OFF",
                        "-DFLTK_BUILD_FLTK_OPTIONS=OFF",
                        "-DFLTK_USE_LIBDECOR_GTK=OFF",
                    });
                } else {
                    break :blk b.addSystemCommand(&[_][]const u8{
                        "cmake",
                        "-B",
                        cmake_bin_path,
                        "-S",
                        cmake_src_path,
                        "-DCMAKE_BUILD_TYPE=Release",
                        cmake_inst_path,
                        "-DFLTK_BUILD_TEST=OFF",
                        which_png,
                        which_jpeg,
                        which_zlib,
                        "-DFLTK_USE_PANGO=ON",
                        "-DFLTK_BUILD_GL=ON",
                        "-DCFLTK_USE_OPENGL=ON",
                        "-DFLTK_BACKEND_WAYLAND=OFF",
                        "-DFLTK_GRAPHICS_CAIRO=ON",
                        "-DFLTK_BUILD_FLUID=OFF",
                        "-DFLTK_BUILD_FLTK_OPTIONS=OFF",
                    });
                }
            }
        };
        zfltk_config.setCwd(b.path("zig-out/cfltk"));

        _ = std.fs.cwd().openDir(cmake_src_path, .{}) catch |_git_err| {
            std.debug.print(
                "The cfltk repository was not found in {s}, cloning from GitHub:{?}...\n",
                .{ cmake_src_path, _git_err },
            );
            const cfltk_fetch = b.addSystemCommand(&[_][]const u8{
                "git",          "clone",     "https://github.com/MoAlyousef/cfltk",
                cmake_src_path, "--depth=1", "--recurse-submodules",
            });
            zfltk_config.step.dependOn(&cfltk_fetch.step);
        };

        const cpu_count = try std.Thread.getCpuCount();
        const jobs_str = try std.fmt.allocPrint(b.allocator, "{d}", .{cpu_count});
        defer b.allocator.free(jobs_str);

        const zfltk_build = b.addSystemCommand(&[_][]const u8{
            "cmake", "--build", cmake_bin_path, "--config", "Release", "--parallel", jobs_str,
        });
        zfltk_build.setCwd(b.path("zig-out/cfltk"));
        zfltk_build.step.dependOn(&zfltk_config.step);

        const zfltk_install = b.addSystemCommand(&[_][]const u8{
            "cmake", "--install", cmake_bin_path,
        });
        zfltk_install.setCwd(b.path("zig-out/cfltk"));
        zfltk_install.step.dependOn(&zfltk_build.step);

        finalize_cfltk.dependOn(&zfltk_install.step);
    };
}

pub fn cfltk_link_lib(
    b: *Build,
    zfltk_lib: *Build.Module,
    opts: FinalOpts,
) !void {
    const target = zfltk_lib.resolved_target.?.result;
    zfltk_lib.addIncludePath(b.path("zig-out/cfltk/include"));
    zfltk_lib.addLibraryPath(b.path("zig-out/cfltk/lib/lib"));

    zfltk_lib.linkSystemLibrary("cfltk", .{ .preferred_link_mode = .static });
    zfltk_lib.linkSystemLibrary("fltk", .{ .preferred_link_mode = .static });
    zfltk_lib.linkSystemLibrary("fltk_images", .{ .preferred_link_mode = .static });

    if (opts.system_png) {
        zfltk_lib.linkSystemLibrary("png", .{});
    } else {
        zfltk_lib.linkSystemLibrary("fltk_png", .{ .preferred_link_mode = .static });
    }
    if (opts.system_jpeg) {
        zfltk_lib.linkSystemLibrary("jpeg", .{});
    } else {
        zfltk_lib.linkSystemLibrary("fltk_jpeg", .{ .preferred_link_mode = .static });
    }
    if (opts.system_zlib) {
        zfltk_lib.linkSystemLibrary("z", .{});
    } else {
        zfltk_lib.linkSystemLibrary("fltk_z", .{ .preferred_link_mode = .static });
    }
    zfltk_lib.linkSystemLibrary("fltk_gl", .{ .preferred_link_mode = .static });

    if (target.os.tag == .windows) {
        zfltk_lib.linkSystemLibrary("ws2_32", .{});
        zfltk_lib.linkSystemLibrary("comctl32", .{});
        zfltk_lib.linkSystemLibrary("gdi32", .{});
        zfltk_lib.linkSystemLibrary("oleaut32", .{});
        zfltk_lib.linkSystemLibrary("ole32", .{});
        zfltk_lib.linkSystemLibrary("uuid", .{});
        zfltk_lib.linkSystemLibrary("shell32", .{});
        zfltk_lib.linkSystemLibrary("advapi32", .{});
        zfltk_lib.linkSystemLibrary("comdlg32", .{});
        zfltk_lib.linkSystemLibrary("winspool", .{});
        zfltk_lib.linkSystemLibrary("user32", .{});
        zfltk_lib.linkSystemLibrary("kernel32", .{});
        zfltk_lib.linkSystemLibrary("odbc32", .{});
        zfltk_lib.linkSystemLibrary("gdiplus", .{});
        zfltk_lib.linkSystemLibrary("opengl32", .{});
        zfltk_lib.linkSystemLibrary("glu32", .{});
    } else if (target.isDarwin()) {
        zfltk_lib.linkFramework("Carbon", .{});
        zfltk_lib.linkFramework("Cocoa", .{});
        zfltk_lib.linkFramework("ApplicationServices", .{});
        zfltk_lib.linkFramework("OpenGL", .{});
        zfltk_lib.linkFramework("UniformTypeIdentifiers", .{});
    } else {
        if (opts.use_wayland) {
            zfltk_lib.linkSystemLibrary("wayland-client", .{});
            zfltk_lib.linkSystemLibrary("wayland-cursor", .{});
            zfltk_lib.linkSystemLibrary("xkbcommon", .{});
            zfltk_lib.linkSystemLibrary("dbus-1", .{});
            zfltk_lib.linkSystemLibrary("EGL", .{});
            zfltk_lib.linkSystemLibrary("wayland-egl", .{});
        }
        zfltk_lib.linkSystemLibrary("GL", .{});
        zfltk_lib.linkSystemLibrary("GLU", .{});
        zfltk_lib.linkSystemLibrary("pthread", .{});
        zfltk_lib.linkSystemLibrary("X11", .{});
        zfltk_lib.linkSystemLibrary("Xext", .{});
        zfltk_lib.linkSystemLibrary("Xinerama", .{});
        zfltk_lib.linkSystemLibrary("Xcursor", .{});
        zfltk_lib.linkSystemLibrary("Xrender", .{});
        zfltk_lib.linkSystemLibrary("Xfixes", .{});
        zfltk_lib.linkSystemLibrary("Xft", .{});
        zfltk_lib.linkSystemLibrary("fontconfig", .{});
        zfltk_lib.linkSystemLibrary("pango-1.0", .{});
        zfltk_lib.linkSystemLibrary("pangoxft-1.0", .{});
        zfltk_lib.linkSystemLibrary("gobject-2.0", .{});
        zfltk_lib.linkSystemLibrary("cairo", .{});
        zfltk_lib.linkSystemLibrary("pangocairo-1.0", .{});
    }
}
