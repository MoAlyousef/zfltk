const zfltk = @import("zfltk");
const app = zfltk.app;
const Widget = zfltk.Widget;
const Window = zfltk.Window;
const Button = zfltk.Button;
const Box = zfltk.Box;
const enums = zfltk.enums;

pub const Message = enum(usize) {
    // Can't begin with Zero!
    first = 1,
    second,
};

pub fn main() !void {
    try app.init();
    app.setScheme(.gtk);

    var win = try Window.init(.{
        .w = 400,
        .h = 300,

        .label = "Hello",
    });

    var but1 = try Button(.normal).init(.{
        .x = 100,
        .y = 220,
        .w = 80,
        .h = 40,

        .label = "Button 1",
    });

    var but2 = try Button(.normal).init(.{
        .x = 200,
        .y = 220,
        .w = 80,
        .h = 40,

        .label = "Button 2",
    });

    var mybox = try Box.init(.{
        .x = 10,
        .y = 10,
        .w = 380,
        .h = 180,

        .boxtype = .up,
    });

    mybox.setLabelFont(.courier);
    mybox.setLabelSize(18);

    win.end();
    win.show();
    but1.emit(Message, .first);
    but2.emit(Message, .second);

    while (app.wait()) {
        if (app.recv(Message)) |msg| switch (msg) {
            .first => mybox.setLabel("Button 1 Clicked!"),
            .second => mybox.setLabel("Button 2 Clicked!"),
        };
    }
}
