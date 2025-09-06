const zfltk = @import("zfltk");
const app = zfltk.app;
const Window = zfltk.window.Window;
const Button = zfltk.button.Button;
const Box = zfltk.box.Box;
const Color = zfltk.enums.Color;

fn butCb(but: *Button, data: ?*anyopaque) void {
    const box = Box.fromRaw(data.?);

    box.asWidget().setLabel("Hello World!");

    but.asWidget().setColor(Color.fromName(.cyan));
}

pub fn main() !void {
    try app.init();
    app.setScheme(.gtk);

    const win = try Window.init(.{
        .w = 400,
        .h = 300,

        .label = "Hello",
    });
    win.freePosition();

    const but = try Button.init(.{
        .x = 160,
        .y = 220,
        .w = 80,
        .h = 40,

        .label = "Click me!",
    });

    but.asBase().setDownBox(.flat);

    const box = try Box.init(.{
        .x = 10,
        .y = 10,
        .w = 380,
        .h = 180,

        .boxtype = .up,
    });

    box.asWidget().setLabelFont(.courier);
    box.asWidget().setLabelSize(18);

    win.asGroup().end();
    win.asWidget().show();

    but.asWidget().setCallbackEx(butCb, box);
    try app.run();
}
