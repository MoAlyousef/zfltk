const zfltk = @import("zfltk.zig");
const Widget = @import("widget.zig").Widget;
const enums = @import("enums.zig");
const Color = enums.Color;
const Font = enums.Font;
const std = @import("std");
const c = zfltk.c;

const Scheme = enum {
    base,
    gtk,
    plastic,
    gleam,
    oxy,
};

// TODO: allow setting this
pub var allocator: std.mem.Allocator = std.heap.c_allocator;

// TODO: Add more error types
pub const AppError = error{
    Error,
};

// Converts a C error code to a Zig error enum
inline fn AppErrorFromInt(err: c_int) AppError!void {
    return switch (err) {
        0 => {},

        else => AppError.Error,
    };
}

// fltk initizialization of optional functionalities
pub fn init() !void {
    c.Fl_init_all(); // inits all styles, if needed
    c.Fl_register_images(); // register image types supported by fltk, if needed

    // Enable multithreading
    if (c.Fl_lock() != 0) return error.LockError;
}

pub inline fn run() !void {
    return AppErrorFromInt(c.Fl_run());
}

pub inline fn setScheme(scheme: Scheme) void {
    _ = c.Fl_set_scheme(switch (scheme) {
        .base => "base",
        .gtk => "gtk+",
        .plastic => "plastic",
        .gleam => "gleam",
        .oxy => "oxy",
    });
}

pub inline fn lock() !void {
    if (c.Fl_lock() != 0) return error.LockError;
}

pub inline fn unlock() void {
    c.Fl_unlock();
}

// Set the boxtype's draw callback
pub inline fn setBoxTypeEx(
    box: enums.BoxType,
    f: *const fn (i32, i32, i32, i32, enums.Color) callconv(.C) void,
    off_x: i32,
    off_y: i32,
    off_w: i32,
    off_h: i32,
) void {
    c.Fl_set_box_type_cb(
        @intFromEnum(box),
        @ptrCast(f),
        off_x,
        off_y,
        off_w,
        off_h,
    );
}

// Simplified version of setBoxTypeEx to keep code a bit cleaner when offsets
// are unneeded
pub inline fn setBoxType(
    box: enums.BoxType,
    f: *const fn (i32, i32, i32, i32, enums.Color) callconv(.C) void,
) void {
    setBoxTypeEx(box, f, 0, 0, 0, 0);
}

// Overriding the boxtype's draw is probably more likely to be a usecase than
// copying an existing box, and because C++ allows multiple APIs to have the
// same function name, one must be renamed to allow it to be used in Zig
pub inline fn copyBoxType(destBox: enums.BoxType, srcBox: enums.BoxType) void {
    c.Fl_set_box_type(@intFromEnum(destBox), @intFromEnum(srcBox));
}

pub inline fn setVisibleFocus(focus: bool) void {
    c.Fl_set_visible_focus(@intFromBool(focus));
}

/// Sets a `free` color in the FLTK color table. These are meant to be
/// user-defined
pub inline fn setColor(idx: u4, col: enums.Color) void {
    // FLTK enumerations.H defines `FREE_COLOR` as 16
    setColorAny(@as(u8, idx) + 16, col);
}

/// Allows setting any color in the color table
/// Most colors are not intended to be overridden, `setColor` should be
/// preferred unless the goal is to override the theme's color scheme.
/// Overriding these may cause display elements to look incorrect
pub inline fn setColorAny(idx: u8, col: enums.Color) void {
    c.Fl_set_color(idx, col.r, col.g, col.b);
}

pub inline fn loadFont(path: [:0]const u8) !void {
    _ = c.Fl_load_font(path.ptr);
}

pub inline fn unloadFont(path: [:0]const u8) !void {
    c.Fl_unload_font(path.ptr);
}

pub inline fn setFont(face: Font, name: [:0]const u8) void {
    c.Fl_set_font2(@intFromEnum(face), name.ptr);
}

pub inline fn setFontSize(sz: u31) void {
    c.Fl_set_font_size(sz);
}

pub inline fn event() enums.Event {
    return @enumFromInt(c.Fl_event());
}

pub inline fn eventX() i32 {
    return c.Fl_event_x();
}

pub inline fn eventY() i32 {
    return c.Fl_event_y();
}

// TODO: Implement as an enum (maybe have another function for unknown keys?)
pub inline fn eventKey() i32 {
    return c.Fl_event_key();
}

pub inline fn setBackground(col: Color) void {
    c.Fl_background(col.r, col.g, col.b);
}

pub inline fn setBackground2(col: Color) void {
    c.Fl_background2(col.r, col.g, col.b);
}

pub inline fn setForeground(col: Color) void {
    c.Fl_foreground(col.r, col.g, col.b);
}

pub const WidgetTracker = struct {
    inner: RawPointer,

    pub const RawPointer = *c.Fl_Widget_Tracker;

    pub fn init(w: *Widget) WidgetTracker {
        if (c.Fl_Widget_Tracker_new(w.raw())) |ptr| {
            return WidgetTracker{ .inner = ptr };
        }

        unreachable;
    }

    pub fn deleted(self: *WidgetTracker) bool {
        return c.Fl_Widget_Tracker_deleted(self.inner) != 0;
    }

    pub fn delete(self: WidgetTracker) void {
        c.Fl_Widget_Tracker_delete(self.inner);
    }
};

pub inline fn awake() void {
    c.Fl_awake();
}

pub inline fn wait() bool {
    return c.Fl_wait() != 0;
}

pub inline fn waitFor(v: f64) bool {
    return c.Fl_wait_for(v) != 0;
}

pub inline fn check() i32 {
    return c.Fl_check();
}

pub inline fn send(comptime T: type, t: T) void {
    c.Fl_awake_msg(@ptrFromInt(@intFromEnum(t)));
}

pub fn recv(comptime T: type) ?T {
    const temp = c.Fl_thread_msg();

    if (temp) |ptr| {
        return @enumFromInt(@intFromPtr(ptr));
    }

    return null;
}

// Executes the callback function after `d` (duration in seconds) has passed
// TODO: refactor these like `Widget.setCallback`
pub fn addTimeout(d: f32, f: *const fn () void) void {
    c.Fl_add_timeout(d, &zfltk_timeout_handler, @ptrFromInt(@intFromPtr(f)));
}

fn zfltk_timeout_handler(data: ?*anyopaque) callconv(.C) void {
    const cb: *const fn () void = @ptrCast(data);
    cb();
}

// The same as `timeout` but allows for data to be passed in
pub fn addTimeoutEx(d: f32, f: *const fn (?*anyopaque) void, data: ?*anyopaque) void {
    var container = allocator.alloc(usize, 2) catch unreachable;

    container[0] = @intFromPtr(f);
    container[1] = @intFromPtr(data);

    c.Fl_add_timeout(d, &zfltk_timeout_handler_ex, @ptrCast(container.ptr));
}

fn zfltk_timeout_handler_ex(data: ?*anyopaque) callconv(.C) void {
    const container: *[2]usize = @ptrCast(@alignCast(data));

    const cb: *const fn (?*anyopaque) void = @ptrFromInt(container[0]);

    //    std.debug.print("test1 {d}\n", .{container[0]});

    cb(@ptrFromInt(container[1]));
}

pub fn setMenuLinespacing(h: i32) void {
    c.Fl_set_menu_linespacing(h);
}

test "all" {
    @import("std").testing.refAllDeclsRecursive(@This());
}
