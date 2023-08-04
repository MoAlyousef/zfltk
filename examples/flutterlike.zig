const std = @import("std");
const zfltk = @import("zfltk");
const app = zfltk.app;
const box = zfltk.box;
const draw = zfltk.draw;
const button = zfltk.button;
const window = zfltk.window;
const Align = zfltk.enums.Align;
const Color = zfltk.enums.Color;

const GRAY: Color = Color.fromHex(0x757575);
const BLUE: Color = Color.fromHex(0x42A5F5);
const SEL_BLUE: Color = Color.fromHex(0x2196F3);

const WIDTH: i32 = 600;
const HEIGHT: i32 = 400;

var COUNT: i32 = 0;

fn btnCb(_: *button.Button, data: ?*anyopaque) void {
    var count = box.Box.fromRaw(data.?);
    COUNT += 1;
    var buf: [250]u8 = undefined;
    const label = std.fmt.bufPrintZ(buf[0..], "{d}", .{COUNT}) catch "0";
    count.setLabel(label);
}

fn barDrawHandler(b: *box.Box) void {
    draw.setColor(Color.fromRgb(211, 211, 211));
    draw.rectFill(0, b.h(), b.w(), 3);
}

pub fn main() !void {
    try app.init();
    var win = try window.Window.init(.{ .w = WIDTH, .h = HEIGHT, .label = "Flutter-like!" });
    win.freePosition();
    var bar = try box.Box.init(.{ .w = WIDTH, .h = 60, .label = "  FLTK App!" });
    bar.setLabelAlign(Align.left | Align.inside);
    var text = try box.Box.init(.{ .x = 250, .y = 180, .w = 100, .h = 40, .label = "You have pushed the button this many times:" });
    var count = try box.Box.init(.{ .x = 250, .y = 220, .w = 100, .h = 40, .label = "0" });
    var but = try button.Button.init(.{ .x = WIDTH - 100, .y = HEIGHT - 100, .w = 60, .h = 60, .label = "@+6plus" });
    win.end();
    win.resizable(win);
    win.show();

    // Theming
    app.setBackground(Color.fromRgb(255, 255, 255));
    app.setVisibleFocus(false);

    bar.setBox(.flat);
    bar.setLabelSize(22);
    bar.setLabelColor(Color.fromName(.white));
    bar.setColor(BLUE);
    bar.setDrawHandler(barDrawHandler);

    text.setLabelSize(18);
    text.setLabelFont(.times);

    count.setLabelSize(36);
    count.setLabelColor(GRAY);

    but.setColor(BLUE);
    but.setSelectionColor(SEL_BLUE);
    but.setLabelColor(Color.fromName(.white));
    but.setBox(.oflat);
    // End theming

    but.setCallbackEx(btnCb, count);
    try app.run();
}
