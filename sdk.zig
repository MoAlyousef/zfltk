const std = @import("std");
const build = std.build;
const Builder = build.Builder;
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

pub fn link(sdk: *Sdk, exe: *LibExeObjStep) void {
    _ = sdk;
    const target = exe.target;
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
    } else if (target.isDarwin()) {
        exe.addIncludePath("/usr/local/include");
        exe.addLibraryPath("/usr/local/lib");
        exe.linkFramework("Carbon");
        exe.linkFramework("Cocoa");
        exe.linkFramework("ApplicationServices");
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
