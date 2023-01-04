const zfltk = @import("zfltk");
const app = zfltk.app;
const widget = zfltk.widget;
const Widget = widget.Widget;
const window = zfltk.window;
const menu = zfltk.menu;
const enums = zfltk.enums;
const text = zfltk.text;
const dialog = zfltk.dialog;

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
pub fn winCb(w: Widget) void {
    _ = w;
    if (app.event() == enums.Event.Close) {
        app.send(Message, .Quit);
    }
}

pub fn main() !void {
    try app.init();
    app.setScheme(.Gtk);
    app.background(211, 211, 211);
    var win = window.Window.new(0, 0, 800, 600, "Editor");
    win.freePosition();
    var mymenu = menu.MenuBar.new(0, 0, 800, 35, "");
    var buf = text.TextBuffer.new();
    defer buf.delete();
    var editor = text.TextEditor.new(2, 37, 800 - 2, 600 - 37, "");
    editor.asTextDisplay().setBuffer(&buf);
    editor.asTextDisplay().setLinenumberWidth(24);
    win.asGroup().end();
    win.asWidget().show();
    win.asWidget().setCallback(winCb);

    mymenu.asMenu().add_emit(
        "&File/New...\t",
        enums.Shortcut.Ctrl | 'n',
        .Normal,
        Message,
        .New,
    );
    mymenu.asMenu().add_emit(
        "&File/Open...\t",
        enums.Shortcut.Ctrl | 'o',
        .Normal,
        Message,
        .Open,
    );
    mymenu.asMenu().add_emit(
        "&File/Save...\t",
        enums.Shortcut.Ctrl | 's',
        .MenuDivider,
        Message,
        .Save,
    );
    mymenu.asMenu().add_emit(
        "&File/Quit...\t",
        enums.Shortcut.Ctrl | 'q',
        .Normal,
        Message,
        .Quit,
    );
    mymenu.asMenu().add_emit(
        "&Edit/Cut...\t",
        enums.Shortcut.Ctrl | 'x',
        .Normal,
        Message,
        .Cut,
    );
    mymenu.asMenu().add_emit(
        "&Edit/Copy...\t",
        enums.Shortcut.Ctrl | 'c',
        .Normal,
        Message,
        .Copy,
    );
    mymenu.asMenu().add_emit(
        "&Edit/Paste...\t",
        enums.Shortcut.Ctrl | 'v',
        .Normal,
        Message,
        .Paste,
    );
    mymenu.asMenu().add_emit(
        "&Help/About...\t",
        enums.Shortcut.Ctrl | 'q',
        .Normal,
        Message,
        .About,
    );

    var item = mymenu.asMenu().findItem("&File/Quit...\t");
    item.setLabelColor(enums.Color.fromRgbi(enums.Color.Red));

    while (app.wait()) {
        if (app.recv(Message)) |msg| switch (msg) {
            .New => buf.setText(""),
            .Open => {
                var dlg = dialog.NativeFileDialog.new(.BrowseFile);
                dlg.setFilter("*.{txt,zig}");
                dlg.show();
                var fname = dlg.filename();
                if (fname != null) {
                    _ = buf.loadFile(fname) catch unreachable;
                }
            },
            .Save => {
                var dlg = dialog.NativeFileDialog.new(.BrowseSaveFile);
                dlg.setFilter("*.{txt,zig}");
                dlg.show();
                var fname = dlg.filename();
                if (fname != null) {
                    _ = buf.saveFile(fname) catch unreachable;
                }
            },
            .Quit => win.asWidget().hide(),
            .Cut => editor.cut(),
            .Copy => editor.copy(),
            .Paste => editor.paste(),
            .About => dialog.message(300, 200, "This editor was built using fltk and zig!"),
        };
    }
}
