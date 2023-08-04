const zfltk = @import("zfltk.zig");
const app = zfltk.app;
const Widget = zfltk.Widget;
const widget = zfltk.widget;
const c = zfltk.c;
const std = @import("std");
const widget_methods = zfltk.widget_methods;
const enums = zfltk.enums;

pub const GroupPtr = ?*c.Fl_Group;

pub const Group = GroupType(.normal);
pub const Pack = GroupType(.pack);
pub const Tabs = GroupType(.tabs);
pub const Scroll = GroupType(.scroll);
pub const Flex = GroupType(.flex);
pub const Tile = GroupType(.tile);

const GroupKind = enum {
    normal,
    pack,
    tabs,
    scroll,
    flex,
    tile,
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

fn GroupType(comptime kind: GroupKind) type {
    return struct {
        const Self = @This();

        // Expose methods from `inherited` structs
        pub usingnamespace zfltk.widget.methods(Self, RawPtr);
        pub usingnamespace methods(Self, RawPtr);

        const GroupRawPtr = *c.Fl_Group;

        pub const RawPtr = switch (kind) {
            .normal => *c.Fl_Group,
            .pack => *c.Fl_Pack,
            .tabs => *c.Fl_Tabs,
            .scroll => *c.Fl_Scroll,
            .flex => *c.Fl_Flex,
            .tile => *c.Fl_Tile,
        };
        const type_name = @typeName(RawPtr);
        const ptr_name = type_name[(std.mem.indexOf(u8, type_name, "struct_Fl_") orelse 0) + 7 .. type_name.len];

        pub const Options = struct {
            x: i32 = 0,
            y: i32 = 0,
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
            const initFn = @field(c, ptr_name ++ "_new");

            const label = if (opts.label != null) opts.label.?.ptr else null;

            if (initFn(opts.x, opts.y, opts.w, opts.h, label)) |ptr| {
                var self = Self.fromRaw(ptr);

                switch (kind) {
                    .pack, .flex => {
                        self.setSpacing(opts.spacing);

                        if (opts.orientation == .horizontal) {
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

pub fn methods(comptime Self: type, comptime RawPtr: type) type {
    const type_name = @typeName(RawPtr);
    const ptr_name = type_name[(std.mem.indexOf(u8, type_name, "struct_Fl_") orelse 0) + 7 .. type_name.len];
    return struct {
        pub inline fn group(self: *Self) *GroupType(.normal) {
            return @ptrCast(self);
        }

        pub inline fn current() Self {
            if (c.Fl_Group_current()) |grp| {
                return Self.fromRaw(grp);
            }

            unreachable;
        }

        pub fn begin(self: *Self) void {
            @field(c, ptr_name ++ "_begin")(self.raw());
        }

        pub fn end(self: *Self) void {
            @field(c, ptr_name ++ "_end")(self.raw());
        }

        pub fn find(self: *Self, wid: *Widget) u32 {
            return @intCast(@field(c, ptr_name ++ "_find")(self.raw(), wid.raw()));
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

                @field(c, ptr_name ++ "_add")(self.raw(), wid.widget().raw());
            }
        }

        pub fn insert(self: *Self, wid: anytype, index: u32) void {
            const T = @TypeOf(wid);
            if (!comptime zfltk.isWidget(T)) {
                @compileError("expected FLTK widget, found " ++ @typeName(T));
            }

            return @field(c, ptr_name ++ "_insert")(self.raw(), wid.raw(), index);
        }

        pub fn remove(self: *Self, wid: anytype) void {
            const T = @TypeOf(wid);
            if (!comptime zfltk.isWidget(T)) {
                @compileError("expected FLTK widget, found " ++ @typeName(T));
            }

            return @field(c, ptr_name ++ "_remove")(self.raw(), wid.raw());
        }

        pub fn resizable(self: *Self, wid: anytype) void {
            const T = @TypeOf(wid);
            if (!comptime zfltk.isWidget(T)) {
                @compileError("expected FLTK widget, found " ++ @typeName(T));
            }

            return @field(c, ptr_name ++ "_resizable")(self.raw(), wid.widget().raw());
        }

        pub fn clear(self: *Self) void {
            @field(c, ptr_name ++ "_clear")(self.raw());
        }

        pub fn children(self: *Self) u31 {
            return @intCast(@field(c, ptr_name ++ "_children")(self.raw()));
        }

        pub fn child(self: *Self, idx: u31) ?*Widget {
            if (@field(c, ptr_name ++ "_child")(self.raw(), idx)) |ptr| {
                return Widget.fromRaw(ptr);
            }

            return null;
        }

        pub fn spacing(self: *Self) u31 {
            const spacingFn = switch (Self) {
                GroupType(.flex) => c.Fl_Flex_pad,
                GroupType(.pack) => c.Fl_Pack_spacing,

                else => @compileError("method `spacing` only usable with flex and pack groups"),
            };

            return @intCast(spacingFn(self.raw()));
        }

        pub fn setSpacing(self: *Self, sz: u31) void {
            const spacingFn = switch (Self) {
                GroupType(.flex) => c.Fl_Flex_set_pad,
                GroupType(.pack) => c.Fl_Pack_set_spacing,

                else => @compileError("method `setSpacing` only usable with flex and pack groups"),
            };

            spacingFn(self.raw(), sz);
        }

        pub inline fn fixed(self: *Self, wid: anytype, sz: i32) void {
            if (Self != GroupType(.flex)) {
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
                GroupType(.flex) => c.Fl_Flex_set_margin,

                else => @compileError("method `setMargin` only usable with flex groups"),
            };

            marginFn(self.raw(), @intCast(sz));
        }

        pub fn setMargins(self: *Self, left: u31, top: u31, right: u31, bottom: u31) void {
            const marginsFn = switch (Self) {
                GroupType(.flex) => c.Fl_Flex_set_margins,

                else => @compileError("method `setMargin` only usable with flex groups"),
            };

            marginsFn(self.raw(), @intCast(left), @intCast(top), @intCast(right), @intCast(bottom));
        }

        pub inline fn setScrollbar(self: *Self, scrollbar: ScrollType) void {
            if (Self != GroupType(.scroll)) {
                @compileError("method `setScrollbar` only usable with scroll groups");
            }

            self.setKind(ScrollType, scrollbar);
        }

        pub inline fn setScrollbarSize(self: *Self, size: u31) void {
            if (Self != GroupType(.scroll)) {
                @compileError("method `setScrollbarSize` only usable with scroll groups");
            }

            c.Fl_Scroll_set_scrollbar_size(self.raw(), size);
        }
    };
}

test "all" {
    @import("std").testing.refAllDeclsRecursive(@This());
}
