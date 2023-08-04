const zfltk = @import("zfltk");
const app = zfltk.app;
const Box = zfltk.box.Box;
const Event = zfltk.enums.Event;
const Input = zfltk.input.Input;
const Window = zfltk.window.Window;
const Button = zfltk.button.Button;
const std = @import("std");

const ButtonMessage = enum(usize) {
    pushed = 1,
    released,
};

pub fn butCb(_: *Button, ev: Event) bool {
    switch (ev) {
        Event.push => {
            app.send(ButtonMessage, .pushed);
            return true;
        },
        Event.release => {
            app.send(ButtonMessage, .released);
            return true;
        },

        else => return false,
    }

    return false;
}

pub fn main() !void {
    try app.init();
    app.setScheme(.plastic);

    var win = try Window.init(.{
        .w = 400,
        .h = 250,

        .label = "Hello",
    });

    var inp = try Input.init(.{
        .x = 10,
        .y = 10,
        .w = 380,
        .h = 40,
    });

    var mybox = try Box.init(.{
        .x = 10,
        .y = 60,
        .w = 380,
        .h = 130,

        .boxtype = .up,
    });

    var but = try Button.init(.{
        .x = 160,
        .y = 200,
        .w = 80,
        .h = 40,

        .label = "Greet!",
    });

    win.end();
    win.show();
    but.setEventHandler(butCb);
    mybox.setLabelSize(24);

    while (app.wait()) {
        if (app.recv(ButtonMessage)) |msg| switch (msg) {
            .pushed => {
                var buf: [100]u8 = undefined;
                const greeting = if (inp.value().len == 0) "I don't know your name!\nAdd it in the text box above" else try std.fmt.bufPrintZ(buf[0..], "Hello, {s}!", .{inp.value()});
                mybox.setLabel(greeting);
            },
            else => {},
        };
    }
}
