const std = @import("std");
const Build = std.Build;
const CompileStep = std.build.CompileStep;

pub fn cfltk_build_from_source(b: *Build, finalize_cfltk: *Build.Step, install_prefix: []const u8, use_wayland: bool) !void {
    // const zig_exe = b.zig_exe;
    // var zig_cc_buf: [250]u8 = undefined;
    // var zig_cpp_buf: [250]u8 = undefined;
    // const zig_cc = try std.fmt.bufPrint(zig_cc_buf[0..], "-DCMAKE_C_COMPILER={s};cc", .{zig_exe});
    // const zig_cpp = try std.fmt.bufPrint(zig_cpp_buf[0..], "-DCMAKE_CXX_COMPILER={s};c++", .{zig_exe});
    const target = b.host.target;
    var buf: [1024]u8 = undefined;
    var sdk_lib_dir = try std.fmt.bufPrint(buf[0..], "{s}/cfltk/lib", .{install_prefix});
    _ = std.fs.cwd().openDir(sdk_lib_dir, .{}) catch |err| {
        std.debug.print("Warning: {!}. The cfltk library will be rebuilt from source!\n", .{err});
        var bin_buf: [250]u8 = undefined;
        var src_buf: [250]u8 = undefined;
        var inst_buf: [250]u8 = undefined;
        var cmake_bin_path = try std.fmt.bufPrint(bin_buf[0..], "{s}/cfltk/bin", .{install_prefix});
        var cmake_src_path = try std.fmt.bufPrint(src_buf[0..], "{s}/cfltk", .{install_prefix});
        var cmake_inst_path = try std.fmt.bufPrint(inst_buf[0..], "-DCMAKE_INSTALL_PREFIX={s}/cfltk/lib", .{install_prefix});
        var zfltk_config: *std.Build.Step.Run = undefined;
        if (target.os.tag == .windows) {
            zfltk_config = b.addSystemCommand(&[_][]const u8{
                "cmake",
                "-B",
                cmake_bin_path,
                "-S",
                cmake_src_path,
                "-GNinja",
                "-DCMAKE_BUILD_TYPE=Release",
//                zig_cc,
//               zig_cpp,
                cmake_inst_path,
                "-DFLTK_BUILD_TEST=OFF",
                "-DOPTION_USE_SYSTEM_LIBPNG=OFF",
                "-DOPTION_USE_SYSTEM_LIBJPEG=OFF",
                "-DOPTION_USE_SYSTEM_ZLIB=OFF",
                "-DOPTION_USE_GL=ON",
                "-DCFLTK_USE_OPENGL=ON",
                "-DFLTK_BUILD_FLUID=OFF",
                "-DFLTK_BUILD_FLTK_OPTIONS=OFF",
            });
        } else if (target.isDarwin()) {
            zfltk_config = b.addSystemCommand(&[_][]const u8{
                "cmake",
                "-B",
                cmake_bin_path,
                "-S",
                cmake_src_path,
                "-DCMAKE_BUILD_TYPE=Release",
                // zig_cc,
                // zig_cpp,
                cmake_inst_path,
                "-DFLTK_BUILD_TEST=OFF",
                "-DOPTION_USE_SYSTEM_LIBPNG=OFF",
                "-DOPTION_USE_SYSTEM_LIBJPEG=OFF",
                "-DOPTION_USE_SYSTEM_ZLIB=OFF",
                "-DOPTION_USE_GL=ON",
                "-DCFLTK_USE_OPENGL=ON",
                "-DFLTK_BUILD_FLUID=OFF",
                "-DFLTK_BUILD_FLTK_OPTIONS=OFF",
            });
        } else {
            if (use_wayland) {
                zfltk_config = b.addSystemCommand(&[_][]const u8{
                    "cmake",
                    "-B",
                    cmake_bin_path,
                    "-S",
                    cmake_src_path,
                    "-DCMAKE_BUILD_TYPE=Release",
                    // zig_cc,
                    // zig_cpp,
                    cmake_inst_path,
                    "-DFLTK_BUILD_TEST=OFF",
                    "-DOPTION_USE_SYSTEM_LIBPNG=OFF",
                    "-DOPTION_USE_SYSTEM_LIBJPEG=OFF",
                    "-DOPTION_USE_SYSTEM_ZLIB=OFF",
                    "-DOPTION_USE_GL=ON",
                    "-DCFLTK_USE_OPENGL=ON",
                    "-DOPTION_USE_WAYLAND=ON",
                    "-DFLTK_BUILD_FLUID=OFF",
                    "-DFLTK_BUILD_FLTK_OPTIONS=OFF",
                    "-DOPTION_ALLOW_GTK_PLUGIN=OFF",
                });
            } else {
                zfltk_config = b.addSystemCommand(&[_][]const u8{
                    "cmake",
                    "-B",
                    cmake_bin_path,
                    "-S",
                    cmake_src_path,
                    "-DCMAKE_BUILD_TYPE=Release",
                    // zig_cc,
                    // zig_cpp,
                    cmake_inst_path,
                    "-DFLTK_BUILD_TEST=OFF",
                    "-DOPTION_USE_SYSTEM_LIBPNG=OFF",
                    "-DOPTION_USE_SYSTEM_LIBJPEG=OFF",
                    "-DOPTION_USE_SYSTEM_ZLIB=OFF",
                    "-DOPTION_USE_PANGO=ON", // enable if rtl/cjk font support is needed
                    "-DOPTION_USE_GL=ON",
                    "-DCFLTK_USE_OPENGL=ON",
                    "-DOPTION_USE_WAYLAND=OFF",
                    "-DOPTION_USE_CAIRO=ON",
                    "-DFLTK_BUILD_FLUID=OFF",
                    "-DFLTK_BUILD_FLTK_OPTIONS=OFF",
                });
            }
        }
        _ = std.fs.cwd().openDir(cmake_src_path, .{}) catch |git_err| {
            std.debug.print("Warning: {!}. The cfltk library will be grabbed!\n", .{git_err});
            const cfltk_fetch = b.addSystemCommand(&[_][]const u8{ "git", "clone", "https://github.com/MoAlyousef/cfltk", cmake_src_path, "--depth=1", "--recurse-submodules" });
            zfltk_config.step.dependOn(&cfltk_fetch.step);
        };
        const zfltk_build = b.addSystemCommand(&[_][]const u8{
            "cmake",
            "--build",
            cmake_bin_path,
            "--config",
            "Release",
            "--parallel",
        });
        zfltk_build.step.dependOn(&zfltk_config.step);

        // This only needs to run once!
        const zfltk_install = b.addSystemCommand(&[_][]const u8{
            "cmake",
            "--install",
            cmake_bin_path,
        });
        zfltk_install.step.dependOn(&zfltk_build.step);
        finalize_cfltk.dependOn(&zfltk_install.step);
    };
}

