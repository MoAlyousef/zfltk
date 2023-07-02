const zfltk = @import("zfltk");
const app = zfltk.app;
const Window = zfltk.Window;
const Button = zfltk.Button;
const Box = zfltk.Box;
const Color = zfltk.enums.Color;
const Event = zfltk.enums.Event;
const std = @import("std");
const draw = zfltk.draw;

fn butCb(but: *Button(.normal), data: ?*anyopaque) void {
    var box = Box.fromRaw(data.?);

    box.setLabel("Hello World!");

    but.setColor(Color.fromName(.cyan));
}

fn boxEventHandler(_: *Box, ev: Event, data: ?*anyopaque) bool {
    const btn = Button(.normal).fromRaw(data.?);
    switch (ev) {
        .push => {
            std.debug.print("Click the button: {s}\n", .{btn.label()});
            return true;
        },
        else => return false,
    }
}

fn boxDrawHandler(box: *Box) void {
    draw.setLineStyle(.DashDot, 2);
    draw.rectWithColor(box.x() + 10, box.y() + 10, box.w() - 20, box.h() - 20, Color.fromName(.cyan));
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

    but.setDownBox(.flat);

    var box = try Box.init(.{
        .x = 10,
        .y = 10,
        .w = 380,
        .h = 180,
        .label = "Hello",
        .boxtype = .up,
    });

    box.setEventHandlerEx(boxEventHandler, but);
    box.setDrawHandler(boxDrawHandler);

    box.setLabelFont(.courier);
    box.setLabelSize(18);

    win.end();
    win.show();

    but.setCallbackEx(butCb, box);
    try app.run();
}
