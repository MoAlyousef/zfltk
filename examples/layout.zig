const zfltk = @import("zfltk");
const app = zfltk.app;
const widget = zfltk.widget;
const window = zfltk.window;
const button = zfltk.button;
const group = zfltk.group;
const enums = zfltk.enums;

pub fn main() !void {
    try app.init();
    app.setScheme(.Gtk);
    var win = window.Window.new(100, 100, 400, 300, "Hello");
    var pack = group.Pack.new(0, 0, 400, 300, "");
    pack.asWidget().setType(group.PackType, .Vertical);
    pack.setSpacing(40);
    @import("std").debug.print("{}\n", .{pack.spacing()});
    _ = button.Button.new(0, 0, 0, 40, "Button 1");
    _ = button.Button.new(0, 0, 0, 40, "Button 2");
    _ = button.Button.new(0, 0, 0, 40, "Button 3");
    win.asGroup().add(&pack.asWidget());
    win.asGroup().resizable(&pack.asWidget());
    pack.asGroup().end();
    win.asGroup().end();
    win.asWidget().show();
    try app.run();
}
