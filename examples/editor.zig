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
pub fn winCb(w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void {
    _ = data;
    if (app.event() == enums.Event.Close) {
        widget.Widget.fromWidgetPtr(w).hide();
    }
}

pub fn newCb(w: menu.WidgetPtr, data: ?*anyopaque) callconv(.C) void {
    _ = w;
    var buf = text.TextBuffer.fromVoidPtr(data);
    buf.setText("");
}

pub fn openCb(w: menu.WidgetPtr, data: ?*anyopaque) callconv(.C) void {
    _ = w;
    var dlg = dialog.NativeFileDialog.new(.BrowseFile);
    dlg.setFilter("*.{txt,zig}");
    dlg.show();
    var fname = dlg.filename();
    if (fname != null) {
        var buf = text.TextBuffer.fromVoidPtr(data);
        _ = buf.loadFile(fname) catch unreachable;
    }
}

pub fn saveCb(w: menu.WidgetPtr, data: ?*anyopaque) callconv(.C) void {
    _ = w;
    var dlg = dialog.NativeFileDialog.new(.BrowseSaveFile);
    dlg.setFilter("*.{txt,zig}");
    dlg.show();
    var fname = dlg.filename();
    if (fname != null) {
        var buf = text.TextBuffer.fromVoidPtr(data);
        _ = buf.saveFile(fname) catch unreachable;
    }
}

pub fn quitCb(w: menu.WidgetPtr, data: ?*anyopaque) callconv(.C) void {
    _ = w;
    var win = widget.Widget.fromVoidPtr(data);
    win.hide();
}

pub fn cutCb(w: menu.WidgetPtr, data: ?*anyopaque) callconv(.C) void {
    _ = w;
    const editor = text.TextEditor.fromVoidPtr(data);
    editor.cut();
}

pub fn copyCb(w: menu.WidgetPtr, data: ?*anyopaque) callconv(.C) void {
    _ = w;
    const editor = text.TextEditor.fromVoidPtr(data);
    editor.copy();
}

pub fn pasteCb(w: menu.WidgetPtr, data: ?*anyopaque) callconv(.C) void {
    _ = w;
    const editor = text.TextEditor.fromVoidPtr(data);
    editor.paste();
}

pub fn helpCb(w: menu.WidgetPtr, data: ?*anyopaque) callconv(.C) void {
    _ = w;
    _ = data;
    dialog.message(300, 200, "This editor was built using fltk and zig!");
}

pub fn main() !void {
    try app.init();
    app.setScheme(.Gtk);
    app.background(211, 211, 211);
    var win = window.Window.new(100, 100, 800, 600, "Editor");
    win.freePosition();
    var mymenu = menu.MenuBar.new(0, 0, 800, 35, "");
    var buf = text.TextBuffer.new();
    defer buf.delete();
    var editor = text.TextEditor.new(2, 37, 800 - 2, 600 - 37, "");
    editor.asTextDisplay().setBuffer(&buf);
    editor.asTextDisplay().setLinenumberWidth(24);
    win.asGroup().end();
    win.asWidget().show();
    win.asWidget().setCallback(winCb, null);

    mymenu.asMenu().add(
        "&File/New...\t",
        enums.Shortcut.Ctrl | 'n',
        .Normal,
        newCb,
        buf.toVoidPtr(),
    );
    mymenu.asMenu().add(
        "&File/Open...\t",
        enums.Shortcut.Ctrl | 'o',
        .Normal,
        openCb,
        buf.toVoidPtr(),
    );
    mymenu.asMenu().add(
        "&File/Save...\t",
        enums.Shortcut.Ctrl | 's',
        .MenuDivider,
        saveCb,
        buf.toVoidPtr(),
    );
    mymenu.asMenu().add(
        "&File/Quit...\t",
        enums.Shortcut.Ctrl | 'q',
        .Normal,
        quitCb,
        win.toVoidPtr(),
    );
    mymenu.asMenu().add(
        "&Edit/Cut...\t",
        enums.Shortcut.Ctrl | 'x',
        .Normal,
        cutCb,
        editor.toVoidPtr(),
    );
    mymenu.asMenu().add(
        "&Edit/Copy...\t",
        enums.Shortcut.Ctrl | 'c',
        .Normal,
        copyCb,
        editor.toVoidPtr(),
    );
    mymenu.asMenu().add(
        "&Edit/Paste...\t",
        enums.Shortcut.Ctrl | 'v',
        .Normal,
        pasteCb,
        editor.toVoidPtr(),
    );
    mymenu.asMenu().add(
        "&Help/About...\t",
        enums.Shortcut.Ctrl | 'q',
        .Normal,
        helpCb,
        null,
    );
    
    var item = mymenu.asMenu().findItem("&File/Quit...\t");
    item.setLabelColor(enums.Color.from_rgbi(enums.Color.Red));

    try app.run();
}
