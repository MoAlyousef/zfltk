const std = @import("std");
const build = std.build;
const Builder = build.Builder;
const fs = std.fs;
const LibExeObjStep = build.LibExeObjStep;

const Sdk = @This();
builder: *Builder,

pub fn init(b: *Builder) *Sdk {
    const sdk = b.allocator.create(Sdk) catch @panic("out of memory");
    sdk.* = .{
        .builder = b,
    };
    return sdk;
}

pub fn link(sdk: *Sdk, exe: *LibExeObjStep) !void {
    const b = sdk.builder;
    const target = exe.target;
    _ = fs.cwd().openDir("vendor/lib", .{}) catch |err| {
        std.debug.print("Warning: {!}. The cfltk library will be grabbed and built from source!\n", .{err});
        const zfltk_init = b.addSystemCommand(&[_][]const u8{
            "git",
            "submodule",
            "update",
            "--init",
            "--recursive",
            "--depth=1",
        });
        try zfltk_init.step.make();

        if (target.isWindows() or target.isDarwin()) {
            const zfltk_config = b.addSystemCommand(&[_][]const u8{
                "cmake",
                "-B",
                "vendor/bin",
                "-S",
                "vendor/cfltk",
                "-DCMAKE_BUILD_TYPE=Release",
                "-DCMAKE_INSTALL_PREFIX=vendor/lib",
                "-DFLTK_BUILD_TEST=OFF",
                "-DOPTION_USE_SYSTEM_LIBPNG=OFF",
                "-DOPTION_USE_SYSTEM_LIBJPEG=OFF",
                "-DOPTION_USE_SYSTEM_ZLIB=OFF",
                "-DOPTION_USE_GL=ON",
                "-DCFLTK_USE_OPENGL=ON",
            });
            try zfltk_config.step.make();
        } else {
            const zfltk_config = b.addSystemCommand(&[_][]const u8{
                "cmake",
                "-B",
                "vendor/bin",
                "-S",
                "vendor/cfltk",
                "-DCMAKE_BUILD_TYPE=Release",
                "-DCMAKE_INSTALL_PREFIX=vendor/lib",
                "-DFLTK_BUILD_TEST=OFF",
                "-DOPTION_USE_SYSTEM_LIBPNG=OFF",
                "-DOPTION_USE_SYSTEM_LIBJPEG=OFF",
                "-DOPTION_USE_SYSTEM_ZLIB=OFF",
                "-DOPTION_USE_PANGO=ON", // enable if rtl/cjk font support is needed
                "-DOPTION_USE_GL=ON",
                "-DCFLTK_USE_OPENGL=ON",
                "-DOPTION_USE_WAYLAND=OFF",
                "-DOPTION_USE_CAIRO=ON",
            });
            try zfltk_config.step.make();
        }

        const zfltk_build = b.addSystemCommand(&[_][]const u8{
            "cmake",
            "--build",
            "vendor/bin",
            "--config",
            "Release",
            "--parallel",
        });
        try zfltk_build.step.make();

        // This only needs to run once!
        const zfltk_install = b.addSystemCommand(&[_][]const u8{
            "cmake",
            "--install",
            "vendor/bin",
        });
        try zfltk_install.step.make();
    };
    exe.addIncludePath("vendor/cfltk/include");
    exe.addLibraryPath("vendor/lib/lib");
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
