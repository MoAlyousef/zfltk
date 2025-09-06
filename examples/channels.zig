const zfltk = @import("zfltk");
const app = zfltk.app;
const Window = zfltk.window.Window;
const Button = zfltk.button.Button;
const Box = zfltk.box.Box;
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

    var but1 = try Button.init(.{
        .x = 100,
        .y = 220,
        .w = 80,
        .h = 40,

        .label = "Button 1",
    });

    var but2 = try Button.init(.{
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

    mybox.widget_methods().setLabelFont(.courier);
    mybox.widget_methods().setLabelSize(18);

    win.group_methods().end();
    win.widget_methods().show();
    but1.widget_methods().emit(Message, .first);
    but2.widget_methods().emit(Message, .second);

    while (app.wait()) {
        if (app.recv(Message)) |msg| switch (msg) {
            .first => mybox.widget_methods().setLabel("Button 1 Clicked!"),
            .second => mybox.widget_methods().setLabel("Button 2 Clicked!"),
        };
    }
}
