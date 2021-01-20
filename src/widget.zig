const c = @cImport({
    @cInclude("cfl_widget.h");
});
const enums = @import("enums.zig");

pub const WidgetPtr = ?*c.Fl_Widget;

pub const Widget = struct {
    inner: ?*c.Fl_Widget,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [:0]const u8) Widget {
        const ptr = c.Fl_Widget_new(x, y, w, h, title);
        if (ptr == null) {
            unreachable;
        }
        return Widget{
            .inner = ptr,
        };
    }
    pub fn raw(self: *Widget) ?*c.Fl_Widget {
        return self.inner;
    }
    pub fn fromRaw(ptr: ?*c.Fl_Widget) Widget {
        return Widget{
            .inner = ptr,
        };
    }
    pub fn fromWidgetPtr(w: WidgetPtr) Widget {
        return Widget{
            .inner = @ptrCast(*c.Fl_Widget, w),
        };
    }
    pub fn fromVoidPtr(ptr: ?*c_void) Widget {
        return Widget{
            .inner = @ptrCast(*c.Fl_Widget, ptr),
        };
    }
    pub fn setCallback(self: *Widget, cb: fn (w: ?*c.Fl_Widget, data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Widget_set_callback(self.inner, cb, data);
    }
    pub fn setColor(self: *Widget, col: enums.Color) void {
        c.Fl_Widget_set_color(self.inner, @enumToInt(col));
    }
    pub fn show(self: *Widget) void {
        c.Fl_Widget_show(self.inner);
    }
    pub fn setLabel(self: *Widget, str: [:0]const u8) void {
        c.Fl_Widget_set_label(self.inner, str);
    }
    pub fn resize(self: *Widget, x: i32, y: i32, w: i32, h: i32) void {
        c.Fl_Widget_resize(self.inner, x, y, w, h);
    }
    pub fn redraw(self: *Widget) void {
        c.Fl_Widget_redraw(self.inner);
    }
    pub fn x(self: *const Widget) i32 {
        return c.Fl_Widget_x(self.inner);
    }
    pub fn y(self: *const Widget) i32 {
        return c.Fl_Widget_y(self.inner);
    }
    pub fn w(self: *const Widget) i32 {
        return c.Fl_Widget_w(self.inner);
    }
    pub fn h(self: *const Widget) i32 {
        return c.Fl_Widget_h(self.inner);
    }
    pub fn label(self: *const Widget) [:0]const u8 {
        return c.Fl_Widget_label(self.inner);
    }
    pub fn color(self: *const Widget) enums.Color {
        return @intToEnum(enums.Color, c.Fl_Widget_color(self.inner));
    }
};
