const zfltk = @import("zfltk");
const app = zfltk.app;
const widget = zfltk.widget;
const window = zfltk.window;
const menu = zfltk.menu;
const enums = zfltk.enums;
const text = zfltk.text;
const dialog = zfltk.dialog;
const std = @import("std");
const fmt = std.fmt;

pub fn newCb(w: menu.WidgetPtr, data: ?*c_void) callconv(.C) void {
    var buf = text.TextBuffer.fromVoidPtr(data);
    buf.setText("");
}

pub fn openCb(w: menu.WidgetPtr, data: ?*c_void) callconv(.C) void {
    var dlg = dialog.NativeFileDialog.new(.BrowseFile);
    dlg.setFilter("*.{txt,zig}");
    dlg.show();
    var fname = dlg.filename();
    var buf = text.TextBuffer.fromVoidPtr(data);
    _ = buf.loadFile(fname) catch unreachable;
}

pub fn quitCb(w: menu.WidgetPtr, data: ?*c_void) callconv(.C) void {
    var win = widget.Widget.fromVoidPtr(data);
    win.hide();
}

pub fn main() !void {
    try app.init();
    app.setScheme(.Gtk);
    var win = window.Window.new(100, 100, 800, 600, "Hello");
    var mymenu = menu.MenuBar.new(0, 0, 800, 40, "");
    var buf = text.TextBuffer.new();
    var editor = text.TextEditor.new(2, 40, 800 - 2, 600 - 42, "");
    editor.asTextDisplay().setBuffer(&buf);
    win.asGroup().end();
    win.asWidget().show();
    mymenu.asMenu().add("&File/New...\t", enums.Shortcut.Ctrl | 'n', .Normal, newCb, @ptrCast(?*c_void, buf.inner));
    mymenu.asMenu().add("&File/Open...\t", enums.Shortcut.Ctrl | 'o', .MenuDivider, openCb, @ptrCast(?*c_void, buf.inner));
    mymenu.asMenu().add("&File/Quit...\t", enums.Shortcut.Ctrl | 'q', .Normal, quitCb, @ptrCast(?*c_void, win.raw()));
    try app.run();
}
