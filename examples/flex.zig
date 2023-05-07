const zfltk = @import("zfltk");
const app = zfltk.app;
const Window = zfltk.Window;
const Box = zfltk.Box;
const Button = zfltk.Button;
const Group = zfltk.Group;
const Color = enums.Color;
const enums = zfltk.enums;

pub fn main() !void {
    try app.init();

    var win = try Window.init(.{
        .w = 400,
        .h = 300,

        .label = "Hello",
    });

    var flex = try Group(.flex).init(.{
        .w = 400,
        .h = 300,

        // The orientation is vertical by default so this isn't necessary to
        // set; this is just for reference
        .orientation = .vertical,
        .spacing = 6,
    });

    win.group().resizable(flex);

    var btn = try Button(.normal).init(.{
        .h = 48,
        .label = "Button",
    });

    // This demonstrates how you can add inline widgets which have no purpose
    // besides aesthetics. This could be useful for spacers and whatnot
    flex.add(.{
        try Box.init(.{ .boxtype = .down }),
        btn,
        try Box.init(.{ .boxtype = .down }),
    });

    flex.fixed(btn, btn.h());

    // Flex has its own `end` method which recalculates layouts but the API
    // remains consistent by utilizing Zig's comptime
    flex.end();

    win.group().end();
    win.widget().show();
    try app.run();
}
