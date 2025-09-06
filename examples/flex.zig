const zfltk = @import("zfltk");
const app = zfltk.app;
const Window = zfltk.window.Window;
const Box = zfltk.box.Box;
const Button = zfltk.button.Button;
const Flex = zfltk.group.Flex;
const Color = zfltk.enums.Color;

pub fn main() !void {
    try app.init();

    var win = try Window.init(.{
        .w = 400,
        .h = 300,

        .label = "Hello",
    });

    var flex = try Flex.init(.{
        .w = 400,
        .h = 300,

        // The orientation is vertical by default so this isn't necessary to
        // set; this is just for reference
        .orientation = .vertical,
        .spacing = 6,
    });

    win.group_methods().resizable(flex);

    var btn = try Button.init(.{
        .h = 48,
        .label = "Button",
    });

    // This demonstrates how you can add inline widgets which have no purpose
    // besides aesthetics. This could be useful for spacers and whatnot
    flex.group_methods().add(.{
        try Box.init(.{ .boxtype = .down }),
        btn,
        try Box.init(.{ .boxtype = .down }),
    });

    flex.group_methods().fixed(btn, btn.widget_methods().h());

    // Flex has its own `end` method which recalculates layouts but the API
    // remains consistent by utilizing Zig's comptime
    flex.group_methods().end();

    win.group_methods().end();
    win.widget_methods().show();
    try app.run();
}
