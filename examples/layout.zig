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

    var pack = try Group(.pack).init(.{
        .w = 400,
        .h = 300,

        // The orientation is vertical by default so this isn't necessary to
        // set; this is just for reference
        .orientation = .vertical,
        .spacing = 6,
    });

    win.resizable(pack);

    var btn = try Button(.normal).init(.{
        .h = 48,
        .label = "Button",
    });

    // In pack groups, the size must be provided as they don't automatically
    // adjust like flex groups. See `flex.zig`
    pack.add(.{
        try Box.init(.{ .h = 48, .boxtype = .down }),
        btn,
        try Box.init(.{ .h = 48, .boxtype = .down }),
    });

    // Flex has its own `end` method which recalculates layouts but the API
    // remains consistent by utilizing Zig's comptime
    pack.end();

    win.end();
    win.show();
    try app.run();
}
