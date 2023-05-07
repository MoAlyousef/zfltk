const zfltk = @import("zfltk");
const app = zfltk.app;
const Window = zfltk.Window;
const Button = zfltk.Button;
const Box = zfltk.Box;
const Color = zfltk.enums.Color;

fn butCb(but: *Button(.normal), data: ?*anyopaque) void {
    var box = Box.fromRaw(data.?);

    box.setLabel("Hello World!");

    but.setColor(Color.fromName(.cyan));
}

pub fn main() !void {
    try app.init();
    app.setScheme(.gtk);

    var win = try Window.init(.{
        .w = 400,
        .h = 300,

        .label = "Hello",
    });

    var but = try Button(.normal).init(.{
        .x = 160,
        .y = 220,
        .w = 80,
        .h = 40,

        .label = "Click me!",
    });

    var box = try Box.init(.{
        .x = 10,
        .y = 10,
        .w = 380,
        .h = 180,

        .boxtype = .up,
    });

    box.setLabelFont(.courier);
    box.setLabelSize(18);

    win.group().end();
    win.widget().show();

    but.setCallbackEx(butCb, box);
    try app.run();
}
