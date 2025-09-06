const zfltk = @import("zfltk");
const app = zfltk.app;
const Window = zfltk.window.Window;
const Box = zfltk.box.Box;
const Button = zfltk.button.Button;
const Pack = zfltk.group.Pack;
const Color = zfltk.enums.Color;

pub fn main() !void {
    try app.init();

    var win = try Window.init(.{
        .w = 400,
        .h = 300,

        .label = "Hello",
    });

    var pack = try Pack.init(.{
        .w = 400,
        .h = 300,

        // The orientation is vertical by default so this isn't necessary to
        // set; this is just for reference
        .orientation = .vertical,
        .spacing = 6,
    });

    win.group_methods().resizable(pack);

    const btn = try Button.init(.{
        .h = 48,
        .label = "Button",
    });

    // In pack groups, the size must be provided as they don't automatically
    // adjust like flex groups. See `flex.zig`
    pack.group_methods().add(.{
        try Box.init(.{ .h = 48, .boxtype = .down }),
        btn,
        try Box.init(.{ .h = 48, .boxtype = .down }),
    });

    // Flex has its own `end` method which recalculates layouts but the API
    // remains consistent by utilizing Zig's comptime
    pack.group_methods().end();

    win.group_methods().end();
    win.widget_methods().show();
    try app.run();
}
