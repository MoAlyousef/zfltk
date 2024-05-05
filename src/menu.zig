const zfltk = @import("zfltk.zig");
const app = zfltk.app;
const widget = @import("widget.zig");
const Widget = widget.Widget;
const enums = @import("enums.zig");
const Event = enums.Event;
const std = @import("std");
const c = zfltk.c;

pub const MenuFlag = enum(i32) {
    /// normal item
    normal = 0,
    /// inactive item
    inactive = 1,
    /// item is a checkbox toggle (shows checkbox for on/off state)
    toggle = 2,
    /// the on/off state for checkbox/radio buttons (if set, state is 'on')
    value = 4,
    /// item is a radio button
    radio = 8,
    /// invisible item
    invisible = 0x10,
    /// indicates user_data() is a pointer to another menu array (unused with rust)
    submenu_pointer = 0x20,
    /// menu item is a submenu
    submenu = 0x40,
    /// menu divider
    menu_divider = 0x80,
    /// horizontal menu (actually reserved for future use)
    menu_horizontal = 0x100,
};

pub const MenuBar = MenuType(.menu_bar);
pub const SysMenuBar = MenuType(.sys_menu_bar);
pub const Choice = MenuType(.choice);

const MenuKind = enum {
    menu_bar,
    sys_menu_bar,
    choice,
};

fn MenuType(comptime kind: MenuKind) type {
    return struct {
        const Self = @This();

        pub usingnamespace zfltk.widget.methods(Self, RawPtr);
        pub usingnamespace methods(Self, RawPtr);

        pub const RawPtr = switch (kind) {
            .menu_bar => *c.Fl_Menu_Bar,
            .choice => *c.Fl_Choice,
            .sys_menu_bar => *c.Fl_Sys_Menu_Bar,
        };
        const type_name = @typeName(RawPtr);
        const ptr_name = type_name[(std.mem.indexOf(u8, type_name, "struct_Fl_") orelse 0) + 7 .. type_name.len];

        pub const Options = struct {
            x: i32 = 0,
            y: i32 = 0,
            w: u31 = 0,
            h: u31 = 0,

            label: ?[:0]const u8 = null,
        };

        pub inline fn init(opts: Options) !*Self {
            const initFn = @field(c, ptr_name ++ "_new");

            const label = if (opts.label != null) opts.label.?.ptr else null;

            if (initFn(opts.x, opts.y, opts.w, opts.h, label)) |ptr| {
                const self = Self.fromRaw(ptr);
                return self;
            }

            unreachable;
        }

        pub inline fn deinit(self: *Self) void {
            const deinitFn = @field(c, ptr_name ++ "_delete");

            deinitFn(self.raw());
            app.allocator.destroy(self);
        }
    };
}

