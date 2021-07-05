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

const ButtonMessage = enum(usize) {
    Pushed = 1,
    Released,
};

pub fn butCb(w: button.ButtonPtr, ev: i32, data: ?*c_void) callconv(.C) i32 {
    _ = w;
    _ = data;
    switch (@intToEnum(Event, ev)) {
        Event.Push => {
            app.send(ButtonMessage, .Pushed);
            return 1;
        },
        Event.Released => {
            app.send(ButtonMessage, .Released);
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
        if (app.recv(ButtonMessage)) |msg| switch (msg) {
            .Pushed => {
                var buf: [100]u8 = undefined;
                const name = try std.fmt.bufPrintZ(buf[0..], "Hello {s}!", .{inp.value()});
                mybox.asWidget().setLabel(name);
            },
            .Released => {
                mybox.asWidget().setLabel("");
            },
        };
    }
}