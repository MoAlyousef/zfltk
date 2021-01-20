const c = @cImport({
    @cInclude("cfl_input.h");
});
const widget = @import("widget.zig");

pub const Input = struct {
    inner: ?*c.Fl_Input,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [:0]const u8) Input {
        const ptr = c.Fl_Input_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return Input{
            .inner = ptr,
        };
    }
    pub fn raw(self: *Input) ?*c.Fl_Input {
        return self.inner;
    }
    pub fn fromRaw(ptr: ?*c.Fl_Input) Input {
        return Input{
            .inner = ptr,
        };
    }
    pub fn fromWidgetPtr(w: widget.WidgetPtr) Input {
        return Input{
            .inner = @ptrCast(*c.Fl_Input, w),
        };
    }
    pub fn fromVoidPtr(ptr: ?*c_void) Input {
        return Input{
            .inner = @ptrCast(*c.Fl_Input, ptr),
        };
    }
    pub fn asWidget(self: *const Input) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }
    pub fn handle(self: *Input, cb: fn (ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Input_handle(self.inner, cb, data);
    }
    pub fn draw(self: *Input, cb: fn (data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Input_draw(self.inner, cb, data);
    }
    pub fn value(self: *const Input) [*c]const u8 {
        return c.Fl_Input_value(self.inner);
    }
    pub fn setValue(self: *Input, val: [:0]const u8) void {
        c.Fl_Input_set_value(self.inner, val);
    }
};
