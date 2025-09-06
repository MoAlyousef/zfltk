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

    box.widget_methods().setLabel("Hello World!");

    but.widget_methods().setColor(Color.fromName(.cyan));
}

fn boxEventHandler(_: *Box, ev: Event, data: ?*anyopaque) bool {
    const btn = Button.fromRaw(data.?);
    switch (ev) {
        .push => {
            std.debug.print("Click the button: {s}\n", .{btn.widget_methods().label()});
            return true;
        },
        else => return false,
    }
}

fn boxDrawHandler(box: *Box) void {
    draw.setLineStyle(.DashDot, 2);
    draw.rectWithColor(box.widget_methods().x() + 10, box.widget_methods().y() + 10, box.widget_methods().w() - 20, box.widget_methods().h() - 20, Color.fromName(.cyan));
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

    but.own_methods().setDownBox(.flat);

    var box = try Box.init(.{
        .x = 10,
        .y = 10,
        .w = 380,
        .h = 180,
        .label = "Hello",
        .boxtype = .up,
    });

    box.widget_methods().setEventHandlerEx(boxEventHandler, but);
    box.widget_methods().setDrawHandler(boxDrawHandler);

    box.widget_methods().setLabelFont(.courier);
    box.widget_methods().setLabelSize(18);

    win.group_methods().end();
    win.widget_methods().show();

    but.widget_methods().setCallbackEx(butCb, box);
    try app.run();
}
