const std = @import("std");
const zfltk = @import("zfltk.zig");
const app = zfltk.app;
const c = zfltk.c;
const Widget = zfltk.widget.Widget;
const Group = zfltk.Group;
const enums = zfltk.enums;

pub const Window = struct {
    // Expose methods from `inherited` structs
    pub usingnamespace zfltk.widget.methods(Window, RawPtr);
    pub usingnamespace zfltk.group.methods(Window, RawPtr);
    pub usingnamespace methods(Window);

    pub const RawPtr = *c.Fl_Double_Window;
    const type_name = @typeName(RawPtr);
    const ptr_name = type_name[(std.mem.indexOf(u8, type_name, "struct_Fl_") orelse 0) + 7 .. type_name.len];

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

    pub fn freePosition(self: *Window) void {
        @field(c, ptr_name ++ "_free_position")(self.raw());
    }

    pub fn flush(self: *Window) void {
        c.Fl_Double_Window_flush(self.raw());
    }
};

pub const GlutWindow = struct {
    // Expose methods from `inherited` structs
    pub usingnamespace zfltk.widget.methods(GlutWindow, RawPtr);
    pub usingnamespace zfltk.group.methods(GlutWindow, RawPtr);
    pub usingnamespace methods(GlutWindow);
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

    pub fn getProcAddress(self: *GlutWindow, s: [:0]const u8) ?*anyopaque {
        return c.Fl_Glut_Window_get_proc_address(self.raw(), s);
    }

    pub fn flush(self: *GlutWindow) void {
        c.Fl_Glut_Window_flush(self.raw());
    }

    pub fn setMode(self: *GlutWindow, mode: i32) void {
        c.Fl_Glut_Window_set_mode(self.raw(), mode);
    }

    /// Returns the pixels per unit/point
    pub fn pixelsPerUnit(self: *GlutWindow) f32 {
        return c.Fl_Glut_Window_pixels_per_unit(self.raw());
    }

    /// Gets the window's width in pixels
    pub fn pixelW(self: *GlutWindow) i32 {
        return c.Fl_Glut_Window_pixel_w(self.raw());
    }

    /// Gets the window's height in pixels
    pub fn pixelH(self: *GlutWindow) i32 {
        return c.Fl_Glut_Window_pixel_h(self.raw());
    }
    /// Swaps the back and front buffers
    pub fn swapBuffers(self: *GlutWindow) void {
        c.Fl_Glut_Window_swap_buffers(self.raw());
    }

    /// Sets the projection so 0,0 is in the lower left of the window
    /// and each pixel is 1 unit wide/tall.
    pub fn ortho(self: *GlutWindow) void {
        c.Fl_Glut_Window_ortho(self.raw());
    }

    pub fn makeCurrent(self: *GlutWindow) void {
        c.Fl_Glut_Window_make_current(self.raw());
    }

    /// Returns whether the OpeGL context is still valid
    pub fn valid(self: *GlutWindow) bool {
        return c.Fl_Glut_Window_valid(self.raw()) != 0;
    }

    /// Mark the OpeGL context as still valid
    pub fn setValid(self: *GlutWindow, v: bool) void {
        return c.Fl_Glut_Window_set_valid(self.raw(), @intFromBool(v));
    }

    /// Returns whether the context is valid upon creation
    pub fn contextValid(self: *GlutWindow) bool {
        return c.Fl_Glut_Window_context_valid(self.raw()) != 0;
    }

    /// Mark the context as valid upon creation
    pub fn setContextValid(self: *GlutWindow, v: bool) void {
        c.Fl_Glut_Window_set_context_valid(self.raw(), @intFromBool(v));
    }

    /// Returns the GlContext
    pub fn context(self: *GlutWindow) ?*anyopaque {
        return c.Fl_Glut_Window_context(self.raw());
    }

    /// Sets the GlContext
    pub fn setContext(self: *GlutWindow, ctx: ?*anyopaque, destroy_flag: bool) void {
        c.Fl_Glut_Window_set_context(self.raw(), ctx, @intFromBool(destroy_flag));
    }
};

fn methods(comptime Self: type) type {
    return struct {
        pub fn setSizeRange(self: *Self, min_w: u31, min_h: u31, max_w: u31, max_h: u31) void {
            return c.Fl_Window_size_range(@ptrCast(self.raw()), min_w, min_h, max_w, max_h);
        }

        pub fn iconize(self: *Self) void {
            c.Fl_Window_iconize(@ptrCast(self.raw()));
        }

        pub fn setCursor(self: *Self, cursor: enums.Cursor) void {
            return c.Fl_Window_set_cursor(@ptrCast(self.raw()), @intFromEnum(cursor));
        }

        pub fn makeModal(self: *Self, val: bool) void {
            return c.Fl_Window_make_modal(@ptrCast(self.raw()), @intFromBool(val));
        }

        pub fn setFullscreen(self: *Window, val: bool) void {
            return c.Fl_Window_fullscreen(@ptrCast(self.raw()), @intFromBool(val));
        }
    };
}

test "all" {
    @import("std").testing.refAllDeclsRecursive(@This());
}
