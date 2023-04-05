const c = @cImport({
    @cInclude("cfl.h");
    @cInclude("cfl_image.h");
});
const widget = @import("widget.zig");
const enums = @import("enums.zig");
const Color = enums.Color;
const Font = enums.Font;
const std = @import("std");

const Scheme = enum {
    Base,
    Gtk,
    Plastic,
    Gleam,
    Oxy,
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
    _ = c.Fl_set_scheme(switch (scheme) {
        .Base => "base",
        .Gtk => "gtk+",
        .Plastic => "plastic",
        .Gleam => "gleam",
        .Oxy => "oxy",
    });
}

pub fn lock() !void {
    if (c.Fl_lock() != 0) {
        return error.LockError;
    }
}

pub fn unlock() void {
    c.Fl_unlock();
}

// Set the boxtype's draw callback
pub fn setBoxTypeEx(box: enums.BoxType, comptime f: fn (i32, i32, i32, i32, enums.Color) void, ox: i32, oy: i32, ow: i32, oh: i32) void {
    c.Fl_set_box_type_cb(@enumToInt(box),
    // The function must be casted into an exported function before passing
    @ptrCast(*const fn (i32, i32, i32, i32, u32) callconv(.C) void, &f), ox, oy, ow, oh);
}

// Simplified version of setBoxTypeEx to keep code a bit cleaner when offsets
// are unneeded
pub fn setBoxType(box: enums.BoxType, comptime f: fn (i32, i32, i32, i32, enums.Color) void) void {
    setBoxTypeEx(box, f, 0, 0, 0, 0);
}

// Overriding the boxtype's draw is probably more likely to be a usecase than
// copying an existing box, and because C++ allows multiple APIs to have the
// same function name, one must be renamed to allow it to be used in Zig
pub fn copyBoxType(destBox: enums.BoxType, srcBox: enums.BoxType) void {
    c.Fl_set_box_type(@enumToInt(destBox), @enumToInt(srcBox));
}

pub fn setVisibleFocus(focus: bool) void {
    c.Fl_set_visible_focus(@boolToInt(focus));
}

/// Sets a `free` color in the FLTK color table. These are meant to be
/// user-defined
pub fn setColor(idx: u4, col: enums.Color) void {
    // FLTK enumerations.H defines `FREE_COLOR` as 16
    setColorAny(@intCast(u8, idx) + 16, col);
}

/// Allows setting any color in the color table
/// Most colors are not intended to be overridden, `setColor` should be
/// preferred unless the goal is to override the theme's color scheme.
/// Overriding these may cause display elements to look incorrect
pub fn setColorAny(idx: u8, col: enums.Color) void {
    c.Fl_set_color(idx, col.r, col.g, col.b);
}

pub fn loadFont(path: [:0]const u8) !void {
    _ = c.Fl_load_font(path.ptr);
}

pub fn unloadFont(path: [:0]const u8) !void {
    c.Fl_unload_font(path.ptr);
}

pub fn setFont(face: Font, name: [:0]const u8) void {
    c.Fl_set_font2(@enumToInt(face), name.ptr);
}

pub fn setFontSize(sz: i32) void {
    c.Fl_set_font_size(sz);
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

// TODO: Implement as an enum (maybe have another function for unknown keys?)
pub fn eventKey() i32 {
    return c.Fl_event_key();
}

pub fn setBackground(col: Color) void {
    c.Fl_background(col.r, col.g, col.b);
}

pub fn setBackground2(col: Color) void {
    c.Fl_background2(col.r, col.g, col.b);
}

pub fn setForeground(col: Color) void {
    c.Fl_foreground(col.r, col.g, col.b);
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

pub fn awake() void {
    c.Fl_awake();
}

pub fn wait() bool {
    return c.Fl_wait() != 0;
}

pub fn waitFor(v: f64) bool {
    return c.Fl_wait_for(v) != 0;
}

pub fn check() i32 {
    return c.Fl_check();
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

// Executes the callback function after `d` (duration in seconds) has passed
pub fn timeout(d: f32, comptime f: fn () void) void {
    const v: ?*anyopaque = null;
    c.Fl_add_timeout(d, @ptrCast(?*const fn (?*anyopaque) callconv(.C) void, &f), v);
}

// The same as `timeout` but allows for data to be passed in
pub fn timeoutEx(d: f32, comptime f: fn (?*anyopaque) void) void {
    const v: ?*anyopaque = null;
    c.Fl_add_timeout(d, @ptrCast(?*const fn (?*anyopaque) callconv(.C) void, &f), v);
}

pub fn setMenuLinespacing(h: i32) void {
    c.Fl_set_menu_linespacing(h);
}

test "all" {
    @import("std").testing.refAllDecls(@This());
}
