const zfltk = @import("zfltk");
const app = zfltk.app;
const draw = zfltk.draw;
const Window = zfltk.window.Window;
const Widget = zfltk.widget.Widget;
const Button = zfltk.button.Button;
const Box = zfltk.box.Box;
const enums = zfltk.enums;
const Color = enums.Color;
const Event = enums.Event;
const Align = enums.Align;
const std = @import("std");

pub fn main() !void {
    try app.init();
    app.setScheme(.oxy);

    app.setVisibleFocus(false);

    var win = try Window.init(.{
        .w = 400,
        .h = 284,

        .label = "Custom widget example",
    });

    var sw1 = try Switch.init(.{
        .x = 10,
        .y = 200,
        .w = 380,

        .label = "Very important feature",
    });

    var sw2 = try Switch.init(.{
        .x = 10,
        .y = 242,
        .w = 380,
        .h = 32,

        .label = "Enable animation for the first switch",
    });

    var box = try Box.init(.{
        .x = 10,
        .y = 10,
        .w = 380,
        .h = 180,

        .boxtype = .up,
        .label = "Off",
    });

    box.setLabelFont(.courier);
    box.setLabelSize(24);

    sw1.setCallbackEx(switch1Cb, box);
    sw1.widget().setColor(Color.fromName(.cyan));
    sw2.setValue(true);
    sw2.setCallbackEx(switch2Cb, sw1);
    //_ = sw2;

    win.end();
    win.show();

    try app.run();
}

fn switch1Cb(sw: *Switch, data: ?*anyopaque) void {
    var box = Box.fromRaw(data.?);

    const str = if (sw.value()) "On" else "Off";
    box.setLabel(str);
}

fn switch2Cb(sw2: *Switch, data: ?*anyopaque) void {
    var sw1 = Switch.fromVoidPtr(data.?);

    const color = if (sw2.value()) Color.fromName(.cyan) else Color.fromName(.background);
    sw1.widget().setColor(color);
    sw1.setAnimation(sw2.value());
}

