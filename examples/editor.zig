const zfltk = @import("zfltk");
const app = zfltk.app;
const widget = zfltk.widget;
const window = zfltk.window;
const menu = zfltk.menu;
const enums = zfltk.enums;
const text = zfltk.text;
const dialog = zfltk.dialog;

// To avoid exiting when hitting escape. 
// Also logic can be added to prompt the user to save their work
pub fn winCb(w: widget.WidgetPtr, data: ?*c_void) callconv(.C) void {
    if (app.event() == enums.Event.Close) {
        widget.Widget.fromWidgetPtr(w).hide();
    }
}

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

pub fn cutCb(w: menu.WidgetPtr, data: ?*c_void) callconv(.C) void {
    const editor = text.TextEditor.fromVoidPtr(data);
    editor.cut();
}

pub fn copyCb(w: menu.WidgetPtr, data: ?*c_void) callconv(.C) void {
    const editor = text.TextEditor.fromVoidPtr(data);
    editor.copy();
}

pub fn pasteCb(w: menu.WidgetPtr, data: ?*c_void) callconv(.C) void {
    const editor = text.TextEditor.fromVoidPtr(data);
    editor.paste();
}

pub fn helpCb(w: menu.WidgetPtr, data: ?*c_void) callconv(.C) void {
    dialog.message(300, 200, "This editor was built using fltk and zig!");
}

pub fn main() !void {
    try app.init();
    app.setScheme(.Gtk);
    app.background(211, 211, 211);
    var win = window.Window.new(100, 100, 800, 600, "Hello");
    var mymenu = menu.MenuBar.new(0, 0, 800, 35, "");
    var buf = text.TextBuffer.new();
    var editor = text.TextEditor.new(2, 37, 800 - 2, 600 - 37, "");
    editor.asTextDisplay().setBuffer(&buf);
    win.asGroup().end();
    win.asWidget().show();
    win.asWidget().setCallback(winCb, null);
    mymenu.asMenu().add("&File/New...\t", enums.Shortcut.Ctrl | 'n', .Normal, newCb, buf.toVoidPtr());
    mymenu.asMenu().add("&File/Open...\t", enums.Shortcut.Ctrl | 'o', .MenuDivider, openCb, buf.toVoidPtr());
    mymenu.asMenu().add("&File/Quit...\t", enums.Shortcut.Ctrl | 'q', .Normal, quitCb, win.toVoidPtr());
    mymenu.asMenu().add("&Edit/Cut...\t", enums.Shortcut.Ctrl | 'x', .Normal, cutCb, editor.toVoidPtr());
    mymenu.asMenu().add("&Edit/Copy...\t", enums.Shortcut.Ctrl | 'c', .Normal, copyCb, editor.toVoidPtr());
    mymenu.asMenu().add("&Edit/Paste...\t", enums.Shortcut.Ctrl | 'v', .Normal, pasteCb, editor.toVoidPtr());
    mymenu.asMenu().add("&Help/About...\t", enums.Shortcut.Ctrl | 'q', .Normal, helpCb, null);
    try app.run();
}
