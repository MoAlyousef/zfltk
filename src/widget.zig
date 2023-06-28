const zfltk = @import("zfltk.zig");
const app = zfltk.app;
const std = @import("std");
const enums = zfltk.enums;
const Color = enums.Color;
const Group = zfltk.Group;
const Image = zfltk.Image;
const c = zfltk.c;

fn shim(_: *Widget, data: ?*anyopaque) void {
    c.Fl_awake_msg(data);
}

pub const Widget = struct {
    pub usingnamespace methods(Widget, *c.Fl_Widget);

    pub fn OptionsImpl(comptime ctx: type) type {
        _ = ctx;
        return struct {
            x: u31 = 0,
            y: u31 = 0,
            w: u31 = 0,
            h: u31 = 0,

            label: ?[:0]const u8 = null,
        };
    }

    pub const Options = OptionsImpl(Widget);

    pub inline fn init(opts: Options) !*Widget {
        const _label = if (opts.label != null) opts.label.?.ptr else null;

        if (c.Fl_Widget_new(opts.x, opts.y, opts.w, opts.h, _label)) |ptr| {
            return Widget.fromRaw(ptr);
        }

        unreachable;
    }

    pub inline fn deinit(self: *Widget) void {
        c.Fl_Widget_delete(self.raw());
    }
};

