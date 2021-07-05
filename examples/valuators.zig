const zfltk = @import("zfltk");
const app = zfltk.app;
const widget = zfltk.widget;
const window = zfltk.window;
const valuator = zfltk.valuator;
const group = zfltk.group;
const enums = zfltk.enums;

pub fn main() !void {
    try app.init();
    app.setScheme(.Gtk);
    var win = window.Window.new(100, 100, 400, 300, "Hello");
    var pack = group.Pack.new(0, 0, 400, 300, "");
    pack.asWidget().setType(group.PackType, .Vertical);
    pack.setSpacing(40);
    var slider = valuator.Slider.new(0, 0, 0, 40, "Slider");
    slider.asWidget().setType(valuator.SliderType, .HorizontalNice);
    const scrollbar = valuator.Scrollbar.new(0, 0, 0, 40, "Scrollbar");
    scrollbar.asWidget().setType(valuator.ScrollbarType, .HorizontalNice);
    valuator.Counter.new(0, 0, 0, 40, "Counter");
    valuator.Adjuster.new(0, 0, 0, 40, "Adjuster");
    pack.asGroup().end();
    win.asGroup().end();
    win.asWidget().show();
    try app.run();
}
