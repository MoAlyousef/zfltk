const zfltk = @import("zfltk");
const app = zfltk.app;
const Window = zfltk.window.Window;
const Button = zfltk.button.Button;
const Box = zfltk.box.Box;
const Color = zfltk.enums.Color;
const Event = zfltk.enums.Event;
const std = @import("std");
const draw = zfltk.draw;

fn butCb(but: *Button, data: ?*anyopaque) void {
    var box = Box.fromRaw(data.?);

    box.asWidget().setLabel("Hello World!");

    but.asWidget().setColor(Color.fromName(.cyan));
}

fn boxEventHandler(_: *Box, ev: Event, data: ?*anyopaque) bool {
    const btn = Button.fromRaw(data.?);
    switch (ev) {
        .push => {
            std.debug.print("Click the button: {s}\n", .{btn.asWidget().label()});
            return true;
        },
        else => return false,
    }
}

fn boxDrawHandler(box: *Box) void {
    draw.setLineStyle(.DashDot, 2);
    draw.rectWithColor(box.asWidget().x() + 10, box.asWidget().y() + 10, box.asWidget().w() - 20, box.asWidget().h() - 20, Color.fromName(.cyan));
}

pub fn main() !void {
    try app.init();
    app.setScheme(.gtk);

    var win = try Window.init(.{
        .w = 400,
        .h = 300,

        .label = "Hello",
    });

    var but = try Button.init(.{
        .x = 160,
        .y = 220,
        .w = 80,
        .h = 40,

        .label = "Click me!",
    });

    but.asBase().setDownBox(.flat);

    var box = try Box.init(.{
        .x = 10,
        .y = 10,
        .w = 380,
        .h = 180,
        .label = "Hello",
        .boxtype = .up,
    });

    box.asWidget().setEventHandlerEx(boxEventHandler, but);
    box.asWidget().setDrawHandler(boxDrawHandler);

    box.asWidget().setLabelFont(.courier);
    box.asWidget().setLabelSize(18);

    win.asGroup().end();
    win.asWidget().show();

    but.asWidget().setCallbackEx(butCb, box);
    try app.run();
}
