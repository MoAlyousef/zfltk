// TODO: This example needs some extra work to properly port to the new API as
// its a bit larger than other examples but it

const zfltk = @import("zfltk");
const app = zfltk.app;
const widget = zfltk.widget;
const Window = zfltk.window.Window;
const MenuBar = zfltk.menu.MenuBar;
const enums = zfltk.enums;
const Color = enums.Color;
const TextEditor = zfltk.text.TextEditor;
const dialog = zfltk.dialog;
const FileDialog = zfltk.dialog.FileDialog;
const std = @import("std");

// To avoid exiting when hitting escape.
// Also logic can be added to prompt the user to save their work
pub fn winCb(w: *Window) void {
    if (app.event() == .close) {
        w.widget_methods().hide();
    }
}

fn newCb(_: *MenuBar, data: ?*anyopaque) void {
    var editor = zfltk.text.TextEditor.fromRaw(data.?);
    editor.own_methods().buffer().?.setText("");
}

pub fn openCb(_: *MenuBar, data: ?*anyopaque) void {
    var editor = zfltk.text.TextEditor.fromRaw(data.?);
    var dlg = try FileDialog(.file).init(.{});
    dlg.setFilter("*.{txt,zig}");
    dlg.show();
    const fname = dlg.filename();
    if (!std.mem.eql(u8, fname, "")) {
        editor.own_methods().buffer().?.loadFile(fname) catch unreachable;
    }
}

pub fn saveCb(_: *MenuBar, data: ?*anyopaque) void {
    var editor = zfltk.text.TextEditor.fromRaw(data.?);
    var dlg = try FileDialog(.save_file).init(.{ .save_as_confirm = true });
    dlg.setFilter("*.{txt,zig}");
    dlg.show();
    const fname = dlg.filename();
    if (!std.mem.eql(u8, fname, "")) {
        editor.own_methods().buffer().?.saveFile(fname) catch unreachable;
    }
}

pub fn quitCb(_: *MenuBar, data: ?*anyopaque) void {
    const win = widget.Widget.methods_ns.fromRaw(data.?);
    widget.Widget.methods_ns.hide(win);
}

pub fn cutCb(_: *MenuBar, data: ?*anyopaque) void {
    const editor = zfltk.text.TextEditor.fromRaw(data.?);
    editor.own_methods().cut();
}

pub fn copyCb(_: *MenuBar, data: ?*anyopaque) void {
    const editor = zfltk.text.TextEditor.fromRaw(data.?);
    _ = editor.own_methods().copy();
}

pub fn pasteCb(_: *MenuBar, data: ?*anyopaque) void {
    const editor = zfltk.text.TextEditor.fromRaw(data.?);
    editor.own_methods().paste();
}

pub fn helpCb(_: *MenuBar) void {
    dialog.message(300, 200, "This editor was built using fltk and zig!");
}

pub fn main() !void {
    try app.init();
    app.setScheme(.gtk);
    app.setBackground(Color.fromRgb(211, 211, 211));

    var win = try Window.init(.{
        .w = 800,
        .h = 600,

        .label = "Editor",
    });

    win.freePosition();
    var mymenu = try MenuBar.init(.{ .w = 800, .h = 35 });

    var editor = try TextEditor.init(.{
        .x = 2,
        .y = 37,
        .w = 800 - 2,
        .h = 600 - 37,
    });

    editor.own_methods().setLinenumberWidth(24);
    editor.own_methods().showCursor(true);
    win.group_methods().end();

    win.group_methods().add(.{editor});
    win.group_methods().resizable(editor);

    win.widget_methods().show();
    win.widget_methods().setCallback(winCb);

    mymenu.menu_methods().addEx(
        "&File/New...\t",
        enums.Shortcut.Ctrl | 'n',
        .normal,
        newCb,
        editor,
    );
    mymenu.menu_methods().addEx(
        "&File/Open...\t",
        enums.Shortcut.Ctrl | 'o',
        .normal,
        openCb,
        editor,
    );
    mymenu.menu_methods().addEx(
        "&File/Save...\t",
        enums.Shortcut.Ctrl | 's',
        .menu_divider,
        saveCb,
        editor,
    );
    mymenu.menu_methods().addEx(
        "&File/Quit...\t",
        enums.Shortcut.Ctrl | 'q',
        .normal,
        quitCb,
        win,
    );
    mymenu.menu_methods().addEx(
        "&Edit/Cut...\t",
        enums.Shortcut.Ctrl | 'x',
        .normal,
        cutCb,
        editor,
    );
    mymenu.menu_methods().addEx(
        "&Edit/Copy...\t",
        enums.Shortcut.Ctrl | 'c',
        .normal,
        copyCb,
        editor,
    );
    mymenu.menu_methods().addEx(
        "&Edit/Paste...\t",
        enums.Shortcut.Ctrl | 'v',
        .normal,
        pasteCb,
        editor,
    );
    mymenu.menu_methods().add(
        "&Help/About...\t",
        enums.Shortcut.Ctrl | 'q',
        .normal,
        helpCb,
    );

    var item = mymenu.menu_methods().findItem("&File/Quit...\t");
    item.setLabelColor(Color.fromName(.red));

    try app.run();
}
