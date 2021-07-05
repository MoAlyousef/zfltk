const c = @cImport({
    @cInclude("cfl_button.h");
});
const widget = @import("widget.zig");
const enums = @import("enums.zig");

pub const ButtonPtr = ?*c.Fl_Button;

pub const Button = struct {
    inner: ?*c.Fl_Button,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) Button {
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
            .inner = @ptrCast(?*c.Fl_Button, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) Button {
        return Button{
            .inner = @ptrCast(?*c.Fl_Button, ptr),
        };
    }

    pub fn toVoidPtr(self: *Button) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asWidget(self: *const Button) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn handle(self: *Button, cb: fn (w: widget.WidgetPtr,  ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Button_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *Button, cb: fn (w: widget.WidgetPtr,  data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Button_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }

    pub fn shortcut(self: *const Button) i32 {
        return c.Fl_Button_shortcut(self.inner);
    }

    pub fn setShortcut(self: *Button, shrtct: i32) void {
        c.Fl_Button_set_shortcut(self.inner, shrtct);
    }

    pub fn clear(self: *Button) void {
        c.Fl_Button_clear(self.inner);
    }

    pub fn value(self: *const Button) bool {
        return c.Fl_Button_value(self.inner) != 0;
    }

    pub fn setValue(self: *Button, flag: bool) void {
        c.Fl_Button_set_value(self.inner, @boolToInt(flag));
    }

    pub fn setDownBox(self: *Button, f: enums.BoxType) void {
        c.Fl_Button_set_down_box(self.inner, f);
    }

    pub fn downBox(self: *const Button) enums.BoxType {
        return c.Fl_Button_down_box(self.inner);
    }
};

pub const RadioButton = struct {
    inner: ?*c.Fl_Radio_Button,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) RadioButton {
        const ptr = c.Fl_Radio_Button_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return RadioButton{
            .inner = ptr,
        };
    }

    pub fn raw(self: *RadioButton) ?*c.Fl_RadioButton {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_RadioButton) RadioButton {
        return RadioButton{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) RadioButton {
        return RadioButton{
            .inner = @ptrCast(?*c.Fl_RadioButton, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) RadioButton {
        return RadioButton{
            .inner = @ptrCast(?*c.Fl_RadioButton, ptr),
        };
    }

    pub fn toVoidPtr(self: *RadioButton) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asWidget(self: *const RadioButton) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asButton(self: *const RadioButton) Button {
        return Button{
            .inner = @ptrCast(?*c.Fl_Button, self.inner),
        };
    }

    pub fn handle(self: *RadioButton, cb: fn (w: widget.WidgetPtr,  ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Radio_Button_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *RadioButton, cb: fn (w: widget.WidgetPtr,  data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Radio_Button_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }
};

pub const CheckButton = struct {
    inner: ?*c.Fl_Check_Button,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) CheckButton {
        const ptr = c.Fl_Check_Button_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return CheckButton{
            .inner = ptr,
        };
    }

    pub fn raw(self: *CheckButton) ?*c.Fl_CheckButton {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_CheckButton) CheckButton {
        return CheckButton{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) CheckButton {
        return CheckButton{
            .inner = @ptrCast(?*c.Fl_CheckButton, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) CheckButton {
        return CheckButton{
            .inner = @ptrCast(?*c.Fl_CheckButton, ptr),
        };
    }

    pub fn toVoidPtr(self: *CheckButton) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asWidget(self: *const CheckButton) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asButton(self: *const CheckButton) Button {
        return Button{
            .inner = @ptrCast(?*c.Fl_Button, self.inner),
        };
    }

    pub fn handle(self: *CheckButton, cb: fn (w: widget.WidgetPtr,  ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Check_Button_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *CheckButton, cb: fn (w: widget.WidgetPtr,  data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Check_Button_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }
};

pub const RoundButton = struct {
    inner: ?*c.Fl_Round_Button,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) RoundButton {
        const ptr = c.Fl_Round_Button_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return RoundButton{
            .inner = ptr,
        };
    }

    pub fn raw(self: *RoundButton) ?*c.Fl_RoundButton {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_RoundButton) RoundButton {
        return RoundButton{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) RoundButton {
        return RoundButton{
            .inner = @ptrCast(?*c.Fl_RoundButton, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) RoundButton {
        return RoundButton{
            .inner = @ptrCast(?*c.Fl_RoundButton, ptr),
        };
    }

    pub fn toVoidPtr(self: *RoundButton) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asWidget(self: *const RoundButton) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asButton(self: *const RoundButton) Button {
        return Button{
            .inner = @ptrCast(?*c.Fl_Button, self.inner),
        };
    }

    pub fn handle(self: *RoundButton, cb: fn (w: widget.WidgetPtr,  ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Round_Button_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *RoundButton, cb: fn (w: widget.WidgetPtr,  data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Round_Button_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }
};

test "" {
    @import("std").testing.refAllDecls(@This());
}