const std = @import("std");
const Sdk = @import("sdk.zig");
const fs = std.fs;
const Builder = std.build.Builder;

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

const examples = &[_]Example{
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
    // Disable until this example is updated to the new API
    //    Example.init("editormsgs", "examples/editormsgs.zig", "Use messages in the editor example"),
    Example.init("browser", "examples/browser.zig", "Browser example"),
    Example.init("flex", "examples/flex.zig", "Flex example"),
    Example.init("threadawake", "examples/threadawake.zig", "Thread awake example"),
};

pub fn build(b: *Builder) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardOptimizeOption(.{});
    const sdk = try Sdk.init(b, ".");

    const examples_step = b.step("examples", "build the examples");
    b.default_step.dependOn(examples_step);

    const zfltk_module = b.createModule(.{
        .source_file = .{ .path = "src/zfltk.zig" },
    });

    for (examples) |example| {
        const exe = b.addExecutable(.{
            .name = example.output,
            .root_source_file = .{.path = example.input },
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
