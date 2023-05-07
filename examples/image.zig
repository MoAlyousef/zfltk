const zfltk = @import("zfltk");
const app = zfltk.app;
const SharedImage = zfltk.image.SharedImage;
const Image = zfltk.Image;
const Window = zfltk.Window;
const Box = zfltk.Box;
const Group = zfltk.Group;
const Align = zfltk.enums.Align;
const std = @import("std");

pub fn main() !void {
    try app.init();

    var win = try Window.init(.{
        .w = 415,
        .h = 140,

        .label = "Image demo",
    });

    var scroll = try Group(.scroll).init(.{
        .w = 415,
        .h = 140,
    });

    scroll.setScrollBar(.vertical);

    var mybox = try Box.init(.{
        .w = 400,
        .h = 280,

        .boxtype = .up,
    });

    scroll.add(.{mybox});
    win.group().add(.{scroll});

    var img = try Image.load(.png, "screenshots/logo.png");

    mybox.widget().setImage(img);

    win.group().end();
    win.show();

    try app.run();
}
