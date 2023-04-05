const zfltk = @import("zfltk");
const app = zfltk.app;
const widget = zfltk.widget;
const Widget = widget.Widget;
const window = zfltk.window;
const menu = zfltk.menu;
const enums = zfltk.enums;
const Color = enums.Color;
const text = zfltk.text;
const dialog = zfltk.dialog;

// To avoid exiting when hitting escape.
// Also logic can be added to prompt the user to save their work
pub fn winCb(w: Widget) void {
    if (app.event() == enums.Event.Close) {
        w.hide();
    }
}

pub fn newCb(w: Widget, data: ?*anyopaque) void {
    _ = w;
    var buf = text.TextBuffer.fromVoidPtr(data);
    buf.setText("");
}

pub fn openCb(w: Widget, data: ?*anyopaque) void {
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

pub fn saveCb(w: Widget, data: ?*anyopaque) void {
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

pub fn quitCb(w: Widget, data: ?*anyopaque) void {
    _ = w;
    var win = widget.Widget.fromVoidPtr(data);
    win.hide();
}

pub fn cutCb(w: Widget, data: ?*anyopaque) void {
    _ = w;
    const editor = text.TextEditor.fromVoidPtr(data);
    editor.cut();
}

pub fn copyCb(w: Widget, data: ?*anyopaque) void {
    _ = w;
    const editor = text.TextEditor.fromVoidPtr(data);
    editor.copy();
}

pub fn pasteCb(w: Widget, data: ?*anyopaque) void {
    _ = w;
    const editor = text.TextEditor.fromVoidPtr(data);
    editor.paste();
}

pub fn helpCb(w: Widget, data: ?*anyopaque) void {
    _ = w;
    _ = data;
    dialog.message(300, 200, "This editor was built using fltk and zig!");
}

pub fn main() !void {
    try app.init();
    app.setScheme(.Gtk);
    app.setBackground(Color.fromRgb(211, 211, 211));
    var win = window.Window.new(100, 100, 800, 600, "Editor");
    win.freePosition();
    var mymenu = menu.MenuBar.new(0, 0, 800, 35, "");
    var buf = text.TextBuffer.new();
    defer buf.delete();
    var editor = text.TextEditor.new(2, 37, 800 - 2, 600 - 37, "");
    editor.asTextDisplay().setBuffer(&buf);
    editor.asTextDisplay().setLinenumberWidth(24);
    win.asGroup().end();
    win.asGroup().add(&editor.asWidget());
    win.asGroup().resizable(&editor.asWidget());
    win.asWidget().show();
    win.asWidget().setCallback(winCb);

    mymenu.asMenu().addEx(
        "&File/New...\t",
        enums.Shortcut.Ctrl | 'n',
        .Normal,
        newCb,
        buf.toVoidPtr(),
    );
    mymenu.asMenu().addEx(
        "&File/Open...\t",
        enums.Shortcut.Ctrl | 'o',
        .Normal,
        openCb,
        buf.toVoidPtr(),
    );
    mymenu.asMenu().addEx(
        "&File/Save...\t",
        enums.Shortcut.Ctrl | 's',
        .MenuDivider,
        saveCb,
        buf.toVoidPtr(),
    );
    mymenu.asMenu().addEx(
        "&File/Quit...\t",
        enums.Shortcut.Ctrl | 'q',
        .Normal,
        quitCb,
        win.toVoidPtr(),
    );
    mymenu.asMenu().addEx(
        "&Edit/Cut...\t",
        enums.Shortcut.Ctrl | 'x',
        .Normal,
        cutCb,
        editor.toVoidPtr(),
    );
    mymenu.asMenu().addEx(
        "&Edit/Copy...\t",
        enums.Shortcut.Ctrl | 'c',
        .Normal,
        copyCb,
        editor.toVoidPtr(),
    );
    mymenu.asMenu().addEx(
        "&Edit/Paste...\t",
        enums.Shortcut.Ctrl | 'v',
        .Normal,
        pasteCb,
        editor.toVoidPtr(),
    );
    mymenu.asMenu().addEx(
        "&Help/About...\t",
        enums.Shortcut.Ctrl | 'q',
        .Normal,
        helpCb,
        null,
    );

    var item = mymenu.asMenu().findItem("&File/Quit...\t");
    item.setLabelColor(Color.fromName(.red));

    try app.run();
}