fn methods(comptime Self: type, comptime RawPtr: type) type {
    const type_name = @typeName(RawPtr);
    const ptr_name = type_name[(std.mem.indexOf(u8, type_name, "struct_Fl_") orelse 0) + 7 .. type_name.len];
    return struct {
        pub inline fn menu(self: *Self) *MenuType(.menu_bar) {
            return @ptrCast(self);
        }

        pub fn add(self: *Self, name: [*c]const u8, shortcut: i32, flag: MenuFlag, f: *const fn (w: *Self) void) void {
            _ = @field(c, ptr_name ++ "_add")(self.raw(), name, shortcut, &widget.zfltk_cb_handler, @ptrFromInt(@intFromPtr(f)), @intFromEnum(flag));
        }

        pub fn addEx(self: *Self, name: [*c]const u8, shortcut: i32, flag: MenuFlag, f: *const fn (w: *Self, data: ?*anyopaque) void, data: ?*anyopaque) void {
            var container = app.allocator.alloc(usize, 2) catch unreachable;
            container[0] = @intFromPtr(f);
            container[1] = @intFromPtr(data);
            _ = @field(c, ptr_name ++ "_add")(self.raw(), name, shortcut, widget.zfltk_cb_handler_ex, @ptrCast(container.ptr), @intFromEnum(flag));
        }

        pub fn insert(self: *Self, idx: u32, name: [*c]const u8, shortcut: i32, flag: MenuFlag, f: *const fn (w: *Self) void) void {
            _ = @field(c, ptr_name ++ "_insert")(self.raw(), @intCast(idx), name, shortcut, &widget.zfltk_cb_handler, @ptrFromInt(@intFromPtr(f)), @intFromEnum(flag));
        }

        pub fn addEmit(self: *Self, name: [*c]const u8, shortcut: i32, flag: MenuFlag, comptime T: type, msg: T) void {
            _ = @field(c, ptr_name ++ "_add")(self.raw(), name, shortcut, widget.shim, @ptrFromInt(@intFromEnum(msg)), @intFromEnum(flag));
        }

        pub fn insertEmit(self: *Self, idx: u32, name: [*c]const u8, shortcut: i32, flag: MenuFlag, comptime T: type, msg: T) void {
            _ = @field(c, ptr_name ++ "_insert")(self.raw(), @intCast(idx), name, shortcut, widget.shim, @as(usize, @bitCast(msg)), @intFromEnum(flag));
        }

        pub fn remove(self: *Self, idx: i32) void {
            _ = @field(c, ptr_name ++ "_remove")(self.raw(), @intCast(idx));
        }

        pub fn findItem(self: *Self, path: [*c]const u8) MenuItem {
            return MenuItem{ .inner = @field(c, ptr_name ++ "_get_item")(self.raw(), path) };
        }

        pub fn clear(self: *Self) void {
            @field(c, ptr_name ++ "_clear")(self.raw());
        }

        pub fn setTextFont(self: *Self, font: enums.Font) void {
            @field(c, ptr_name ++ "_set_text_font")(self.raw(), @intFromEnum(font));
        }

        pub fn setTextColor(self: *Self, col: enums.Color) void {
            @field(c, ptr_name ++ "_set_text_color")(self.raw(), @intCast(col.toRgbi()));
        }

        pub fn setTextSize(self: *Self, sz: i32) void {
            @field(c, ptr_name ++ "_set_text_size")(self.raw(), @intCast(sz));
        }
    };
}

pub const MenuItem = struct {
    inner: ?*c.Fl_Menu_Item,
    pub fn setCallback(self: *MenuItem, comptime cb: fn (w: ?*c.Fl_Widget, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Menu_Item_set_callback(self.inner, cb, data);
    }

    pub fn setLabel(self: *MenuItem, str: [*c]const u8) void {
        c.Fl_Menu_Item_set_label(self.inner, str);
    }

    pub fn labelColor(self: *MenuItem) enums.Color {
        return enums.Color.fromRgbi(c.Fl_Menu_Item_label_color(self.inner));
    }

    pub fn setLabelColor(self: *MenuItem, col: enums.Color) void {
        c.Fl_Menu_Item_set_label_color(self.inner, @intCast(col.toRgbi()));
    }

    pub fn labelFont(self: *MenuItem) enums.Font {
        return @enumFromInt(c.Fl_Menu_Item_label_font(self.inner));
    }

    pub fn setLabelFont(self: *MenuItem, font: enums.Font) void {
        c.Fl_Menu_Item_set_label_font(self.inner, @intFromEnum(font));
    }

    pub fn labelSize(self: *MenuItem) i32 {
        return c.Fl_Menu_Item_label_size(self.inner);
    }

    pub fn setLabelSize(self: *MenuItem, sz: i32) void {
        c.Fl_Menu_Item_set_label_size(self.inner, @intCast(sz));
    }

    pub fn show(self: *MenuItem) void {
        c.Fl_Menu_Item_show(self.inner);
    }

    pub fn hide(self: *MenuItem) void {
        c.Fl_Menu_Item_hide(self.inner);
    }
};

test "all" {
    @import("std").testing.refAllDeclsRecursive(@This());
}
