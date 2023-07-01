const zfltk = @import("zfltk.zig");
const app = zfltk.app;
const c = zfltk.c;
const Widget = zfltk.Widget;
const Group = zfltk.Group;
const enums = zfltk.enums;

pub const Window = struct {
    // Expose methods from `inherited` structs
    pub usingnamespace zfltk.widget.methods(Window, RawPtr);
    pub usingnamespace zfltk.group.methods(Window);
    pub usingnamespace methods(Window);

    pub const RawPtr = *c.Fl_Double_Window;

    pub inline fn init(opts: Widget.Options) !*Window {
        const label = if (opts.label != null) opts.label.?.ptr else null;

        if (c.Fl_Double_Window_new(opts.x, opts.y, opts.w, opts.h, label)) |ptr| {
            return @ptrCast(ptr);
        }

        unreachable;
    }

    pub inline fn deinit(self: *Window) void {
        c.Fl_Double_Window_delete(self.raw());
    }
};

pub fn methods(comptime Self: type) type {
    return struct {
        pub fn handle(self: *Self, cb: fn (w: Widget.RawPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
            c.Fl_Double_Window_handle(self.raw(), @ptrCast(cb), data);
        }

        pub fn draw(self: *Self, cb: fn (w: Widget.RawPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
            c.Fl_Double_Window_handle(self.raw(), @ptrCast(cb), data);
        }

        pub fn setSizeRange(self: *Self, min_w: u31, min_h: u31, max_w: u31, max_h: u31) void {
            return c.Fl_Double_Window_size_range(self.raw(), min_w, min_h, max_w, max_h);
        }

        pub fn iconize(self: *Self) void {
            c.Fl_Double_Window_iconize(self.raw());
        }

        pub fn freePosition(self: *Self) void {
            c.Fl_Double_Window_free_position(self.raw());
        }

        pub fn setCursor(self: *Self, cursor: enums.Cursor) void {
            return c.Fl_Double_Window_set_cursor(self.raw(), cursor);
        }

        pub fn makeModal(self: *Self, val: bool) void {
            return c.Fl_Double_Window_make_modal(self.raw(), @intFromBool(val));
        }

        pub fn setFullscreen(self: *Window, val: bool) void {
            return c.Fl_Double_Window_fullscreen(self.raw(), @intFromBool(val));
        }
    };
}

test "all" {
    @import("std").testing.refAllDecls(@This());
}
