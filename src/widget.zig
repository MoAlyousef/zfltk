const c = @cImport({
    @cInclude("cfltk/cfl_widget.h");
    @cInclude("cfltk/cfl.h");
});
const enums = @import("enums.zig");
const group = @import("group.zig");
const image = @import("image.zig");

pub const WidgetPtr = ?*c.Fl_Widget;

fn shim(w: ?*c.Fl_Widget, data: ?*anyopaque) callconv(.C) void {
    _ = w;
    c.Fl_awake_msg(data);
}

pub const Widget = struct {
    inner: ?*c.Fl_Widget,
    pub fn new(coord_x: i32, coord_y: i32, width: i32, height: i32, title: [*c]const u8) Widget {
        const ptr = c.Fl_Widget_new(coord_x, coord_y, width, height, title);
        if (ptr == null) unreachable;
        return Widget{
            .inner = ptr,
        };
    }

    pub fn raw(self: *const Widget) ?*c.Fl_Widget {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Widget) Widget {
        return Widget{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(wid: WidgetPtr) Widget {
        return Widget{
            .inner = @ptrCast(?*c.Fl_Widget, wid),
        };
    }

    pub fn fromVoidPtr(ptr: ?*anyopaque) Widget {
        return Widget{
            .inner = @ptrCast(?*c.Fl_Widget, ptr),
        };
    }

    pub fn toVoidPtr(self: *const Widget) ?*anyopaque {
        return @ptrCast(?*anyopaque, self.inner);
    }

    pub fn delete(self: *const Widget) void {
        c.Fl_Widget_delete(self.inner);
        self.inner = null;
    }

    pub fn setCallback(self: *const Widget, comptime cb: fn (w: ?*c.Fl_Widget, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Widget_set_callback(self.inner, cb, data);
    }

    pub fn emit(self: *const Widget, comptime T: type, msg: T) void {
        self.setCallback(shim, @intToPtr(?*anyopaque, @enumToInt(msg)));
    }

    pub fn setColor(self: *const Widget, col: enums.Color) void {
        c.Fl_Widget_set_color(self.inner, col.inner());
    }

    pub fn show(self: *const Widget) void {
        c.Fl_Widget_show(self.inner);
    }

    pub fn hide(self: *const Widget) void {
        c.Fl_Widget_hide(self.inner);
    }

    pub fn setLabel(self: *const Widget, str: [*:0]const u8) void {
        c.Fl_Widget_set_label(self.inner, str);
    }

    pub fn resize(self: *const Widget, coord_x: i32, coord_y: i32, width: i32, height: i32) void {
        c.Fl_Widget_resize(self.inner, coord_x, coord_y, width, height);
    }

    pub fn redraw(self: *const Widget) void {
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

    pub fn getType(self: *const Widget, comptime T: type) T {
        return @intToEnum(c.Fl_Widget_set_type(self.inner), T);
    }

    pub fn setType(self: *const Widget, comptime T: type, t: T) void {
        c.Fl_Widget_set_type(self.inner, @enumToInt(t));
    }

    pub fn color(self: *const Widget) enums.Color {
        return enums.Color.from_rgbi(c.Fl_Widget_color(self.inner));
    }

    pub fn labelColor(self: *const Widget) enums.Color {
        return enums.Color.from_rgbi(c.Fl_Widget_label_color(self.inner));
    }

    pub fn setLabelColor(self: *const Widget, col: enums.Color) void {
        c.Fl_Widget_set_label_color(self.inner, col.inner());
    }

    pub fn labelFont(self: *const Widget) enums.Font {
        return @intToEnum(c.Fl_Widget_label_font(self.inner), enums.Font);
    }

    pub fn setLabelFont(self: *const Widget, font: enums.Font) void {
        c.Fl_Widget_set_label_font(self.inner, @enumToInt(font));
    }

    pub fn labelSize(self: *const Widget) i32 {
        c.Fl_Widget_label_size(self.inner);
    }

    pub fn setLabelSize(self: *const Widget, sz: i32) void {
        c.Fl_Widget_set_label_size(self.inner, sz);
    }

    pub fn setAlign(self: *const Widget, a: i32) void {
        c.Fl_Widget_set_align(self.inner, a);
    }

    pub fn setTrigger(self: *const Widget, callbackTrigger: i32) void {
        c.Fl_Widget_set_trigger(self.inner, callbackTrigger);
    }

    pub fn setBox(self: *const Widget, boxtype: enums.BoxType) void {
        c.Fl_Widget_set_box(self.inner, @enumToInt(boxtype));
    }

    pub fn setImage(self: *const Widget, img: ?image.Image) void {
        if (img) |i| {
            c.Fl_Widget_set_image(self.inner, i.inner);
        } else {
            c.Fl_Widget_set_image(self.inner, null);
        }
    }

    pub fn setDeimage(self: *const Widget, img: ?image.Image) void {
        if (img) |i| {
            c.Fl_Widget_set_deimage(self.inner, i.inner);
        } else {
            c.Fl_Widget_set_deimage(self.inner, null);
        }
    }

    pub fn trigger(self: *const Widget) i32 {
        return c.Fl_Widget_trigger(self.inner);
    }

    pub fn parent(self: *const Widget) group.Group {
        return group.Group{ .inner = c.Fl_Widget_parent(self.inner) };
    }

    pub fn selectionColor(self: *const Widget) enums.Color {
        return c.Fl_Widget_selection_color(self.inner);
    }

    pub fn setSelectionColor(self: *const Widget, col: enums.Color) void {
        c.Fl_Widget_set_selection_color(self.inner, col.inner());
    }

    pub fn doCallback(self: *const Widget) void {
        c.Fl_Widget_do_callback(self.inner);
    }

    pub fn clearVisiblFocus(self: *const Widget) void {
        c.Fl_Widget_clear_visible_focus(self.inner);
    }

    pub fn visibleFocus(self: *const Widget, v: bool) void {
        c.Fl_Widget_visible_focus(self.inner, v);
    }

    pub fn getAlign(self: *const Widget) i32 {
        return c.Fl_Widget_align(self.inner);
    }

    pub fn setLabelLype(self: *const Widget, typ: enums.LabelType) void {
        c.Fl_Widget_set_label_type(self.inner, @enumToInt(typ));
    }

    pub fn tooltip(self: *const Widget) [*c]const u8 {
        return c.Fl_Widget_tooltip(self.inner);
    }

    pub fn setTooltip(self: *const Widget, txt: [*c]const u8) void {
        c.Fl_Widget_set_tooltip(
            self.inner,
            txt,
        );
    }
};

test "all" {
    @import("std").testing.refAllDecls(@This());
}
