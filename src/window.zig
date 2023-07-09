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
            return c.Fl_Double_Window_set_cursor(self.raw(), @intFromEnum(cursor));
        }

        pub fn makeModal(self: *Self, val: bool) void {
            return c.Fl_Double_Window_make_modal(self.raw(), @intFromBool(val));
        }

        pub fn setFullscreen(self: *Window, val: bool) void {
            return c.Fl_Double_Window_fullscreen(self.raw(), @intFromBool(val));
        }
    };
}

pub const GlutWindow = struct {
    // Expose methods from `inherited` structs
    pub usingnamespace zfltk.widget.methods(GlutWindow, RawPtr);
    pub usingnamespace zfltk.group.methods(GlutWindow);
    pub usingnamespace glmethods(GlutWindow);
    pub const RawPtr = *c.Fl_Glut_Window;

    pub inline fn init(opts: Widget.Options) !*GlutWindow {
        const label = if (opts.label != null) opts.label.?.ptr else null;

        if (c.Fl_Glut_Window_new(opts.x, opts.y, opts.w, opts.h, label)) |ptr| {
            return @ptrCast(ptr);
        }

        unreachable;
    }

    pub inline fn deinit(self: *GlutWindow) void {
        c.Fl_Glut_Window_delete(self.raw());
    }
};

pub fn glmethods(comptime Self: type) type {
    return struct {
        pub fn setSizeRange(self: *Self, min_w: u31, min_h: u31, max_w: u31, max_h: u31) void {
            return c.Fl_Glut_Window_size_range(self.raw(), min_w, min_h, max_w, max_h);
        }

        pub fn setFullscreen(self: *GlutWindow, val: bool) void {
            return c.Fl_Glut_Window_fullscreen(self.raw(), @intFromBool(val));
        }

        pub fn get_proc_address(self: *GlutWindow, s: [:0]const u8) ?*anyopaque {
            return c.Fl_Glut_Window_get_proc_address(self.raw(), s);
        }

        pub fn flush(self: *GlutWindow) void {
            c.Fl_Glut_Window_flush(self.raw());
        }

        pub fn set_mode(self: *GlutWindow, mode: i32) void {
            c.Fl_Glut_Window_set_mode(self.raw(), mode);
        }

        /// Returns the pixels per unit/point
        pub fn pixels_per_unit(self: *GlutWindow) f32 {
            return c.Fl_Glut_Window_pixels_per_unit(self.raw());
        }

        /// Gets the window's width in pixels
        pub fn pixel_w(self: *GlutWindow) i32 {
            return c.Fl_Glut_Window_pixel_w(self.raw());
        }

        /// Gets the window's height in pixels
        pub fn pixel_h(self: *GlutWindow) i32 {
            return c.Fl_Glut_Window_pixel_h(self.raw());
        }
        /// Swaps the back and front buffers
        pub fn swap_buffers(self: *GlutWindow) void {
            c.Fl_Glut_Window_swap_buffers(self.raw());
        }

        /// Sets the projection so 0,0 is in the lower left of the window
        /// and each pixel is 1 unit wide/tall.
        pub fn ortho(self: *GlutWindow) void {
            c.Fl_Glut_Window_ortho(self.raw());
        }
    };
}

test "all" {
    @import("std").testing.refAllDeclsRecursive(@This());
}
