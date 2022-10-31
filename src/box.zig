const c = @cImport({
    @cInclude("cfltk/cfl_box.h");
});
const widget = @import("widget.zig");

pub const Box = struct {
    inner: ?*c.Fl_Box,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) Box {
        const ptr = c.Fl_Box_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return Box{
            .inner = ptr,
        };
    }

    pub fn raw(self: *const Box) ?*c.Fl_Box {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Box) Box {
        return Box{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) Box {
        return Box{
            .inner = @ptrCast(?*c.Fl_Box, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*anyopaque) Box {
        return Box{
            .inner = @ptrCast(?*c.Fl_Box, ptr),
        };
    }

    pub fn toVoidPtr(self: *const Box) ?*anyopaque {
        return @ptrCast(?*anyopaque, self.inner);
    }

    pub fn asWidget(self: *const Box) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn handle(self: *const Box, cb: fn (w: widget.WidgetPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
        c.Fl_Box_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *const Box, cb: fn (w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Box_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }
};

test "all" {
    @import("std").testing.refAllDecls(@This());
}
