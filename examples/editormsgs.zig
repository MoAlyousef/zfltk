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
const FileDialog = zfltk.FileDialog;
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
pub fn winCb(w: *Widget) void {
    if (app.event() == .close) {
        w.hide();
    }
}

pub fn main() !void {
    try app.init();
    app.setScheme(.gtk);

    app.setBackground(Color.fromRgb(211, 211, 211));
    var win = try window.Window.init(.{.w = 800, .h = 600, .label = "Editor"});
    win.freePosition();
    var mymenu = try menu.Menu(.menu_bar).init(.{.w = 800, .h = 35 });
    var buf = try text.TextBuffer.init();
    defer buf.deinit();
    var editor = try text.TextDisplay(.editor).init(.{
        .x = 2,
        .y = 37,
        .w = 800 - 2,
        .h = 600 - 37,
    });
    editor.setBuffer(buf);
    editor.setLinenumberWidth(24);
    win.end();
    win.show();
    win.widget().setCallback(winCb);

    mymenu.addEmit(
        "&File/New...\t",
        enums.Shortcut.Ctrl | 'n',
        .Normal,
        Message,
        .New,
    );
    mymenu.addEmit(
        "&File/Open...\t",
        enums.Shortcut.Ctrl | 'o',
        .Normal,
        Message,
        .Open,
    );
    mymenu.addEmit(
        "&File/Save...\t",
        enums.Shortcut.Ctrl | 's',
        .MenuDivider,
        Message,
        .Save,
    );
    mymenu.addEmit(
        "&File/Quit...\t",
        enums.Shortcut.Ctrl | 'q',
        .Normal,
        Message,
        .Quit,
    );
    mymenu.addEmit(
        "&Edit/Cut...\t",
        enums.Shortcut.Ctrl | 'x',
        .Normal,
        Message,
        .Cut,
    );
    mymenu.addEmit(
        "&Edit/Copy...\t",
        enums.Shortcut.Ctrl | 'c',
        .Normal,
        Message,
        .Copy,
    );
    mymenu.addEmit(
        "&Edit/Paste...\t",
        enums.Shortcut.Ctrl | 'v',
        .Normal,
        Message,
        .Paste,
    );
    mymenu.addEmit(
        "&Help/About...\t",
        enums.Shortcut.Ctrl | 'q',
        .Normal,
        Message,
        .About,
    );

    var item = mymenu.findItem("&File/Quit...\t");
    item.setLabelColor(Color.fromName(.red));

    while (app.wait()) {
        if (app.recv(Message)) |msg| switch (msg) {
            .New => buf.setText(""),
            .Open => {
                var dlg = try FileDialog(.file).init(.{});
                dlg.setFilter("*.{txt,zig}");
                dlg.show();
                var fname = dlg.filename();
                if (!std.mem.eql(u8, fname, "")) {
                    editor.buffer().?.loadFile(fname) catch unreachable;
                }
            },
            .Save => {
                var dlg = try FileDialog(.file).init(.{});
                dlg.setFilter("*.{txt,zig}");
                dlg.show();
                var fname = dlg.filename();
                if (!std.mem.eql(u8, fname, "")) {
                    editor.buffer().?.saveFile(fname) catch unreachable;
                }
            },
            .Quit => win.widget().hide(),
            .Cut => editor.cut(),
            .Copy => editor.copy(),
            .Paste => editor.paste(),
            .About => dialog.message(300, 200, "This editor was built using fltk and zig!"),
        };
    }
}
