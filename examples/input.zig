const zfltk = @import("zfltk");
const app = zfltk.app;
const widget = zfltk.widget;
const enums = zfltk.enums;
const input = zfltk.input;
const group = zfltk.group;
const window = zfltk.window;
const button = zfltk.button;
const std = @import("std");

pub fn butCb(ev: i32, data: ?*c_void) callconv(.C) i32 {
    std.debug.warn("{}\n", .{@intToEnum(enums.Event, ev)});
    if (ev == @enumToInt(enums.Event.Push)) {
        const inp = input.Input.fromVoidPtr(data);
        std.debug.warn("{s}\n", .{inp.value()});
    }
    return 1;
}

pub fn main() !void {
    try app.init();
    var win = window.Window.new(100, 100, 400, 300, "Hello");
    var inp = input.Input.new(10, 10, 200, 40, "Enter value:");
    var but = button.Button.new(160, 200, 80, 40, "Get Value!");
    win.asGroup().end();
    win.asWidget().show();
    but.handle(butCb, inp.toVoidPtr());
    try app.run();
}