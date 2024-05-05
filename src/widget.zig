const zfltk = @import("zfltk.zig");
const app = zfltk.app;
const std = @import("std");
const enums = zfltk.enums;
const Group = zfltk.group.Group;
const Image = zfltk.image.Image;
const c = zfltk.c;

pub const Widget = struct {
    pub usingnamespace methods(Widget, *c.Fl_Widget);

    pub fn OptionsImpl(comptime ctx: type) type {
        _ = ctx;
        return struct {
            x: i32 = 0,
            y: i32 = 0,
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
        const type_name = @typeName(RawPtr);
        const ptr_name = type_name[(std.mem.indexOf(u8, type_name, "struct_Fl_") orelse 0) + 7 .. type_name.len];

        pub inline fn widget(self: *Self) *Widget {
            return @ptrCast(self);
        }

        pub inline fn fromWidget(wid: *Widget) *Self {
            return @ptrCast(wid);
        }

        pub inline fn raw(self: *Self) RawPtr {
            return @ptrCast(@alignCast(self));
        }

        pub inline fn fromRaw(ptr: *anyopaque) *Self {
            return @ptrCast(ptr);
        }

        pub inline fn fromDynWidget(other: anytype) ?*Self {
            if (@field(c, ptr_name ++ "_from_dyn_ptr")(@ptrCast(@alignCast(other)))) |o| {
                return Self.fromRaw(o);
            }

            return null;
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
            if (data) |d| {
                // TODO: Make this an ArrayList or something more efficient
                var container = app.allocator.alloc(usize, 2) catch unreachable;

                container[0] = @intFromPtr(f);
                container[1] = @intFromPtr(d);

                c.Fl_Widget_set_callback(
                    self.widget().raw(),
                    zfltk_cb_handler_ex,
                    @ptrCast(container.ptr),
                );
            } else {
                c.Fl_Widget_set_callback(
                    self.widget().raw(),
                    zfltk_cb_handler,
                    @ptrFromInt(@intFromPtr(f)),
                );
            }
        }

        pub inline fn emit(self: *Self, comptime T: type, msg: T) void {
            c.Fl_Widget_set_callback(self.widget().raw(), shim, @ptrFromInt(@intFromEnum(msg)));
        }

        pub inline fn show(self: *Self) void {
            @field(c, ptr_name ++ "_show")(self.raw());
        }

        pub inline fn hide(self: *Self) void {
            @field(c, ptr_name ++ "_hide")(self.raw());
        }

        pub inline fn resize(self: *Self, _x: i32, _y: i32, _w: u31, _h: u31) void {
            @field(c, ptr_name ++ "_resize")(self.raw(), _x, _y, _w, _h);
        }

        pub inline fn redraw(self: *Self) void {
            c.Fl_Widget_redraw(self.widget().raw());
        }

        pub inline fn x(self: *Self) i32 {
            return @intCast(c.Fl_Widget_x(self.widget().raw()));
        }

        pub inline fn y(self: *Self) i32 {
            return @intCast(c.Fl_Widget_y(self.widget().raw()));
        }

        pub inline fn w(self: *Self) u31 {
            return @intCast(c.Fl_Widget_width(self.widget().raw()));
        }

        pub inline fn h(self: *Self) u31 {
            return @intCast(c.Fl_Widget_height(self.widget().raw()));
        }

        pub inline fn label(self: *Self) [:0]const u8 {
            return std.mem.span(c.Fl_Widget_label(self.widget().raw()));
        }

        pub inline fn setLabel(self: *Self, _label: [:0]const u8) void {
            @field(c, ptr_name ++ "_set_label")(self.raw(), _label.ptr);
        }

        pub inline fn kind(self: *Self, comptime T: type) T {
            return @enumFromInt(c.Fl_Widget_set_type(self.widget().raw()));
        }

        pub inline fn setKind(self: *Self, comptime T: type, t: T) void {
            c.Fl_Widget_set_type(self.widget().raw(), @intFromEnum(t));
        }

        pub inline fn color(self: *Self) enums.Color {
            return enums.Color.fromRgbi(c.Fl_Widget_color(self.widget().raw()));
        }

        pub inline fn setColor(self: *Self, col: enums.Color) void {
            c.Fl_Widget_set_color(self.widget().raw(), col.toRgbi());
        }

        pub inline fn labelColor(self: *Self) enums.Color {
            return enums.Color.fromRgbi(c.Fl_Widget_label_color(self.widget().raw()));
        }

        pub inline fn setLabelColor(self: *Self, col: enums.Color) void {
            c.Fl_Widget_set_label_color(self.widget().raw(), col.toRgbi());
        }

        pub inline fn labelFont(self: *Self) enums.Font {
            return @enumFromInt(c.Fl_Widget_label_font(self.widget().raw()));
        }

        pub inline fn setLabelFont(self: *Self, font: enums.Font) void {
            c.Fl_Widget_set_label_font(self.widget().raw(), @intFromEnum(font));
        }

        pub inline fn labelSize(self: *Self) u31 {
            return @intCast(c.Fl_Widget_label_size(self.widget().raw()));
        }

        pub inline fn setLabelSize(self: *Self, size: u31) void {
            c.Fl_Widget_set_label_size(self.widget().raw(), size);
        }

        // TODO: make alignment and trigger enums
        pub inline fn labelAlign(self: *Self) i32 {
            return @intCast(c.Fl_Widget_align(self.widget().raw()));
        }

        pub inline fn setLabelAlign(self: *Self, alignment: i32) void {
            c.Fl_Widget_set_align(self.widget().raw(), @intCast(alignment));
        }

        pub inline fn trigger(self: *Self) i32 {
            return c.Fl_Widget_trigger(self.widget().raw());
        }

        pub inline fn setTrigger(self: *Self, cb_trigger: i32) void {
            c.Fl_Widget_set_trigger(self.widget().raw(), @intCast(cb_trigger));
        }

        pub inline fn box(self: *Self) enums.BoxType {
            return @enumFromInt(c.Fl_Widget_box(self.widget().raw()));
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
        pub inline fn parent(self: *Self) ?*Group {
            const ptr = c.Fl_Widget_parent(self.widget().raw());
            if (ptr) |p| {
                return Group.fromRaw(p);
            } else {
                return null;
            }
        }

        pub inline fn selectionColor(self: *Self) enums.Color {
            return enums.Color.fromRgbi(c.Fl_Widget_selection_color(self.widget().raw()));
        }

        pub inline fn setSelectionColor(self: *Self, col: enums.Color) void {
            c.Fl_Widget_set_selection_color(self.widget().raw(), @intCast(col.toRgbi()));
        }

        pub inline fn doCallback(self: *Self) void {
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

        pub inline fn tooltip(self: *Self) [:0]const u8 {
            return std.mem.span(c.Fl_Widget_tooltip(self.widget().raw()));
        }

        pub inline fn setTooltip(self: *Self, _label: [:0]const u8) void {
            c.Fl_Widget_set_tooltip(self.widget().raw(), _label.ptr);
        }

        pub inline fn takeFocus(self: *Self) void {
            c.Fl_set_focus(self.widget().raw());
        }

        pub inline fn setEventHandler(self: *Self, f: *const fn (*Self, enums.Event) bool) void {
            @field(c, ptr_name ++ "_handle")(
                self.raw(),
                zfltk_event_handler,
                @ptrFromInt(@intFromPtr(f)),
            );
        }

        pub inline fn setEventHandlerEx(self: *Self, f: *const fn (*Self, enums.Event, ?*anyopaque) bool, data: ?*anyopaque) void {
            if (data) |d| {
                var container = app.allocator.alloc(usize, 2) catch unreachable;

                container[0] = @intFromPtr(f);
                container[1] = @intFromPtr(d);

                @field(c, ptr_name ++ "_handle")(
                    self.raw(),
                    zfltk_event_handler_ex,
                    @ptrCast(container.ptr),
                );
            } else {
                @field(c, ptr_name ++ "_handle")(
                    self.raw(),
                    zfltk_event_handler,
                    @ptrFromInt(@intFromPtr(f)),
                );
            }
        }

        pub inline fn setDrawHandler(self: *Self, f: *const fn (*Self) void) void {
            @field(c, ptr_name ++ "_draw")(
                self.raw(),
                zfltk_draw_handler,
                @ptrFromInt(@intFromPtr(f)),
            );
        }

        pub inline fn setDrawHandlerEx(self: *Self, f: *const fn (*Self, ?*anyopaque) void, data: ?*anyopaque) void {
            if (data) |d| {
                var allocator = std.heap.c_allocator;
                var container = allocator.alloc(usize, 2) catch unreachable;

                container[0] = @intFromPtr(f);
                container[1] = @intFromPtr(d);

                @field(c, ptr_name ++ "_draw")(
                    self.raw(),
                    zfltk_draw_handler_ex,
                    @ptrCast(container.ptr),
                );
            } else {
                @field(c, ptr_name ++ "_draw")(
                    self.raw(),
                    zfltk_draw_handler,
                    @ptrFromInt(@intFromPtr(f)),
                );
            }
        }

        pub inline fn call(self: *Self, comptime method: []const u8, args: anytype) @TypeOf(@call(.auto, @field(c, ptr_name ++ "_" ++ method), .{self.raw()} ++ args)) {
            return @call(.auto, @field(c, ptr_name ++ "_" ++ method), .{self.raw()} ++ args);
        }

        pub fn asWindow(self: *Self) ?*zfltk.window.Window {
            const ptr = @field(c, ptr_name ++ "_as_window")(self.raw());
            if (ptr) |p| {
                return zfltk.window.Window.fromRaw(p);
            } else {
                return null;
            }
        }

        pub fn centerOf(self: *Self, wid: anytype) void {
            if (!comptime zfltk.isWidget(@TypeOf(wid))) {
                return;
            }
            std.debug.assert(wid.w() != 0 and wid.h() != 0);
            const sw: f64 = @floatFromInt(self.w());
            const sh: f64 = @floatFromInt(self.h());
            const ww: f64 = @floatFromInt(wid.w());
            const wh: f64 = @floatFromInt(wid.h());
            const sx = (ww - sw) / 2.0;
            const sy = (wh - sh) / 2.0;
            var wx: i32 = 0;
            var wy: i32 = 0;
            if (wid.asWindow()) |win| {
                _ = win;
                wx = 0;
                wy = 0;
            } else {
                wx = wid.x();
                wy = wid.y();
            }
            self.resize(@as(i32, @intFromFloat(sx)) + wx, @as(i32, @intFromFloat(sy)) + wy, @as(u31, @intFromFloat(sw)), @as(u31, @intFromFloat(sh)));
            self.redraw();
        }

        pub fn centerOfParent(self: *Self) void {
            const par = self.parent();
            if (par) |p| {
                self.centerOf(p);
            }
        }

        pub fn centerY(self: *Self, wid: anytype) void {
            if (!comptime zfltk.isWidget(@TypeOf(wid))) {
                return;
            }
            std.debug.assert(wid.w() != 0 and wid.h() != 0);
            const sw: f64 = @floatFromInt(self.w());
            const sh: f64 = @floatFromInt(self.h());
            const wh: f64 = @floatFromInt(wid.h());
            const sx = self.x();
            const sy = (wh - sh) / 2.0;
            var wx: i32 = 0;
            var wy: i32 = 0;
            if (wid.asWindow()) |win| {
                _ = win;
                wx = 0;
                wy = 0;
            } else {
                wx = wid.x();
                wy = wid.y();
            }
            self.resize(@as(i32, @intFromFloat(sx)) + wx, sy, @as(u31, @intFromFloat(sw)), @as(u31, @intFromFloat(sh)));
            self.redraw();
        }

        pub fn centerX(self: *Self, wid: anytype) void {
            if (!comptime zfltk.isWidget(@TypeOf(wid))) {
                return;
            }
            std.debug.assert(wid.w() != 0 and wid.h() != 0);
            const sw: f64 = @floatFromInt(self.w());
            const sh: f64 = @floatFromInt(self.h());
            const ww: f64 = @floatFromInt(wid.w());
            const sx = (ww - sw) / 2.0;
            const sy = self.y();
            var wx: i32 = 0;
            var wy: i32 = 0;
            if (wid.asWindow()) |win| {
                _ = win;
                wx = 0;
                wy = 0;
            } else {
                wx = wid.x();
                wy = wid.y();
            }
            self.resize(sx, @as(i32, @intFromFloat(sy)) + wy, @as(u31, @intFromFloat(sw)), @as(u31, @intFromFloat(sh)));
            self.redraw();
        }

        pub fn sizeOf(self: *Self, wid: anytype) void {
            if (!comptime zfltk.isWidget(@TypeOf(wid))) {
                return;
            }
            std.debug.assert(wid.w() != 0 and wid.h() != 0);
            self.resize(self.x(), self.y(), wid.w(), wid.h());
        }

        pub fn sizeOfParent(self: *Self) void {
            const par = self.parent();
            if (par) |p| self.sizeOf(p);
        }

        pub fn belowOf(
            self: *Self,
            wid: anytype,
            padding: i32,
        ) void {
            if (!comptime zfltk.isWidget(@TypeOf(wid))) {
                return;
            }
            std.debug.assert(
                self.w() != 0 and self.h() != 0,
            );
            self.resize(wid.x(), wid.y() + wid.h() + padding, self.w(), self.h());
        }

        pub fn aboveOf(
            self: *Self,
            wid: anytype,
            padding: i32,
        ) void {
            if (!comptime zfltk.isWidget(@TypeOf(wid))) {
                return;
            }
            std.debug.assert(
                self.w() != 0 and self.h() != 0,
            );
            self.resize(wid.x(), wid.y() - wid.h() - padding, self.w(), self.h());
        }

        pub fn rightOf(
            self: *Self,
            wid: anytype,
            padding: i32,
        ) void {
            if (!comptime zfltk.isWidget(@TypeOf(wid))) {
                return;
            }
            std.debug.assert(
                self.w() != 0 and self.h() != 0,
            );
            self.resize(wid.x() + wid.w() + padding, wid.y(), self.w(), self.h());
        }

        pub fn leftOf(
            self: *Self,
            wid: anytype,
            padding: i32,
        ) void {
            if (!comptime zfltk.isWidget(@TypeOf(wid))) {
                return;
            }
            std.debug.assert(
                self.w() != 0 and self.h() != 0,
            );
            self.resize(wid.x() - self.w() - padding, wid.y(), self.w(), self.h());
        }
    };
}

pub fn shim(_: ?*c.Fl_Widget, data: ?*anyopaque) callconv(.C) void {
    c.Fl_awake_msg(data);
}

// Small wrapper utilizing FLTK's `data` argument to use non-callconv(.C)
// functions as callbacks safely
pub fn zfltk_cb_handler(wid: ?*c.Fl_Widget, data: ?*anyopaque) callconv(.C) void {
    // Fetch function pointer from the data. This is added to the data
    // pointer on `setCallback`.
    const cb: *const fn (*Widget) void = @ptrCast(data);

    if (wid) |ptr| {
        cb(Widget.fromRaw(ptr));
    } else {
        unreachable;
    }
}

pub fn zfltk_cb_handler_ex(wid: ?*c.Fl_Widget, data: ?*anyopaque) callconv(.C) void {
    const container: *[2]usize = @ptrCast(@alignCast(data));
    const cb: *const fn (*Widget, ?*anyopaque) void = @ptrFromInt(container[0]);

    if (wid) |ptr| {
        cb(Widget.fromRaw(ptr), @ptrFromInt(container[1]));
    } else {
        unreachable;
    }
}

pub fn zfltk_event_handler(wid: ?*c.Fl_Widget, event: c_int, data: ?*anyopaque) callconv(.C) c_int {
    const cb: *const fn (*Widget, enums.Event, ?*anyopaque) bool = @ptrCast(
        data,
    );

    return @intFromBool(cb(
        Widget.fromRaw(wid.?),
        @enumFromInt(event),
        null,
    ));
}

pub fn zfltk_event_handler_ex(wid: ?*c.Fl_Widget, ev: c_int, data: ?*anyopaque) callconv(.C) c_int {
    const container: *[2]usize = @ptrCast(@alignCast(data));

    const cb: *const fn (*Widget, enums.Event, ?*anyopaque) bool = @ptrFromInt(
        container[0],
    );

    return @intFromBool(cb(
        Widget.fromRaw(wid.?),
        @enumFromInt(ev),
        @ptrFromInt(container[1]),
    ));
}

pub fn zfltk_draw_handler(wid: ?*c.Fl_Widget, data: ?*anyopaque) callconv(.C) void {
    const cb: *const fn (*Widget, ?*anyopaque) void = @ptrCast(
        data,
    );

    cb(
        Widget.fromRaw(wid.?),
        null,
    );
}

pub fn zfltk_draw_handler_ex(wid: ?*c.Fl_Widget, data: ?*anyopaque) callconv(.C) void {
    const container: *[2]usize = @ptrCast(@alignCast(data));

    const cb: *const fn (*Widget, ?*anyopaque) void = @ptrFromInt(
        container[0],
    );

    cb(
        Widget.fromRaw(wid.?),
        @ptrFromInt(container[1]),
    );
}

test "all" {
    @import("std").testing.refAllDeclsRecursive(@This());
}
