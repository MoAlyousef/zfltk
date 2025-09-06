const zfltk = @import("zfltk");
const app = zfltk.app;
const Window = zfltk.window.Window;
const Button = zfltk.button.Button;
const Box = zfltk.box.Box;
const Color = zfltk.enums.Color;

fn butCb(but: *Button, data: ?*anyopaque) void {
    const box = Box.fromRaw(data.?);

    box.widget_methods().setLabel("Hello World!");

    but.widget_methods().setColor(Color.fromName(.cyan));
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

    but.own_methods().setDownBox(.flat);

    const box = try Box.init(.{
        .x = 10,
        .y = 10,
        .w = 380,
        .h = 180,

        .boxtype = .up,
    });

    box.widget_methods().setLabelFont(.courier);
    box.widget_methods().setLabelSize(18);

    win.group_methods().end();
    win.widget_methods().show();

    but.widget_methods().setCallbackEx(butCb, box);
    try app.run();
}
