// TODO: This example needs some extra work to properly port to the new API as
// its a bit larger than other examples but it

const zfltk = @import("zfltk");
const app = zfltk.app;
const widget = zfltk.widget;
const Widget = widget.Widget;
const Window = zfltk.Window;
const MenuBar = zfltk.MenuBar;
const enums = zfltk.enums;
const Color = enums.Color;
const TextDisplay = zfltk.TextDisplay;
const dialog = zfltk.dialog;
const FileDialog = zfltk.FileDialog;
const std = @import("std");

// To avoid exiting when hitting escape.
// Also logic can be added to prompt the user to save their work
pub fn winCb(w: *Widget) void {
    if (app.event() == .close) {
        w.hide();
    }
}

pub fn newCb(_: *Widget, data: ?*anyopaque) void {
    var editor = TextDisplay(.editor).fromRaw(data.?);
    editor.buffer().?.setText("");
}

pub fn openCb(_: *Widget, data: ?*anyopaque) void {
    var editor = TextDisplay(.editor).fromRaw(data.?);
    var dlg = try FileDialog(.file).init(.{});
    dlg.setFilter("*.{txt,zig}");
    dlg.show();
    var fname = dlg.filename();
    if (!std.mem.eql(u8, fname, "")) {
        editor.buffer().?.loadFile(fname) catch unreachable;
    }
}

pub fn saveCb(_: *Widget, data: ?*anyopaque) void {
    var editor = TextDisplay(.editor).fromRaw(data.?);
    var dlg = try FileDialog(.file).init(.{});
    dlg.setFilter("*.{txt,zig}");
    dlg.show();
    var fname = dlg.filename();
    if (!std.mem.eql(u8, fname, "")) {
        editor.buffer().?.loadFile(fname) catch unreachable;
    }
}

pub fn quitCb(w: *Widget, data: ?*anyopaque) void {
    _ = w;
    var win = widget.Widget.fromRaw(data.?);
    win.hide();
}

pub fn cutCb(w: *Widget, data: ?*anyopaque) void {
    _ = w;
    const editor = TextDisplay(.editor).fromRaw(data.?);
    editor.cut();
}

pub fn copyCb(w: *Widget, data: ?*anyopaque) void {
    _ = w;
    const editor = TextDisplay(.editor).fromRaw(data.?);
    _ = try editor.buffer().?.copy();
}

pub fn pasteCb(w: *Widget, data: ?*anyopaque) void {
    _ = w;
    const editor = TextDisplay(.editor).fromRaw(data.?);
    editor.paste();
}

pub fn helpCb(_: *Widget) void {
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
    var mymenu = MenuBar.new(0, 0, 800, 35, "");

    var editor = try TextDisplay(.editor).init(.{
        .x = 2,
        .y = 37,
        .w = 800 - 2,
        .h = 600 - 37,
    });

    editor.setLinenumberWidth(24);
    win.group().end();

    win.group().add(.{editor});
    win.group().resizable(editor);

    win.widget().show();
    win.widget().setCallback(winCb);

    mymenu.asMenu().addEx(
        "&File/New...\t",
        enums.Shortcut.Ctrl | 'n',
        .Normal,
        newCb,
        editor,
    );
    mymenu.asMenu().addEx(
        "&File/Open...\t",
        enums.Shortcut.Ctrl | 'o',
        .Normal,
        openCb,
        editor,
    );
    mymenu.asMenu().addEx(
        "&File/Save...\t",
        enums.Shortcut.Ctrl | 's',
        .MenuDivider,
        saveCb,
        editor,
    );
    mymenu.asMenu().addEx(
        "&File/Quit...\t",
        enums.Shortcut.Ctrl | 'q',
        .Normal,
        quitCb,
        win,
    );
    mymenu.asMenu().addEx(
        "&Edit/Cut...\t",
        enums.Shortcut.Ctrl | 'x',
        .Normal,
        cutCb,
        editor,
    );
    mymenu.asMenu().addEx(
        "&Edit/Copy...\t",
        enums.Shortcut.Ctrl | 'c',
        .Normal,
        copyCb,
        editor,
    );
    mymenu.asMenu().addEx(
        "&Edit/Paste...\t",
        enums.Shortcut.Ctrl | 'v',
        .Normal,
        pasteCb,
        editor,
    );
    mymenu.asMenu().add(
        "&Help/About...\t",
        enums.Shortcut.Ctrl | 'q',
        .Normal,
        helpCb,
    );

    var item = mymenu.asMenu().findItem("&File/Quit...\t");
    item.setLabelColor(Color.fromName(.red));

    try app.run();
}
