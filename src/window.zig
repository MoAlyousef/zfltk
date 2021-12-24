const c = @cImport({
    @cInclude("cfl_window.h");
});
const widget = @import("widget.zig");
const group = @import("group.zig");
const enums = @import("enums.zig");

pub const Window = struct {
    inner: ?*c.Fl_Double_Window,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) Window {
        const ptr = c.Fl_Double_Window_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return Window{
            .inner = ptr,
        };
    }

    pub fn raw(self: *Window) ?*c.Fl_Double_Window {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Double_Window) Window {
        return Window{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) Window {
        return Window{
            .inner = @ptrCast(?*c.Fl_Double_Window, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*anyopaque) Window {
        return Window{
            .inner = @ptrCast(?*c.Fl_Double_Window, ptr),
        };
    }

    pub fn toVoidPtr(self: *Window) ?*anyopaque {
        return @ptrCast(?*anyopaque, self.inner);
    }

    pub fn asWidget(self: *const Window) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asGroup(self: *Window) group.Group {
        return group.Group{
            .inner = @ptrCast(group.GroupPtr, self.inner),
        };
    }

    pub fn handle(self: *Window, cb: fn (w: widget.WidgetPtr,  ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
        c.Fl_Double_Window_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *Window, cb: fn (w: widget.WidgetPtr,  data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Double_Window_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }

    pub fn sizeRange(self: *Window, min_w: i32, min_h: i32, max_w: i32, max_h: i32) void {
        return c.Fl_Double_Window_size_range(self.inner, min_w, min_h, max_w, max_h);
    }

    pub fn iconize(self: *Window) void {
        return c.Fl_Double_Window_iconize(self.inner);
    }

    pub fn freePosition(self: *Window) void {
        return c.Fl_Double_Window_free_position(self.inner);
    }

    pub fn setCursor(self: *Window, cursor: enums.Cursor) void {
        return c.Fl_Double_Window_set_cursor(self.inner, cursor);
    }

    pub fn makeModal(self: *Window, val: bool) void {
        return c.Fl_Double_Window_make_modal(self.inner, @boolToInt(val));
    }

    pub fn fullscreen(self: *Window, val: bool) void {
        return c.Fl_Double_Window_fullscreen(self.inner, @boolToInt(val));
    }
};

test "" {
    @import("std").testing.refAllDecls(@This());
}