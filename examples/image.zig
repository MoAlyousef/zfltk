const zfltk = @import("zfltk");
const app = zfltk.app;
const widget = zfltk.widget;
const image = zfltk.image;
const window = zfltk.window;
const box = zfltk.box;

pub fn main() !void {
    try app.init();
    var win = window.Window.new(100, 100, 400, 300, "Hello");
    var mybox = box.Box.new(0, 0, 400, 300, "");
    win.asGroup().end();
    win.asWidget().show();
    var img = try image.SharedImage.load("screenshots/logo.png");
    img.asImage().scale(400, 300, false, true);
    mybox.asWidget().setImage(img.asImage());
    try app.run();
}
