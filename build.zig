const std = @import("std");
const Sdk = @import("sdk.zig");
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
};

pub fn build(b: *Builder) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();
    const sdk = Sdk.init(b);

    const examples_step = b.step("examples", "build the examples");
    b.default_step.dependOn(examples_step);

    for (examples) |example| {
        const exe = b.addExecutable(example.output, example.input);
        exe.setTarget(target);
        exe.setBuildMode(mode);
        exe.addPackagePath("zfltk", "src/zfltk.zig");
        try sdk.link(exe);
        examples_step.dependOn(&exe.step);
        b.installArtifact(exe);

        const run_cmd = exe.run();
        const run_step = b.step(b.fmt("run-{s}", .{example.output}), example.description.?);
        run_step.dependOn(&run_cmd.step);
    }
}

