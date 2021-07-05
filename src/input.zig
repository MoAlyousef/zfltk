const c = @cImport({
    @cInclude("cfl_input.h");
});
const widget = @import("widget.zig");

pub const Input = struct {
    inner: ?*c.Fl_Input,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) Input {
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
            .inner = @ptrCast(?*c.Fl_Input, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) Input {
        return Input{
            .inner = @ptrCast(?*c.Fl_Input, ptr),
        };
    }

    pub fn toVoidPtr(self: *Input) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asWidget(self: *const Input) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn handle(self: *Input, cb: fn (w: widget.WidgetPtr,  ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Input_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *Input, cb: fn (w: widget.WidgetPtr,  data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Input_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }

    pub fn value(self: *const Input) [*c]const u8 {
        return c.Fl_Input_value(self.inner);
    }

    pub fn setValue(self: *Input, val: [*c]const u8) void {
        c.Fl_Input_set_value(self.inner, val);
    }

    pub fn setTextFont(self: *Input, font: enums.Font) void {
        c.Fl_Input_set_text_font(self.inner, @enumToInt(font));
    }

    pub fn setTextColor(self: *Input, col: u32) void {
        c.Fl_Input_set_text_color(self.inner, col);
    }

    pub fn setTextSize(self: *Input, sz: u32) void {
        c.Fl_Input_set_text_size(self.inner, sz);
    }
};

pub const MultilineInput = struct {
    inner: ?*c.Fl_Multiline_Input,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) MultilineInput {
        const ptr = c.Fl_Multiline_Input_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return MultilineInput{
            .inner = ptr,
        };
    }

    pub fn raw(self: *MultilineInput) ?*c.Fl_Multiline_Input {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Multiline_Input) MultilineInput {
        return MultilineInput{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) MultilineInput {
        return MultilineInput{
            .inner = @ptrCast(?*c.Fl_Multiline_Input, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) MultilineInput {
        return MultilineInput{
            .inner = @ptrCast(?*c.Fl_Multiline_Input, ptr),
        };
    }

    pub fn toVoidPtr(self: *MultilineInput) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asWidget(self: *const MultilineInput) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asInput(self: *const MultilineInput) Input {
        return Input{
            .inner = @ptrCast(?*c.Fl_Input, self.inner),
        };
    }

    pub fn handle(self: *MultilineInput, cb: fn (w: widget.WidgetPtr,  ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Multiline_Input_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *MultilineInput, cb: fn (w: widget.WidgetPtr,  data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Multiline_Input_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }
};

pub const IntInput = struct {
    inner: ?*c.Fl_Int_Input,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) IntInput {
        const ptr = c.Fl_Int_Input_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return IntInput{
            .inner = ptr,
        };
    }

    pub fn raw(self: *IntInput) ?*c.Fl_Int_Input {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Int_Input) IntInput {
        return IntInput{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) IntInput {
        return IntInput{
            .inner = @ptrCast(?*c.Fl_Int_Input, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) IntInput {
        return IntInput{
            .inner = @ptrCast(?*c.Fl_Int_Input, ptr),
        };
    }

    pub fn toVoidPtr(self: *IntInput) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asWidget(self: *const IntInput) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asInput(self: *const IntInput) Input {
        return Input{
            .inner = @ptrCast(?*c.Fl_Input, self.inner),
        };
    }

    pub fn handle(self: *IntInput, cb: fn (w: widget.WidgetPtr,  ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Int_Input_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *IntInput, cb: fn (w: widget.WidgetPtr,  data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Int_Input_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }
};

pub const FloatInput = struct {
    inner: ?*c.Fl_Float_Input,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) FloatInput {
        const ptr = c.Fl_Float_Input_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return FloatInput{
            .inner = ptr,
        };
    }

    pub fn raw(self: *FloatInput) ?*c.Fl_Float_Input {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Float_Input) FloatInput {
        return FloatInput{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) FloatInput {
        return FloatInput{
            .inner = @ptrCast(?*c.Fl_Float_Input, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) FloatInput {
        return FloatInput{
            .inner = @ptrCast(?*c.Fl_Float_Input, ptr),
        };
    }

    pub fn toVoidPtr(self: *FloatInput) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asWidget(self: *const FloatInput) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asInput(self: *const FloatInput) Input {
        return Input{
            .inner = @ptrCast(?*c.Fl_Input, self.inner),
        };
    }

    pub fn handle(self: *FloatInput, cb: fn (w: widget.WidgetPtr,  ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Float_Input_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *FloatInput, cb: fn (w: widget.WidgetPtr,  data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Float_Input_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }
};

pub const SecretInput = struct {
    inner: ?*c.Fl_Secret_Input,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) SecretInput {
        const ptr = c.Fl_Secret_Input_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return SecretInput{
            .inner = ptr,
        };
    }

    pub fn raw(self: *SecretInput) ?*c.Fl_Secret_Input {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Secret_Input) SecretInput {
        return SecretInput{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) SecretInput {
        return SecretInput{
            .inner = @ptrCast(?*c.Fl_Secret_Input, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) SecretInput {
        return SecretInput{
            .inner = @ptrCast(?*c.Fl_Secret_Input, ptr),
        };
    }

    pub fn toVoidPtr(self: *SecretInput) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asWidget(self: *const SecretInput) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asInput(self: *const SecretInput) Input {
        return Input{
            .inner = @ptrCast(?*c.Fl_Input, self.inner),
        };
    }

    pub fn handle(self: *SecretInput, cb: fn (w: widget.WidgetPtr,  ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Secret_Input_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *SecretInput, cb: fn (w: widget.WidgetPtr,  data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Secret_Input_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }
};

test "" {
    @import("std").testing.refAllDecls(@This());
}