const zfltk = @import("zfltk");
const std = @import("std");
const app = zfltk.app;
const Window = zfltk.window.Window;
const Button = zfltk.button.Button;
const Box = zfltk.box.Box;
const Color = zfltk.enums.Color;

var count: u32 = 0;

pub fn thread_func(data: ?*anyopaque) !void {
    var lighten = true;

    const d = data orelse unreachable;
    var mybox = Box.fromRaw(d);
    var buf: [256]u8 = undefined;

    while (true) {
        std.Thread.sleep(10_000_000);

        const val = try std.fmt.bufPrintZ(buf[0..], "Hello!\n{d}", .{count});

        mybox.widget_methods().setLabel(val);

        const col = mybox.widget_methods().labelColor();

        if (col.toHex() == 0xffffff) {
            lighten = false;
        } else if (col.toHex() == 0x000000) {
            lighten = true;
        }

        if (lighten) {
            mybox.widget_methods().setLabelColor(col.lighten(4));
        } else {
            mybox.widget_methods().setLabelColor(col.darken(4));
        }

        app.awake();
        count += 1;
    }
}

pub fn butCb(_: *Button, data: ?*anyopaque) void {
    var thread = std.Thread.spawn(.{}, thread_func, .{data}) catch {
        return;
    };

    thread.detach();
}

pub fn main() !void {
    try app.init();
    app.setScheme(.oxy);

    var win = try Window.init(.{
        .w = 400,
        .h = 300,

        .label = "Thread awake",
    });

    var but = try Button.init(.{
        .x = 120,
        .y = 220,
        .w = 160,
        .h = 40,

        .label = "Start threading!",
    });

    but.widget_methods().clearVisibleFocus();

    var mybox = try Box.init(.{
        .x = 10,
        .y = 10,
        .w = 380,
        .h = 180,

        .label = "Hello!\n ",
    });

    but.widget_methods().setCallbackEx(butCb, mybox.raw());
    mybox.widget_methods().setLabelSize(48);

    win.group_methods().end();
    win.widget_methods().show();

    try app.run();
}
