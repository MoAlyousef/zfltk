const c = @cImport({
    @cInclude("cfl_button.h");
});
const widget = @import("widget.zig");

pub const Button = struct {
    inner: ?*c.Fl_Button,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [:0]const u8) Button {
        const ptr = c.Fl_Button_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return Button{
            .inner = ptr,
        };
    }
    pub fn raw(self: *Button) ?*c.Fl_Button {
        return self.inner;
    }
    pub fn fromRaw(ptr: ?*c.Fl_Button) Button {
        return Button{
            .inner = ptr,
        };
    }
    pub fn fromWidgetPtr(w: widget.WidgetPtr) Button {
        return Button{
            .inner = @ptrCast(*c.Fl_Button, w),
        };
    }
    pub fn fromVoidPtr(ptr: ?*c_void) Button {
        return Button{
            .inner = @ptrCast(*c.Fl_Button, ptr),
        };
    }
    pub fn asWidget(self: *const Button) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }
    pub fn handle(self: *Button, cb: fn (ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Button_handle(self.inner, cb, data);
    }
    pub fn draw(self: *Button, cb: fn (data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Button_draw(self.inner, cb, data);
    }
};
