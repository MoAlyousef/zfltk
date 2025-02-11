const std = @import("std");
const Build = std.Build;

pub const SdkOpts = struct {
    build_examples: bool = false,
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

var opts: SdkOpts = undefined;

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    opts = SdkOpts{
        .build_examples = b.option(bool, "zfltk-build-examples", "Build zfltk examples") orelse false,
    };

    const zfltk = b.addModule("zfltk", .{
        .root_source_file = b.path("src/zfltk.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .link_libcpp = true,
    });

    zfltk.linkSystemLibrary("cfltk", .{ .preferred_link_mode = .static });
    zfltk.linkSystemLibrary("fltk", .{ .preferred_link_mode = .static });
    zfltk.linkSystemLibrary("fltk_images", .{ .preferred_link_mode = .static });
    zfltk.linkSystemLibrary("fltk_png", .{ .preferred_link_mode = .static });
    zfltk.linkSystemLibrary("fltk_jpeg", .{ .preferred_link_mode = .static });
    zfltk.linkSystemLibrary("fltk_z", .{ .preferred_link_mode = .static });
    zfltk.linkSystemLibrary("fltk_gl", .{ .preferred_link_mode = .static });

    const target_os = try std.zig.system.resolveTargetQuery(.{});
    if (target_os.os.tag == .windows) {
        zfltk.linkSystemLibrary("ws2_32", .{});
        zfltk.linkSystemLibrary("comctl32", .{});
        zfltk.linkSystemLibrary("gdi32", .{});
        zfltk.linkSystemLibrary("oleaut32", .{});
        zfltk.linkSystemLibrary("ole32", .{});
        zfltk.linkSystemLibrary("uuid", .{});
        zfltk.linkSystemLibrary("shell32", .{});
        zfltk.linkSystemLibrary("advapi32", .{});
        zfltk.linkSystemLibrary("comdlg32", .{});
        zfltk.linkSystemLibrary("winspool", .{});
        zfltk.linkSystemLibrary("user32", .{});
        zfltk.linkSystemLibrary("kernel32", .{});
        zfltk.linkSystemLibrary("odbc32", .{});
        zfltk.linkSystemLibrary("gdiplus", .{});
        zfltk.linkSystemLibrary("opengl32", .{});
        zfltk.linkSystemLibrary("glu32", .{});
    } else if (target_os.isDarwin()) {
        zfltk.linkFramework("Carbon", .{});
        zfltk.linkFramework("Cocoa", .{});
        zfltk.linkFramework("ApplicationServices", .{});
        zfltk.linkFramework("OpenGL", .{});
        zfltk.linkFramework("UniformTypeIdentifiers", .{});
    } else {
        zfltk.linkSystemLibrary("wayland-client", .{});
        zfltk.linkSystemLibrary("wayland-cursor", .{});
        zfltk.linkSystemLibrary("xkbcommon", .{});
        zfltk.linkSystemLibrary("dbus-1", .{});
        zfltk.linkSystemLibrary("EGL", .{});
        zfltk.linkSystemLibrary("wayland-egl", .{});
        zfltk.linkSystemLibrary("GL", .{});
        zfltk.linkSystemLibrary("GLU", .{});
        zfltk.linkSystemLibrary("pthread", .{});
        zfltk.linkSystemLibrary("X11", .{});
        zfltk.linkSystemLibrary("Xext", .{});
        zfltk.linkSystemLibrary("Xinerama", .{});
        zfltk.linkSystemLibrary("Xcursor", .{});
        zfltk.linkSystemLibrary("Xrender", .{});
        zfltk.linkSystemLibrary("Xfixes", .{});
        zfltk.linkSystemLibrary("Xft", .{});
        zfltk.linkSystemLibrary("fontconfig", .{});
        zfltk.linkSystemLibrary("pango-1.0", .{});
        zfltk.linkSystemLibrary("pangoxft-1.0", .{});
        zfltk.linkSystemLibrary("gobject-2.0", .{});
        zfltk.linkSystemLibrary("cairo", .{});
        zfltk.linkSystemLibrary("pangocairo-1.0", .{});
    }

    if (opts.build_examples) {
        const examples_step = b.step("examples", "build the zfltk examples");
        for (examples) |ex| {
            const exe = b.addExecutable(.{
                .name = ex.output,
                .root_source_file = b.path(ex.input),
                .target = target,
                .optimize = optimize,
            });

            exe.root_module.addImport("zfltk", zfltk);
            examples_step.dependOn(&exe.step);
            b.installArtifact(exe);
        }
    }
}
