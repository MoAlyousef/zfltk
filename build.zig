const std = @import("std");
const fs = std.fs;
const Builder = std.build.Builder;

pub const Example = struct {
    description: ?[]const u8,
    output: []const u8,
    input: []const u8,

    pub fn new(output: []const u8, input: []const u8, desc: ?[]const u8) Example {
        return Example{
            .description = desc,
            .output = output,
            .input = input,
        };
    }
};

const examples = &[_]Example{
    Example.new("simple", "examples/simple.zig", "A simple hello world app"),
    Example.new("capi", "examples/capi.zig", "Using the C-api directly"),
    Example.new("image", "examples/image.zig", "Simple image example"),
    Example.new("input", "examples/input.zig", "Simple input example"),
    Example.new("mixed", "examples/mixed.zig", "Mixing both c and zig apis"),
    Example.new("editor", "examples/editor.zig", "More complex example"),
    Example.new("layout", "examples/layout.zig", "Layout example"),
    Example.new("valuators", "examples/valuators.zig", "valuators example"),
    Example.new("channels", "examples/channels.zig", "Use messages to handle events"),
    Example.new("editormsgs", "examples/editormsgs.zig", "Use messages in the editor example"),
    Example.new("browser", "examples/browser.zig", "Browser example"),
    Example.new("svg", "examples/svg.zig", "svg example"),
};

pub fn build(b: *Builder) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const examples_step = b.step("examples", "build the examples");
    b.default_step.dependOn(examples_step);

    for (examples) |example| {
        const exe = b.addExecutable(example.output, example.input);
        exe.setTarget(target);
        exe.setBuildMode(mode);
        exe.addPackagePath("zfltk", "src/zfltk.zig");
        exe.linkSystemLibrary("cfltk");
        exe.linkSystemLibrary("fltk");
        exe.linkSystemLibrary("fltk_images");
        exe.linkSystemLibrary("fltk_png");
        exe.linkSystemLibrary("fltk_jpeg");
        exe.linkSystemLibrary("fltk_z");
        exe.linkSystemLibrary("c");
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
        }
        examples_step.dependOn(&exe.step);
        b.installArtifact(exe);

        const run_cmd = exe.run();
        const run_step = b.step(b.fmt("run-{s}", .{example.output}), example.description.?);
        run_step.dependOn(&run_cmd.step);
    }
}