pub fn cfltk_link(exe: *CompileStep, install_prefix: []const u8, use_wayland: bool) !void {
    var buf: [1024]u8 = undefined;
    const target = exe.target;
    var inc_dir = try std.fmt.bufPrint(buf[0..], "{s}/cfltk/include", .{install_prefix});
    exe.addIncludePath(inc_dir);
    var lib_dir = try std.fmt.bufPrint(buf[0..], "{s}/cfltk/lib/lib", .{install_prefix});
    exe.addLibraryPath(lib_dir);
    exe.linkSystemLibrary("cfltk");
    exe.linkSystemLibrary("fltk");
    exe.linkSystemLibrary("fltk_images");
    exe.linkSystemLibrary("fltk_png");
    exe.linkSystemLibrary("fltk_jpeg");
    exe.linkSystemLibrary("fltk_z");
    exe.linkSystemLibrary("fltk_gl");
    exe.linkLibC();
    exe.linkLibCpp();
    if (target.isWindows()) {
        exe.linkSystemLibrary("ws2_32");
        exe.linkSystemLibrary("comctl32");
        exe.linkSystemLibrary("gdi32");
        exe.linkSystemLibrary("oleaut32");
        exe.linkSystemLibrary("ole32");
        exe.linkSystemLibrary("uuid");
        exe.linkSystemLibrary("shell32");
        exe.linkSystemLibrary("advapi32");
        exe.linkSystemLibrary("comdlg32");
        exe.linkSystemLibrary("winspool");
        exe.linkSystemLibrary("user32");
        exe.linkSystemLibrary("kernel32");
        exe.linkSystemLibrary("odbc32");
        exe.linkSystemLibrary("gdiplus");
        exe.linkSystemLibrary("opengl32");
        exe.linkSystemLibrary("glu32");
    } else if (target.isDarwin()) {
        exe.linkFramework("Carbon");
        exe.linkFramework("Cocoa");
        exe.linkFramework("ApplicationServices");
        exe.linkFramework("OpenGL");
    } else {
        if (use_wayland) {
            exe.linkSystemLibrary("wayland-client");
            exe.linkSystemLibrary("wayland-cursor");
            exe.linkSystemLibrary("xkbcommon");
            exe.linkSystemLibrary("dbus-1");
            exe.linkSystemLibrary("EGL");
            exe.linkSystemLibrary("wayland-egl");
        }
        exe.linkSystemLibrary("GL");
        exe.linkSystemLibrary("GLU");
        exe.linkSystemLibrary("pthread");
        exe.linkSystemLibrary("X11");
        exe.linkSystemLibrary("Xext");
        exe.linkSystemLibrary("Xinerama");
        exe.linkSystemLibrary("Xcursor");
        exe.linkSystemLibrary("Xrender");
        exe.linkSystemLibrary("Xfixes");
        exe.linkSystemLibrary("Xft");
        exe.linkSystemLibrary("fontconfig");
        exe.linkSystemLibrary("pango-1.0");
        exe.linkSystemLibrary("pangoxft-1.0");
        exe.linkSystemLibrary("gobject-2.0");
        exe.linkSystemLibrary("cairo");
        exe.linkSystemLibrary("pangocairo-1.0");
    }
}

pub const Example = struct {
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
};