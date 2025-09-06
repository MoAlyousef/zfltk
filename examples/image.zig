const zfltk = @import("zfltk");
const app = zfltk.app;
const SharedImage = zfltk.image.SharedImage;
const Image = zfltk.image.Image;
const Window = zfltk.window.Window;
const Box = zfltk.box.Box;
const Scroll = zfltk.group.Scroll;
const Align = zfltk.enums.Align;
const std = @import("std");

pub fn main() !void {
    try app.init();

    var win = try Window.init(.{
        .w = 415,
        .h = 140,

        .label = "Image demo",
    });

    var scroll = try Scroll.init(.{
        .w = 415,
        .h = 140,
    });

    scroll.asGroup().setScrollbar(.vertical);

    var mybox = try Box.init(.{
        .w = 400,
        .h = 280,

        .boxtype = .up,
    });

    scroll.asGroup().add(.{mybox});
    win.asGroup().add(.{scroll});

    const img = try Image.load(.png, "screenshots/logo.png");

    mybox.asWidget().setImage(img);

    win.asGroup().end();
    win.asWidget().show();

    try app.run();
}