/// Methods to be used in everything derived from `Widget`
pub fn methods(comptime Self: type, comptime RawPtr: type) type {
    return struct {
        pub inline fn widget(self: *Self) *Widget {
            return  @ptrCast(self);
        }

        pub inline fn fromWidget(wid: *Widget) *Self {
            return  @ptrCast(wid);
        }

        pub inline fn raw(self: *Self) RawPtr {
            return @ptrCast(@alignCast(self));
        }

        pub inline fn fromRaw(ptr: *anyopaque) *Self {
            return  @ptrCast(ptr);
        }

        /// Sets a function to be called upon `activation` of a widget such as
        /// pushing a button
        pub inline fn setCallback(self: *Self, f: *const fn (*Self) void) void {
            c.Fl_Widget_set_callback(
                self.widget().raw(),
                &zfltk_cb_handler,
                 @ptrFromInt(@intFromPtr(f)),
            );
        }

        /// Like `setCallback` but allows passing data
        pub fn setCallbackEx(self: *Self, f: *const fn (*Self, data: ?*anyopaque) void, data: ?*anyopaque) void {
            // TODO: Make this an ArrayList or something more efficient
            var container = app.allocator.alloc(usize, 2) catch unreachable;

            container[0] = @intFromPtr(f);
            container[1] = @intFromPtr(data);

            c.Fl_Widget_set_callback(
                self.widget().raw(),
                zfltk_cb_handler_ex,
                @ptrCast(container.ptr),
            );
        }

        pub inline fn emit(self: *Self, comptime T: type, msg: T) void {
            self.widget().setCallbackEx(shim, @ptrFromInt(@intFromEnum(msg)));
        }

        pub inline fn show(self: *Self) void {
            // `Widget_show` cannot be called on native dialogs
            if (Self == zfltk.FileDialog(.file)) {
                _ = c.Fl_Native_File_Chooser_show(self.raw());
                return;
            }

            c.Fl_Widget_show(self.widget().raw());
        }

        pub inline fn hide(self: *Self) void {
            c.Fl_Widget_hide(self.widget().raw());
        }

        pub inline fn resize(self: *Self, _x: i32, _y: i32, _w: u31, _h: u31) void {
            c.Fl_Widget_resize(self.widget().raw(), _x, _y, _w, _h);
        }

        pub inline fn redraw(self: *Self) void {
            c.Fl_Widget_redraw(self.widget().raw());
        }

        pub inline fn x(self: *Self) i32 {
            return  @intCast(c.Fl_Widget_x(self.widget().raw()));
        }

        pub inline fn y(self: *Self) i32 {
            return  @intCast(c.Fl_Widget_y(self.widget().raw()));
        }

        pub inline fn w(self: *Self) u31 {
            return @intCast(c.Fl_Widget_width(self.widget().raw()));
        }

        pub inline fn h(self: *Self) u31 {
            return @intCast(c.Fl_Widget_height(self.widget().raw()));
        }

        pub inline fn label(self: *const Self) [:0]const u8 {
            return std.mem.span(c.Fl_Widget_label(self.widget().raw()));
        }

        pub inline fn setLabel(self: *Self, _label: [:0]const u8) void {
            c.Fl_Widget_set_label(self.widget().raw(), _label.ptr);
        }

        pub inline fn kind(self: *const Self, comptime T: type) T {
            return @enumFromInt(c.Fl_Widget_set_type(self.widget().raw()));
        }

        pub inline fn setKind(self: *Self, comptime T: type, t: T) void {
            c.Fl_Widget_set_type(self.widget().raw(), @intFromEnum(t));
        }

        pub inline fn color(self: *Self) Color {
            return Color.fromRgbi(c.Fl_Widget_color(self.widget().raw()));
        }

        pub inline fn setColor(self: *Self, col: Color) void {
            c.Fl_Widget_set_color(self.widget().raw(), col.toRgbi());
        }

        pub inline fn labelColor(self: *Self) Color {
            return Color.fromRgbi(c.Fl_Widget_label_color(self.widget().raw()));
        }

        pub inline fn setLabelColor(self: *Self, col: Color) void {
            c.Fl_Widget_set_label_color(self.widget().raw(), col.toRgbi());
        }

        pub inline fn labelFont(self: *const Self) enums.Font {
            return @enumFromInt(c.Fl_Widget_label_font(self.widget().raw()));
        }

        pub inline fn setLabelFont(self: *Self, font: enums.Font) void {
            c.Fl_Widget_set_label_font(self.widget().raw(), @intFromEnum(font));
        }

        pub inline fn labelSize(self: *const Self) u31 {
            return @intCast(c.Fl_Widget_label_size(self.widget().raw()));
        }

        pub inline fn setLabelSize(self: *Self, size: u31) void {
            c.Fl_Widget_set_label_size(self.widget().raw(), size);
        }

        // TODO: make alignment and trigger enums
        pub inline fn labelAlign(self: *const Self) i32 {
            return  @intCast(c.Fl_Widget_align(self.widget().raw()));
        }

        pub inline fn setLabelAlign(self: *Self, alignment: i32) void {
            c.Fl_Widget_set_align(self.widget().raw(),  @intCast(alignment));
        }

        pub inline fn trigger(self: *const Self) i32 {
            return c.Fl_Widget_trigger(self.widget().raw());
        }

        pub inline fn setTrigger(self: *const Self, cb_trigger: i32) void {
            c.Fl_Widget_set_trigger(self.widget().raw(),  @intCast(cb_trigger));
        }

        pub inline fn box(self: *const Self) enums.BoxType {
            return  @enumFromInt(c.Fl_Widget_box(self.widget().raw()));
        }

        pub inline fn setBox(self: *Self, boxtype: enums.BoxType) void {
            c.Fl_Widget_set_box(self.widget().raw(), @intFromEnum(boxtype));
        }

        pub inline fn setImage(self: *Self, img: Image) void {
            c.Fl_Widget_set_image(self.widget().raw(), img.inner);
        }

        pub inline fn removeImage(self: *Self) void {
            c.Fl_Widget_set_image(self.widget().raw(), null);
        }

        pub inline fn setDeimage(self: *Self, img: Image) void {
            c.Fl_Widget_set_deimage(self.widget().raw(), img.inner);
        }

        pub inline fn removeDeimage(self: *Self) void {
            c.Fl_Widget_set_deimage(self.widget().raw(), null);
        }

        // TODO: fix, this causes pointer issues
        pub inline fn parent(self: *Self) *Group(.normal) {
            return Group(.normal).fromRaw(c.Fl_Widget_parent(self.widget().raw()).?);
        }

        pub inline fn selectionColor(self: *const Self) enums.Color {
            return c.Fl_Widget_selection_color(self.widget().raw());
        }

        pub inline fn setSelectionColor(self: *Self, col: enums.Color) void {
            c.Fl_Widget_set_selection_color(self.widget().raw(), col.toRgbi());
        }

        pub inline fn doCallback(self: *const Self) void {
            c.Fl_Widget_do_callback(self.widget().raw());
        }

        pub inline fn clearVisibleFocus(self: *Self) void {
            c.Fl_Widget_clear_visible_focus(self.widget().raw());
        }

        pub inline fn setVisibleFocus(self: *Self, v: bool) void {
            c.Fl_Widget_visible_focus(self.widget().raw(), @intFromBool(v));
        }

        pub inline fn setLabelKind(self: *Self, typ: enums.LabelType) void {
            c.Fl_Widget_set_label_type(self.widget().raw(), @intFromEnum(typ));
        }

        pub inline fn tooltip(self: *const Self) [:0]const u8 {
            return std.mem.span(c.Fl_Widget_tooltip(self.widget().raw()));
        }

        pub inline fn setTooltip(self: *Self, _label: [:0]const u8) void {
            c.Fl_Widget_set_tooltip(self.widget().raw(), _label.ptr);
        }

        pub inline fn takeFocus(self: *const Self) void {
            c.Fl_set_focus(self.widget().raw());
        }
    };
}

// Small wrapper utilizing FLTK's `data` argument to use non-callconv(.C)
// functions as callbacks safely
export fn zfltk_cb_handler(wid: ?*c.Fl_Widget, data: ?*anyopaque) callconv(.C) void {
    // Fetch function pointer from the data. This is added to the data
    // pointer on `setCallback`.
    const cb: *const fn (*Widget) void = @ptrCast(data);

    if (wid) |ptr| {
        cb(Widget.fromRaw(ptr));
    } else {
        unreachable;
    }
}

export fn zfltk_cb_handler_ex(wid: ?*c.Fl_Widget, data: ?*anyopaque) callconv(.C) void {
    const container: *[2]usize = @ptrCast(@alignCast(data));
    const cb: *const fn (*Widget, ?*anyopaque) void = @ptrFromInt(container[0]);

    if (wid) |ptr| {
        cb(Widget.fromRaw(ptr), @ptrFromInt(container[1]));
    } else {
        unreachable;
    }
}

test "all" {
    @import("std").testing.refAllDecls(@This());
}
