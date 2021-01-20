const zfltk = @import("zfltk");
const app = zfltk.app;
const widget = zfltk.widget;
const window = zfltk.window;
const menu = zfltk.menu;
const enums = zfltk.enums;
const std = @import("std");

pub fn newCb(w: menu.WidgetPtr, data: ?*c_void) callconv(.C) void {
    std.debug.warn("File/New clicked\n", .{});
}

pub fn openCb(w: menu.WidgetPtr, data: ?*c_void) callconv(.C) void {
    std.debug.warn("File/Open clicked\n", .{});
}

pub fn quitCb(w: menu.WidgetPtr, data: ?*c_void) callconv(.C) void {
    std.debug.warn("File/Quit clicked\n", .{});
}

pub fn main() !void {
    try app.init();
    var win = window.Window.new(100, 100, 400, 300, "Hello");
    var mymenu = menu.MenuBar.new(0, 0, 400, 40, "");
    win.asGroup().end();
    win.asWidget().show();
    mymenu.asMenu().add("File/New", enums.Shortcut.None, .Normal, newCb, null);
    mymenu.asMenu().add("File/Open", enums.Shortcut.None, .Normal, openCb, null);
    mymenu.asMenu().add("File/Quit", enums.Shortcut.None, .Normal, quitCb, null);
    try app.run();
}
