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
        w.hide();
    }
}

fn newCb(_: *MenuBar, data: ?*anyopaque) void {
    var editor = TextEditor.fromRaw(data.?);
    editor.buffer().?.setText("");
}

pub fn openCb(_: *MenuBar, data: ?*anyopaque) void {
    var editor = TextEditor.fromRaw(data.?);
    var dlg = try FileDialog(.file).init(.{});
    dlg.setFilter("*.{txt,zig}");
    dlg.show();
    const fname = dlg.filename();
    if (!std.mem.eql(u8, fname, "")) {
        editor.buffer().?.loadFile(fname) catch unreachable;
    }
}

pub fn saveCb(_: *MenuBar, data: ?*anyopaque) void {
    var editor = TextEditor.fromRaw(data.?);
    var dlg = try FileDialog(.save_file).init(.{ .save_as_confirm = true });
    dlg.setFilter("*.{txt,zig}");
    dlg.show();
    const fname = dlg.filename();
    if (!std.mem.eql(u8, fname, "")) {
        editor.buffer().?.saveFile(fname) catch unreachable;
    }
}

pub fn quitCb(_: *MenuBar, data: ?*anyopaque) void {
    var win = widget.Widget.fromRaw(data.?);
    win.hide();
}

pub fn cutCb(_: *MenuBar, data: ?*anyopaque) void {
    const editor = TextEditor.fromRaw(data.?);
    editor.cut();
}

pub fn copyCb(_: *MenuBar, data: ?*anyopaque) void {
    const editor = TextEditor.fromRaw(data.?);
    _ = editor.copy();
}

pub fn pasteCb(_: *MenuBar, data: ?*anyopaque) void {
    const editor = TextEditor.fromRaw(data.?);
    editor.paste();
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

    editor.setLinenumberWidth(24);
    editor.showCursor(true);
    win.end();

    win.add(.{editor});
    win.resizable(editor);

    win.show();
    win.setCallback(winCb);

    mymenu.addEx(
        "&File/New...\t",
        enums.Shortcut.Ctrl | 'n',
        .normal,
        newCb,
        editor,
    );
    mymenu.addEx(
        "&File/Open...\t",
        enums.Shortcut.Ctrl | 'o',
        .normal,
        openCb,
        editor,
    );
    mymenu.addEx(
        "&File/Save...\t",
        enums.Shortcut.Ctrl | 's',
        .menu_divider,
        saveCb,
        editor,
    );
    mymenu.addEx(
        "&File/Quit...\t",
        enums.Shortcut.Ctrl | 'q',
        .normal,
        quitCb,
        win,
    );
    mymenu.addEx(
        "&Edit/Cut...\t",
        enums.Shortcut.Ctrl | 'x',
        .normal,
        cutCb,
        editor,
    );
    mymenu.addEx(
        "&Edit/Copy...\t",
        enums.Shortcut.Ctrl | 'c',
        .normal,
        copyCb,
        editor,
    );
    mymenu.addEx(
        "&Edit/Paste...\t",
        enums.Shortcut.Ctrl | 'v',
        .normal,
        pasteCb,
        editor,
    );
    mymenu.add(
        "&Help/About...\t",
        enums.Shortcut.Ctrl | 'q',
        .normal,
        helpCb,
    );

    var item = mymenu.findItem("&File/Quit...\t");
    item.setLabelColor(Color.fromName(.red));

    try app.run();
}
