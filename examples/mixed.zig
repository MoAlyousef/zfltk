const c = @cImport({
    @cInclude("cfl.h"); // Fl_event_x(), Fl_event_y()
});

const zfltk = @import("zfltk");
const app = zfltk.app;
const widget = zfltk.widget;
const window = zfltk.window;
const button = zfltk.button;
const std = @import("std");

pub fn butCb(w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void {
    _ = w;
    _ = data;
    std.debug.print("{},{}\n", .{c.Fl_event_x(), c.Fl_event_y()});
}

pub fn main() !void {
    try app.init();
    var win = window.Window.new(100, 100, 400, 300, "Hello");
    var but = button.Button.new(160, 200, 80, 40, "Click");
    win.asGroup().end();
    win.asWidget().show();
    but.asWidget().setCallback(butCb, null);
    try app.run();
}
