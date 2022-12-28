const c = @cImport({
    @cInclude("cfltk/cfl.h");
    @cInclude("cfltk/cfl_image.h");
});
const widget = @import("widget.zig");
const enums = @import("enums.zig");
const std = @import("std");

const Scheme = enum {
    Base,
    Gtk,
    Plastic,
    Gleam,
};

// fltk initizialization of optional functionalities
pub fn init() !void {
    c.Fl_init_all(); // inits all styles, if needed
    c.Fl_register_images(); // register image types supported by fltk, if needed
    const ret = c.Fl_lock(); // enable multithreading, if needed
    if (ret != 0)
        unreachable;
}

pub fn run() !void {
    const ret = c.Fl_run();
    if (ret != 0)
        unreachable;
}

pub fn setScheme(scheme: Scheme) void {
    var temp: [*:0]const u8 = switch (scheme) {
        .Base => "base",
        .Gtk => "gtk+",
        .Plastic => "plastic",
        .Gleam => "gleam",
    };
    _ = c.Fl_set_scheme(temp);
}

// Set the boxtype's draw callback
pub fn setBoxTypeEx(box: enums.BoxType, comptime f: fn (i32, i32, i32, i32, u32) void, ox: i32, oy: i32, ow: i32, oh: i32) void {
    c.Fl_set_box_type_cb(@enumToInt(box),
    // The function must be casted into an exported function before passing
    @ptrCast(fn (i32, i32, i32, i32, u32) callconv(.C) void, f), ox, oy, ow, oh);
}

// Simplified version of setBoxTypeEx to keep code a bit cleaner when offsets
// are unneeded
pub fn setBoxType(box: enums.BoxType, comptime f: fn (i32, i32, i32, i32, u32) void) void {
    setBoxTypeEx(box, f, 0, 0, 0, 0);
}

// Overriding the boxtype's draw is probably more likely to be a usecase than
// copying an existing box, and because C++ allows multiple APIs to have the
// same function name, one must be renamed to allow it to be used in Zig
pub fn copyBoxType(destBox: enums.BoxType, srcBox: enums.BoxType) void {
    c.Fl_set_box_type(@enumToInt(destBox), @enumToInt(srcBox));
}

pub fn event() enums.Event {
    return @intToEnum(enums.Event, c.Fl_event());
}

pub fn eventX() i32 {
    return c.Fl_event_x();
}

pub fn eventY() i32 {
    return c.Fl_event_y();
}

pub fn background(r: u8, g: u8, b: u8) void {
    c.Fl_background(r, g, b);
}

pub fn background2(r: u8, g: u8, b: u8) void {
    c.Fl_background2(r, g, b);
}

pub fn foreground(r: u8, g: u8, b: u8) void {
    c.Fl_foreground(r, g, b);
}

pub const WidgetTracker = struct {
    inner: ?*c.Fl_Widget_Tracker,
    pub fn new(w: widget.Widget) WidgetTracker {
        const ptr = c.Fl_Widget_Tracker_new(@ptrCast(?*c.Fl_Widget, w.inner));
        if (ptr == null) unreachable;
        return WidgetTracker{
            .inner = ptr,
        };
    }

    pub fn deleted() bool {
        return c.Fl_Widget_Tracker_deleted() != 0;
    }

    pub fn delete(self: WidgetTracker) void {
        c.Fl_Widget_Tracker_delete(self.inner);
    }
};

pub fn wait() bool {
    return c.Fl_wait() != 0;
}

pub fn send(comptime T: type, t: T) void {
    c.Fl_awake_msg(@intToPtr(?*anyopaque, @enumToInt(t)));
}

pub fn recv(comptime T: type) ?T {
    var temp = c.Fl_thread_msg();
    if (temp) |ptr| {
        const v = @ptrToInt(ptr);
        return @intToEnum(T, v);
    }
    return null;
}

pub fn rgb_color(r: u8, g: u8, b: u8) u32 {
    return c.Fl_get_rgb_color(r, g, b);
}

test "all" {
    @import("std").testing.refAllDecls(@This());
}
