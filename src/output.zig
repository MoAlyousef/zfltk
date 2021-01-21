const c = @cImport({
    @cInclude("cfl_output.h");
});
const widget = @import("widget.zig");

pub const Output = struct {
    inner: ?*c.Fl_Output,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) Output {
        const ptr = c.Fl_Output_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return Output{
            .inner = ptr,
        };
    }

    pub fn raw(self: *Output) ?*c.Fl_Output {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Output) Output {
        return Output{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) Output {
        return Output{
            .inner = @ptrCast(*c.Fl_Output, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) Output {
        return Output{
            .inner = @ptrCast(*c.Fl_Output, ptr),
        };
    }

    pub fn toVoidPtr(self: *MultilineOutput) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asWidget(self: *const Output) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn handle(self: *Output, cb: fn (ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Output_handle(self.inner, cb, data);
    }

    pub fn draw(self: *Output, cb: fn (data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Output_draw(self.inner, cb, data);
    }

    pub fn value(self: *const Output) [*c]const u8 {
        return c.Fl_Output_value(self.inner);
    }

    pub fn setValue(self: *Output, val: [*c]const u8) void {
        c.Fl_Output_set_value(self.inner, val);
    }
};

pub const MultilineOutput = struct {
    inner: ?*c.Fl_Multiline_Output,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) MultilineOutput {
        const ptr = c.Fl_Multiline_Output_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return MultilineOutput{
            .inner = ptr,
        };
    }

    pub fn raw(self: *MultilineOutput) ?*c.Fl_Multiline_Output {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Multiline_Output) MultilineOutput {
        return MultilineOutput{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) MultilineOutput {
        return MultilineOutput{
            .inner = @ptrCast(*c.Fl_Multiline_Output, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) MultilineOutput {
        return MultilineOutput{
            .inner = @ptrCast(*c.Fl_Multiline_Output, ptr),
        };
    }

    pub fn toVoidPtr(self: *MultilineOutput) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asWidget(self: *const MultilineOutput) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asOutput(self: *const MultilineOutput) Output {
        return Output{
            .inner = @ptrCast(?*c.Fl_Output, self.inner),
        };
    }

    pub fn handle(self: *MultilineOutput, cb: fn (ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Multiline_Output_handle(self.inner, cb, data);
    }

    pub fn draw(self: *MultilineOutput, cb: fn (data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Multiline_Output_draw(self.inner, cb, data);
    }
};
