const c = @cImport({
    @cInclude("cfl_box.h");
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

    pub fn raw(self: *Box) ?*c.Fl_Box {
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

    pub fn fromVoidPtr(ptr: ?*c_void) Box {
        return Box{
            .inner = @ptrCast(?*c.Fl_Box, ptr),
        };
    }

    pub fn toVoidPtr(self: *Box) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asWidget(self: *const Box) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn handle(self: *Box, cb: fn (w: ?*c.Fl_Box,  ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Box_handle(self.inner, cb, data);
    }

    pub fn draw(self: *Box, cb: fn (w: ?*c.Fl_Box,  data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Box_draw(self.inner, cb, data);
    }
};

test "" {
    @import("std").testing.refAllDecls(@This());
}