const Switch = struct {
    box1: *Box,
    box2: *Box,
    label: *Box,
    on: bool,
    opts: Options,
    animated: bool,

    callback_data: ?*anyopaque,
    callback: union(enum) {
        normal: ?*const fn (*Switch) void,
        extended: ?*const fn (*Switch, ?*anyopaque) void,
    },

    pub const Options = struct {
        x: u31 = 0,
        y: u31 = 0,
        w: u31 = 64,
        h: u31 = 32,

        label: ?[:0]const u8 = null,
    };

    fn drawBox(x1: i32, y1: i32, x2: i32, y2: i32, col: Color) callconv(.C) void {
        draw.box(.down, x1 + 4, y1 + 4, x2 - 12, y2 - 8, col);
    }

    fn drawBox2(x1: i32, y1: i32, x2: i32, y2: i32, col: Color) callconv(.C) void {
        draw.box(.up, x1, y1, x2, y2, col);
        draw.box(.down, x1 + 4, y1 + 4, x2 - 8, y2 - 8, col);
    }

    pub fn init(opts: Options) !*Switch {
        var self = try app.allocator.create(Switch);
        self.opts = opts;
        self.animated = true;
        self.callback = .{ .normal = null };

        app.setBoxTypeEx(.free, drawBox, 4, 4, -8, -8);
        //app.setBoxTypeEx(.border_frame, drawBox2, 4, 4, -8, -8);

        //        draw.box(.free, 0, 0, self.opts.w, self.opts.h, Color.fromName(.red));

        self.box2 = try Box.init(.{
            .x = opts.x,
            .y = opts.y,
            .w = (opts.h * 2) + 4,
            .h = opts.h,

            .boxtype = .free,
        });

        self.box1 = try Box.init(.{
            .x = opts.x,
            .y = opts.y,
            .w = opts.h,
            .h = opts.h,

            .boxtype = .up,
        });

        self.label = try Box.init(.{
            .x = opts.x + (opts.h * 2) + 4,
            .y = opts.y,
            .w = opts.w - (opts.h * 2),
            .h = opts.h,

            .label = opts.label,
            //.boxtype = .up,
        });

        self.label.setLabelAlign(Align.left | Align.inside);

        self.box1.setEventHandlerEx(clickEventHandle, self);
        self.box2.setEventHandlerEx(clickEventHandle, self);
        self.label.setEventHandlerEx(clickEventHandle, self);

        return self;
    }

    pub fn deinit(self: *Switch) void {
        self.box1.deinit();
        self.box2.deinit();
        self.label.deinit();
        app.allocator.destroy(self);
    }

    fn clickEventHandle(_: *Box, ev: Event, data: ?*anyopaque) bool {
        var self = Switch.fromVoidPtr(data.?);

        //        var e = self.box1.x();
        //        self.box1.parent().redraw();
        //        _ = e;
        //        self.box1.resize(0, 0, 200, 200);

        switch (ev) {
            .push => {
                const h = self.box1.h();
                const x = if (self.on) self.opts.x + h else self.opts.x;
                const y = self.box1.y();
                const w = self.box1.w();
                //                const w2 = self.options.w;

                const new_x = if (self.on) x - (h) else x + (h);

                self.on = !self.on;

                // Activate callback
                switch (self.callback) {
                    .normal => {
                        if (self.callback.normal) |cb| cb(self);
                    },
                    .extended => {
                        if (self.callback.extended) |cb| cb(self, self.callback_data);
                    },
                }

                // Sliding animation
                if (self.animated) {
                    if (self.on) {
                        while (self.box1.x() < new_x) {
                            var x1 = self.box1.x() +| h / 6;
                            if (x1 > new_x) x1 = new_x;

                            // One frame at 60fps (what FLTK uses)
                            std.time.sleep(16_666_666);
                            self.box1.resize(x1, y, w, h);
                            self.box1.parent().?.redraw();

                            _ = app.check();

                            //  draw.box(.down, x, y, w, h, Color.fromName(.background));
                        }
                    } else {
                        while (self.box1.x() > new_x) {
                            var x1 = self.box1.x() -| h / 6;
                            if (x1 < new_x) x1 = new_x;

                            std.time.sleep(16_666_666);
                            self.box1.resize(x1, y, w, h);
                            self.box1.parent().?.redraw();
                            _ = app.check();
                        }
                    }
                } else {
                    self.box1.resize(new_x, y, w, h);
                    self.box1.parent().?.redraw();
                    _ = app.check();
                }

                return true;
            },
            //     .push => return true,
            else => return false,
        }

        return false;
    }

    pub fn fromVoidPtr(ptr: *anyopaque) *Switch {
        return @ptrCast(@alignCast(ptr));
    }

    pub fn widget(self: *Switch) *Widget {
        //return  @ptrCast(self);
        return self.box1.widget();
    }

    pub fn setCallback(self: *Switch, f: *const fn (*Switch) void) void {
        self.callback = .{ .normal = f };
    }

    pub fn setCallbackEx(self: *Switch, f: *const fn (*Switch, ?*anyopaque) void, data: ?*anyopaque) void {
        self.callback = .{ .extended = f };
        self.callback_data = data;
    }

    pub fn value(self: *const Switch) bool {
        return self.on;
    }

    pub fn setValue(self: *Switch, val: bool) void {
        const x = self.box1.x();
        const y = self.box1.y();
        const w = self.box1.w();
        const h = self.box1.h();
        const new_x = if (self.on) x - (h) else x + (h);

        self.on = val;
        self.box1.resize(new_x, y, w, h);
        self.box1.parent().?.redraw();

        _ = app.check();
    }

    pub fn setAnimation(self: *Switch, val: bool) void {
        self.animated = val;
    }
};
