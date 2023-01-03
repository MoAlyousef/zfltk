const zfltk = @import("zfltk");
const std = @import("std");
const app = zfltk.app;
const widget = zfltk.widget;
const window = zfltk.window;
const button = zfltk.button;
const box = zfltk.box;
const enums = zfltk.enums;

var count: i32 = 0;

pub fn thread_func(data: ?*anyopaque) !void {
    while (true) {
        if (data) |d| {
            var mybox = widget.Widget.fromVoidPtr(d);
            std.time.sleep(1000000);
            var buf: [100]u8 = undefined;
            const val = try std.fmt.bufPrintZ(buf[0..], "Hello {d}!", .{count});
            mybox.setLabel(val);
            app.awake();
        }
        count += 1;
    }
}

pub fn butCb(w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void {
    _ = w;
    var thread = std.Thread.spawn(.{}, thread_func, .{data}) catch { return; };
    thread.detach();
}

pub fn main() !void {
    try app.init();
    app.setScheme(.Gtk);
    var win = window.Window.new(100, 100, 400, 300, "Hello");
    var but = button.Button.new(160, 220, 80, 40, "Click");
    var mybox = box.Box.new(10, 10, 380, 180, "");
    win.asGroup().end();
    win.asWidget().show();
    but.asWidget().setCallback(butCb, mybox.toVoidPtr());
    try app.run();
}