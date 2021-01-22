const zfltk = @import("zfltk");
const app = zfltk.app;
const widget = zfltk.widget;
const window = zfltk.window;
const button = zfltk.button;
const box = zfltk.box;
const enums = zfltk.enums;

pub const Message = enum(usize) {
    // Can't begin with Zero!
    First = 1,
    Second,
};

pub fn main() !void {
    try app.init();
    app.setScheme(.Gtk);
    var win = window.Window.new(100, 100, 400, 300, "Hello");
    var but1 = button.Button.new(100, 220, 80, 40, "Click Me");
    var but2 = button.Button.new(200, 220, 80, 40, "Click Me");
    var mybox = box.Box.new(10, 10, 380, 180, "");
    win.asGroup().end();
    win.asWidget().show();
    but1.asWidget().emit(@enumToInt(Message.First));
    but2.asWidget().emit(@enumToInt(Message.Second));
    while (app.wait()) {
        if (app.recv()) |msg| switch (msg) {
            @enumToInt(Message.First) => mybox.asWidget().setLabel("Button 1 Clicked!"),
            @enumToInt(Message.Second) => mybox.asWidget().setLabel("Button 2 Clicked!"),
            else => {},
        };
    }
}
