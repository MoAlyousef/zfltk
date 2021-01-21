const c = @cImport({
    @cInclude("cfl_widget.h");
});
const enums = @import("enums.zig");
const image = @import("image.zig");

pub const WidgetPtr = ?*c.Fl_Widget;

pub const Widget = struct {
    inner: ?*c.Fl_Widget,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) Widget {
        const ptr = c.Fl_Widget_new(x, y, w, h, title);
        if (ptr == null) unreachable;
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

    pub fn fromWidgetPtr(wid: WidgetPtr) Widget {
        return Widget{
            .inner = @ptrCast(*c.Fl_Widget, wid),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) Widget {
        return Widget{
            .inner = @ptrCast(*c.Fl_Widget, ptr),
        };
    }

    pub fn toVoidPtr(self: *Widget) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn delete(self: *Widget) void {
        c.Fl_Widget_delete(self.inner);
        self.inner = null;
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

    pub fn hide(self: *Widget) void {
        c.Fl_Widget_hide(self.inner);
    }

    pub fn setLabel(self: *Widget, str: [*c]const u8) void {
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

    pub fn label(self: *const Widget) [*c]const u8 {
        return c.Fl_Widget_label(self.inner);
    }

    pub fn setType(self: *Widget, typ: i32) void {
        c.Fl_Widget_set_type(self.inner, typ);
    }

    pub fn color(self: *const Widget) enums.Color {
        return @intToEnum(enums.Color, c.Fl_Widget_color(self.inner));
    }

    pub fn labelColor(self: *const Widget) enums.Color {
        return @intToEnum(enums.Color, c.Fl_Widget_label_color(self.inner));
    }

    pub fn setLabelColor(self: *Widget, col: enums.Color) void {
        c.Fl_Widget_set_label_color(self.inner, @enumToInt(col));
    }

    pub fn labelFont(self: *const Widget) enums.Font {
        return @intToEnum(c.Fl_Widget_label_font(self.inner));
    }

    pub fn setLabelFont(self: *Widget, font: enums.Font) void {
        c.Fl_Widget_set_label_font(self.inner, @enumToInt(font));
    }

    pub fn labelSize(self: *const Widget) i32 {
        c.Fl_Widget_label_size(self.inner);
    }

    pub fn setLabelSize(self: *Widget, sz: i32) void {
        c.Fl_Widget_set_label_size(self.inner, sz);
    }

    pub fn setAlign(self: *Widget, a: i32) void {
        c.Fl_Widget_set_align(self.inner, a);
    }

    pub fn setTrigger(self: *Widget, trigger: i32) void {
        c.Fl_Widget_set_trigger(self.inner, trigger);
    }

    pub fn setBox(self: *Widget, boxtype: enums.BoxType) void {
        c.Fl_Widget_set_box(self.inner, @enumToInt(boxtype));
    }

    pub fn setImage(self: *Widget, img: ?image.Image) void {
        if (img) |i| {
            c.Fl_Widget_set_image(self.inner, i.inner);
        } else {
            c.Fl_Widget_set_image(self.inner, null);
        }
    }

    pub fn setDeimage(self: *Widget, img: ?image.Image) void {
        if (img) |i| {
            c.Fl_Widget_set_deimage(self.inner, i.inner);
        } else {
            c.Fl_Widget_set_deimage(self.inner, null);
        }
    }
};
