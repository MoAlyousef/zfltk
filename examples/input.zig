const zfltk = @import("zfltk");
const app = zfltk.app;
const widget = zfltk.widget;
const box = zfltk.box;
const Event = zfltk.enums.Event;
const input = zfltk.input;
const group = zfltk.group;
const window = zfltk.window;
const button = zfltk.button;
const std = @import("std");

pub fn butCb(ev: i32, data: ?*c_void) callconv(.C) i32 {
    switch (@intToEnum(Event, ev)) {
        Event.Push => {
            app.send(1);
            return 1;
        },
        Event.Released => {
            app.send(2);
            return 1;
        },
        else => return 0,    
    }
    return 0;
}

pub fn main() !void {
    try app.init();
    var win = window.Window.new(100, 100, 400, 300, "Hello");
    var inp = input.Input.new(10, 10, 380, 40, "");
    var mybox = box.Box.new(10, 20, 380, 200, "");
    var but = button.Button.new(160, 200, 80, 40, "Greet!");
    win.asGroup().end();
    win.asWidget().show();
    but.handle(butCb, null);
    while (app.wait()) {
        if (app.recv()) |msg| switch (msg) {
            1 => {
                var buf: [100]u8 = undefined;
                const name = try std.fmt.bufPrintZ(buf[0..], "Hello {s}!", .{inp.value()});
                mybox.asWidget().setLabel(name);
            },
            2 => {
                mybox.asWidget().setLabel("");
            },
            else => {},
        };
    }
}