const zfltk = @import("zfltk");
const app = zfltk.app;
const widget = zfltk.widget;
const image = zfltk.image;
const window = zfltk.window;
const box = zfltk.box;

const data: [*c]const u8 = "<svg viewBox=\"0 0 200 200\" version = \"1.1\">\n<rect x=\"25\" y=\"50\" width=\"150\" height=\"100\" fill=\"black\" transform=\"rotate(45 100 100)\"> \n";

pub fn main() !void {
    try app.init();
    var win = window.Window.new(100, 100, 400, 300, "Image");
    var mybox = box.Box.new(0, 0, 400, 300, "");
    win.asGroup().end();
    win.asWidget().show();
    var img = try image.SvgImage.fromData(data);
    img.asImage().scale(400, 300, false, true);
    mybox.asWidget().setImage(img.asImage());
    try app.run();
}
