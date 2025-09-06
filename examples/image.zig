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

    scroll.group_methods().setScrollbar(.vertical);

    var mybox = try Box.init(.{
        .w = 400,
        .h = 280,

        .boxtype = .up,
    });

    scroll.group_methods().add(.{mybox});
    win.group_methods().add(.{scroll});

    const img = try Image.load(.png, "screenshots/logo.png");

    mybox.widget_methods().setImage(img);

    win.group_methods().end();
    win.widget_methods().show();

    try app.run();
}
