const std = @import("std");
const build = std.build;
const Builder = build.Builder;
const fs = std.fs;
const LibExeObjStep = build.LibExeObjStep;

const Sdk = @This();
builder: *Builder,
path: []const u8,
finalize_cfltk: *std.Build.Step,

pub fn init(b: *Builder, sdk_path: []const u8) !*Sdk {
    const zig_exe = b.zig_exe;
    var zig_cc_buf: [250]u8 = undefined;
    var zig_cpp_buf: [250]u8 = undefined;
    const zig_cc = try std.fmt.bufPrint(zig_cc_buf[0..], "-DCMAKE_C_COMPILER={s};cc", .{zig_exe});
    const zig_cpp = try std.fmt.bufPrint(zig_cpp_buf[0..], "-DCMAKE_CXX_COMPILER={s};c++", .{zig_exe});
    const target = b.host.target;
    var buf: [1024]u8 = undefined;
    var sdk_lib_dir = try std.fmt.bufPrint(buf[0..], "{s}/vendor/lib", .{sdk_path});
    const finalize_cfltk = b.step("finalize cfltk install", "Installs cfltk");
    _ = fs.cwd().openDir(sdk_lib_dir, .{}) catch |err| {
        std.debug.print("Warning: {!}. The cfltk library will be grabbed and built from source!\n", .{err});
        var bin_buf: [250]u8 = undefined;
        var src_buf: [250]u8 = undefined;
        var inst_buf: [250]u8 = undefined;
        var cmake_bin_path = try std.fmt.bufPrint(bin_buf[0..], "{s}/vendor/bin", .{sdk_path});
        var cmake_src_path = try std.fmt.bufPrint(src_buf[0..], "{s}/vendor/cfltk", .{sdk_path});
        var cmake_inst_path = try std.fmt.bufPrint(inst_buf[0..], "-DCMAKE_INSTALL_PREFIX={s}/vendor/lib", .{sdk_path});
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
                zig_cc,
                zig_cpp,
                cmake_inst_path,
                "-DFLTK_BUILD_TEST=OFF",
                "-DOPTION_USE_SYSTEM_LIBPNG=OFF",
                "-DOPTION_USE_SYSTEM_LIBJPEG=OFF",
                "-DOPTION_USE_SYSTEM_ZLIB=OFF",
                "-DOPTION_USE_GL=ON",
                "-DCFLTK_USE_OPENGL=ON",
                "-DFLTK_BUILD_FLUID=OFF",
            });
        } else if (target.isDarwin()) {
            zfltk_config = b.addSystemCommand(&[_][]const u8{
                "cmake",
                "-B",
                cmake_bin_path,
                "-S",
                cmake_src_path,
                "-DCMAKE_BUILD_TYPE=Release",
                zig_cc,
                zig_cpp,
                cmake_inst_path,
                "-DFLTK_BUILD_TEST=OFF",
                "-DOPTION_USE_SYSTEM_LIBPNG=OFF",
                "-DOPTION_USE_SYSTEM_LIBJPEG=OFF",
                "-DOPTION_USE_SYSTEM_ZLIB=OFF",
                "-DOPTION_USE_GL=ON",
                "-DCFLTK_USE_OPENGL=ON",
                "-DFLTK_BUILD_FLUID=OFF",
            });
        } else {
            zfltk_config = b.addSystemCommand(&[_][]const u8{
                "cmake",
                "-B",
                cmake_bin_path,
                "-S",
                cmake_src_path,
                "-DCMAKE_BUILD_TYPE=Release",
                zig_cc,
                zig_cpp,
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
            });
        }
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
    b.default_step.dependOn(finalize_cfltk);
    const sdk = b.allocator.create(Sdk) catch @panic("out of memory");
    sdk.* = .{
        .builder = b,
        .path = sdk_path,
        .finalize_cfltk = finalize_cfltk,
    };
    return sdk;
}

pub fn link(sdk: *Sdk, exe: *LibExeObjStep) !void {
    exe.step.dependOn(sdk.finalize_cfltk);
    const sdk_path = sdk.path;
    var buf: [1024]u8 = undefined;
    const target = exe.target;
    var inc_dir = try std.fmt.bufPrint(buf[0..], "{s}/vendor/cfltk/include", .{sdk_path});
    exe.addIncludePath(inc_dir);
    var lib_dir = try std.fmt.bufPrint(buf[0..], "{s}/vendor/lib/lib", .{sdk_path});
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
        exe.linkSystemLibrary("GL");
        exe.linkSystemLibrary("GLU");
    }
}
