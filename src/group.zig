const zfltk = @import("zfltk.zig");
const app = zfltk.app;
const Widget = zfltk.Widget;
const c = zfltk.c;
const std = @import("std");
const widget_methods = zfltk.widget_methods;

pub const GroupPtr = ?*c.Fl_Group;

pub const GroupKind = enum {
    normal,
    pack,
    tabs,
    scroll,
    flex,
};

pub const ScrollType = enum(c_int) {
    /// Never show bars
    none = 0,
    /// Show vertical bar
    horizontal = 1,
    /// Show vertical bar
    vertical = 2,
    /// Show both horizontal and vertical bars
    both = 3,
    /// Always show bars
    always_on = 4,
    /// Show horizontal bar always
    horizontal_always = 5,
    /// Show vertical bar always
    vertical_always = 6,
    /// Always show both horizontal and vertical bars
    both_always = 7,
};

pub fn Group(comptime kind: GroupKind) type {
    return struct {
        const Self = @This();

        // Expose methods from `inherited` structs
        pub usingnamespace zfltk.widget.methods(Self, RawPtr);
        pub usingnamespace methods(Self);

        const GroupRawPtr = *c.Fl_Group;

        pub const RawPtr = switch (kind) {
            .normal => *c.Fl_Group,
            .pack => *c.Fl_Pack,
            .tabs => *c.Fl_Tabs,
            .scroll => *c.Fl_Scroll,
            .flex => *c.Fl_Flex,
        };

        pub const Options = struct {
            x: u31 = 0,
            y: u31 = 0,
            w: u31 = 0,
            h: u31 = 0,

            spacing: u31 = 0,

            label: ?[:0]const u8 = null,
            orientation: Orientation = .vertical,

            pub const Orientation = enum {
                vertical,
                horizontal,
            };
        };

        pub inline fn init(opts: Options) !*Self {
            const initFn = switch (kind) {
                .normal => c.Fl_Group_new,
                .pack => c.Fl_Pack_new,
                .tabs => c.Fl_Tabs_new,
                .scroll => c.Fl_Scroll_new,
                .flex => c.Fl_Flex_new,
            };

            const label = if (opts.label != null) opts.label.?.ptr else null;

            if (initFn(opts.x, opts.y, opts.w, opts.h, label)) |ptr| {
                var self = Self.fromRaw(ptr);

                switch (kind) {
                    .pack, .flex => {
                        self.setSpacing(opts.spacing);

                        if (opts.orientation != .vertical) {
                            c.Fl_Widget_set_type(self.widget().raw(), 1);
                        }
                    },
                    else => {},
                }

                return self;
            }

            unreachable;
        }
    };
}

pub fn methods(comptime Self: type) type {
    return struct {
        pub inline fn group(self: *Self) *Group(.normal) {
            return @ptrCast(self);
        }

        pub inline fn current() Self {
            if (c.Fl_Group_current()) |grp| {
                return Self.fromRaw(grp);
            }

            unreachable;
        }

        pub fn handle(self: *Self, cb: fn (w: Widget.RawPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
            c.Fl_Group_handle(self.raw(), @ptrCast(cb), data);
        }

        pub fn draw(self: *Self, cb: fn (w: Widget.RawPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
            c.Fl_Group_handle(self.raw(), @ptrCast(cb), data);
        }

        pub fn begin(self: *Self) void {
            c.Fl_Group_begin(self.group().raw());
        }

        pub fn end(self: *Self) void {
            const endFn = switch (Self) {
                Group(.flex) => c.Fl_Flex_end,
                else => c.Fl_Group_end,
            };

            const ptr = switch (Self) {
                Group(.flex) => self.raw(),
                else => self.group().raw(),
            };

            endFn(ptr);
        }

        pub fn find(self: *Self, wid: *const Widget) u32 {
            return c.Fl_Group_find(self.group().raw(), wid.raw());
        }

        pub fn add(self: *Self, widgets: anytype) void {
            const T = @TypeOf(widgets);
            const type_info = @typeInfo(T);

            if (type_info != .Struct) {
                @compileError("expected tuple or struct argument, found " ++ @typeName(T));
            }

            inline for (std.meta.fields(T)) |w| {
                const wid = @as(w.type, @field(widgets, w.name));

                if (!comptime zfltk.isWidget(w.type)) {
                    @compileError("expected FLTK widget, found " ++ @typeName(w.type));
                }

                c.Fl_Group_add(self.group().raw(), wid.widget().raw());
            }
        }

        pub fn insert(self: *Self, wid: anytype, index: u32) void {
            const T = @TypeOf(wid);
            if (!comptime zfltk.isWidget(T)) {
                @compileError("expected FLTK widget, found " ++ @typeName(T));
            }

            return c.Fl_Group_insert(self.group().raw(), wid.raw(), index);
        }

        pub fn remove(self: *Self, wid: anytype) void {
            const T = @TypeOf(wid);
            if (!comptime zfltk.isWidget(T)) {
                @compileError("expected FLTK widget, found " ++ @typeName(T));
            }

            return c.Fl_Group_remove(self.group().raw(), wid.raw());
        }

        pub fn resizable(self: *Self, wid: anytype) void {
            const T = @TypeOf(wid);
            if (!comptime zfltk.isWidget(T)) {
                @compileError("expected FLTK widget, found " ++ @typeName(T));
            }

            return c.Fl_Group_resizable(self.group().raw(), wid.raw());
        }

        pub fn clear(self: *Self) void {
            c.Fl_Group_clear(self.group().raw());
        }

        pub fn children(self: *Self) u31 {
            c.Fl_Group_children(self.group().raw());
        }

        pub fn child(self: *Self, idx: u31) !Widget {
            if (c.Fl_Group_child(self.group().raw(), idx)) |ptr| {
                return Widget.fromRaw(ptr);
            }

            return null;
        }

        pub fn spacing(self: *Self) u31 {
            const spacingFn = switch (Self) {
                Group(.flex) => c.Fl_Flex_pad,
                Group(.pack) => c.Fl_Pack_spacing,

                else => @compileError("method `spacing` only usable with flex and pack groups"),
            };

            return @intCast(spacingFn(self.raw()));
        }

        pub fn setSpacing(self: *Self, sz: u31) void {
            const spacingFn = switch (Self) {
                Group(.flex) => c.Fl_Flex_set_pad,
                Group(.pack) => c.Fl_Pack_set_spacing,

                else => @compileError("method `setSpacing` only usable with flex and pack groups"),
            };

            spacingFn(self.raw(), sz);
        }

        pub inline fn fixed(self: *Self, wid: anytype, sz: i32) void {
            if (Self != Group(.flex)) {
                @compileError("method `fixed` only usable with flex groups");
            }

            const T = @TypeOf(wid);
            if (!comptime zfltk.isWidget(T)) {
                @compileError("expected FLTK widget, found " ++ @typeName(T));
            }

            c.Fl_Flex_set_size(self.raw(), wid.widget().raw(), sz);
        }

        pub fn setMargin(self: *Self, sz: u31) void {
            const marginFn = switch (Self) {
                Group(.flex) => c.Fl_Flex_set_margin,

                else => @compileError("method `setMargin` only usable with flex groups"),
            };

            marginFn(self.raw(), sz);
        }

        pub inline fn setScrollBar(self: *Self, scrollbar: ScrollType) void {
            if (Self != Group(.scroll)) {
                @compileError("method `setScrollBar` only usable with scroll groups");
            }

            self.widget().setKind(ScrollType, scrollbar);
        }
    };
}

test "all" {
    @import("std").testing.refAllDecls(@This());
}
