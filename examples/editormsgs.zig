const zfltk = @import("zfltk");
const app = zfltk.app;
const widget = zfltk.widget;
const window = zfltk.window;
const menu = zfltk.menu;
const enums = zfltk.enums;
const Color = enums.Color;
const text = zfltk.text;
const dialog = zfltk.dialog;
const FileDialog = zfltk.dialog.FileDialog;
const std = @import("std");

pub const Message = enum(usize) {
    // Can't begin with 0
    New = 1,
    Open,
    Save,
    Quit,
    Cut,
    Copy,
    Paste,
    About,
};

// To avoid exiting when hitting escape.
// Also logic can be added to prompt the user to save their work
pub fn winCb(w: *window.Window) void {
    if (app.event() == .close) {
        w.widget_methods().hide();
    }
}

pub fn main() !void {
    try app.init();
    app.setScheme(.gtk);

    app.setBackground(Color.fromRgb(211, 211, 211));
    var win = try window.Window.init(.{ .w = 800, .h = 600, .label = "Editor" });
    win.freePosition();
    var mymenu = try menu.MenuBar.init(.{ .w = 800, .h = 35 });
    var buf = try text.TextBuffer.init();
    defer buf.deinit();
    var editor = try text.TextEditor.init(.{
        .x = 2,
        .y = 37,
        .w = 800 - 2,
        .h = 600 - 37,
    });
    editor.own_methods().setBuffer(buf);
    editor.own_methods().setLinenumberWidth(24);
    win.group_methods().end();
    win.widget_methods().show();
    win.widget_methods().setCallback(winCb);

    mymenu.menu_methods().addEmit(
        "&File/New...\t",
        enums.Shortcut.Ctrl | 'n',
        .normal,
        Message,
        .New,
    );
    mymenu.menu_methods().addEmit(
        "&File/Open...\t",
        enums.Shortcut.Ctrl | 'o',
        .normal,
        Message,
        .Open,
    );
    mymenu.menu_methods().addEmit(
        "&File/Save...\t",
        enums.Shortcut.Ctrl | 's',
        .menu_divider,
        Message,
        .Save,
    );
    mymenu.menu_methods().addEmit(
        "&File/Quit...\t",
        enums.Shortcut.Ctrl | 'q',
        .normal,
        Message,
        .Quit,
    );
    mymenu.menu_methods().addEmit(
        "&Edit/Cut...\t",
        enums.Shortcut.Ctrl | 'x',
        .normal,
        Message,
        .Cut,
    );
    mymenu.menu_methods().addEmit(
        "&Edit/Copy...\t",
        enums.Shortcut.Ctrl | 'c',
        .normal,
        Message,
        .Copy,
    );
    mymenu.menu_methods().addEmit(
        "&Edit/Paste...\t",
        enums.Shortcut.Ctrl | 'v',
        .normal,
        Message,
        .Paste,
    );
    mymenu.menu_methods().addEmit(
        "&Help/About...\t",
        enums.Shortcut.Ctrl | 'q',
        .normal,
        Message,
        .About,
    );

    var item = mymenu.menu_methods().findItem("&File/Quit...\t");
    item.setLabelColor(Color.fromName(.red));

    while (app.wait()) {
        if (app.recv(Message)) |msg| switch (msg) {
            .New => buf.setText(""),
            .Open => {
                var dlg = try FileDialog(.file).init(.{});
                dlg.setFilter("*.{txt,zig}");
                dlg.show();
                const fname = dlg.filename();
                if (!std.mem.eql(u8, fname, "")) {
                    editor.own_methods().buffer().?.loadFile(fname) catch unreachable;
                }
            },
            .Save => {
                var dlg = try FileDialog(.save_file).init(.{});
                dlg.setFilter("*.{txt,zig}");
                dlg.show();
                const fname = dlg.filename();
                if (!std.mem.eql(u8, fname, "")) {
                    editor.own_methods().buffer().?.saveFile(fname) catch unreachable;
                }
            },
            .Quit => win.widget_methods().hide(),
            .Cut => editor.own_methods().cut(),
            .Copy => editor.own_methods().copy(),
            .Paste => editor.own_methods().paste(),
            .About => dialog.message(300, 200, "This editor was built using fltk and zig!"),
        };
    }
}
