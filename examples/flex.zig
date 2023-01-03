const zfltk = @import("zfltk");
const app = zfltk.app;
const widget = zfltk.widget;
const window = zfltk.window;
const box = zfltk.box;
const button = zfltk.button;
const group = zfltk.group;
const enums = zfltk.enums;

pub fn main() !void {
    try app.init();
    var win = window.Window.new(100, 100, 400, 300, "Hello");
    var flex = group.Flex.new(0, 0, 400, 300, "");
    flex.asWidget().setType(group.FlexType, .Vertical);
    flex.setPad(5);
    _ = box.Box.new(0, 0, 0, 0, null);
    var btn = button.Button.new(0, 0, 0, 0, "Button");
    _ = box.Box.new(0, 0, 0, 0, null);
    flex.fixed(&btn.asWidget(), 30);
    flex.end(); // flex has its own end method which recalculates layouts
    win.asGroup().end();
    win.asWidget().show();
    try app.run();
}