const c = @cImport({
    @cInclude("cfltk/cfl_input.h");
});
const widget = @import("widget.zig");
const enums = @import("enums.zig");

pub const Output = struct {
    inner: ?*c.Fl_Output,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) Output {
        const ptr = c.Fl_Output_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return Output{
            .inner = ptr,
        };
    }

    pub fn raw(self: *const Output) ?*c.Fl_Output {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Output) Output {
        return Output{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) Output {
        return Output{
            .inner = @ptrCast(?*c.Fl_Output, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*anyopaque) Output {
        return Output{
            .inner = @ptrCast(?*c.Fl_Output, ptr),
        };
    }

    pub fn toVoidPtr(self: *const MultilineOutput) ?*anyopaque {
        return @ptrCast(?*anyopaque, self.inner);
    }

    pub fn asWidget(self: *const Output) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn handle(self: *const Output, cb: fn (w: widget.WidgetPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
        c.Fl_Output_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *const Output, cb: fn (w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Output_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }

    pub fn value(self: *const Output) [*c]const u8 {
        return c.Fl_Output_value(self.inner);
    }

    pub fn setValue(self: *const Output, val: [*c]const u8) void {
        c.Fl_Output_set_value(self.inner, val);
    }

    pub fn setTextFont(self: *const Output, font: enums.Font) void {
        c.Fl_Output_set_text_font(self.inner, @enumToInt(font));
    }

    pub fn setTextColor(self: *const Output, col: enums.Color) void {
        c.Fl_Output_set_text_color(self.inner, col.inner());
    }

    pub fn setTextSize(self: *const Output, sz: u32) void {
        c.Fl_Output_set_text_size(self.inner, sz);
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

    pub fn raw(self: *const MultilineOutput) ?*c.Fl_Multiline_Output {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Multiline_Output) MultilineOutput {
        return MultilineOutput{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) MultilineOutput {
        return MultilineOutput{
            .inner = @ptrCast(?*c.Fl_Multiline_Output, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*anyopaque) MultilineOutput {
        return MultilineOutput{
            .inner = @ptrCast(?*c.Fl_Multiline_Output, ptr),
        };
    }

    pub fn toVoidPtr(self: *const MultilineOutput) ?*anyopaque {
        return @ptrCast(?*anyopaque, self.inner);
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

    pub fn handle(self: *const MultilineOutput, cb: fn (w: widget.WidgetPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
        c.Fl_Multiline_Output_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *const MultilineOutput, cb: fn (w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Multiline_Output_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }
};

test "all" {
    @import("std").testing.refAllDecls(@This());
}
