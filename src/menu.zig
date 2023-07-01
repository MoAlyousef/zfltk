const zfltk = @import("zfltk.zig");
const app = zfltk.app;
const widget = @import("widget.zig");
const Widget = widget.Widget;
const enums = @import("enums.zig");
const Event = enums.Event;
const std = @import("std");
const c = zfltk.c;

fn shim(w: ?*c.Fl_Widget, data: ?*anyopaque) callconv(.C) void {
    _ = w;
    c.Fl_awake_msg(data);
}

pub const MenuFlag = enum(i32) {
    /// Normal item
    Normal = 0,
    /// Inactive item
    Inactive = 1,
    /// Item is a checkbox toggle (shows checkbox for on/off state)
    Toggle = 2,
    /// The on/off state for checkbox/radio buttons (if set, state is 'on')
    Value = 4,
    /// Item is a radio button
    Radio = 8,
    /// Invisible item
    Invisible = 0x10,
    /// Indicates user_data() is a pointer to another menu array (unused with Rust)
    SubmenuPointer = 0x20,
    /// Menu item is a submenu
    Submenu = 0x40,
    /// Menu divider
    MenuDivider = 0x80,
    /// Horizontal menu (actually reserved for future use)
    MenuHorizontal = 0x100,
};

pub const MenuKind = enum {
    menu_bar,
    sys_menu_bar,
    choice,
};

pub fn Menu(comptime kind: MenuKind) type {
    return struct {
        const Self = @This();

        pub usingnamespace zfltk.widget.methods(Self, RawPtr);
        pub usingnamespace methods(Self);

        pub const RawPtr = switch (kind) {
            .menu_bar => *c.Fl_Menu_Bar,
            .choice => *c.Fl_Choice,
            .sys_menu_bar => *c.Fl_Sys_Menu_Bar,
        };

        pub const Options = struct {
            x: i32 = 0,
            y: i32 = 0,
            w: u31 = 0,
            h: u31 = 0,

            label: ?[:0]const u8 = null,
        };

        pub inline fn init(opts: Options) !*Self {
            const initFn = switch (kind) {
                .menu_bar => c.Fl_Menu_Bar_new,
                .choice => c.Fl_Choice_new,
                .sys_menu_bar => c.Fl_Sys_Menu_Bar_new,
            };

            const label = if (opts.label != null) opts.label.?.ptr else null;

            if (initFn(opts.x, opts.y, opts.w, opts.h, label)) |ptr| {
                var self = Self.fromRaw(ptr);
                return self;
            }

            unreachable;
        }
    };
}


pub fn methods(comptime Self: type) type {
    return struct {
        pub inline fn menu(self: *Self) *Menu(.menu_bar) {
            return @ptrCast(self);
        }

        pub fn handle(self: *const Self, cb: fn (w: widget.WidgetPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
            c.Fl_Menu_Bar_handle(self.menu().raw(), @ptrCast(cb), data);
        }

        pub fn draw(self: *const Self, cb: fn (w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
            c.Fl_Menu_Bar_handle(self.menu().raw(),  @ptrCast(cb), data);
        }

        pub fn add(self: *Self, name: [*c]const u8, shortcut: i32, flag: MenuFlag, f: *const fn (w: *Self) void) void {
            _ = c.Fl_Menu_Bar_add(self.menu().raw(), name, shortcut, @ptrCast(f), null, @intFromEnum(flag));
        }

        pub fn addEx(self: *Self, name: [*c]const u8, shortcut: i32, flag: MenuFlag, f: *const fn (w: *Self, data: ?*anyopaque) void, data: ?*anyopaque) void {
            var container = app.allocator.alloc(usize, 2) catch unreachable;
            container[0] = @intFromPtr(f);
            container[1] = @intFromPtr(data);
            _ = c.Fl_Menu_Bar_add(self.menu().raw(), name, shortcut, zfltk_menu_cb_handler_ex, @ptrCast(container.ptr), @intFromEnum(flag));
        }

        pub fn insert(self: *const Self, idx: u32, name: [*c]const u8, shortcut: i32, flag: MenuFlag, cb: fn (w: ?*c.Fl_Widget, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
            _ = c.Fl_Menu_Bar_insert(self.menu().raw(), idx, name, shortcut, cb, data, @intFromEnum(flag));
        }

        pub fn addEmit(self: *Self, name: [*c]const u8, shortcut: i32, flag: MenuFlag, comptime T: type, msg: T) void {
            _ = c.Fl_Menu_Bar_add(self.menu().raw(), name, shortcut, shim, @ptrFromInt(@intFromEnum(msg)), @intFromEnum(flag));
        }

        pub fn insertEmit(self: *Self, idx: u32, name: [*c]const u8, shortcut: i32, flag: MenuFlag, comptime T: type, msg: T) void {
            _ = c.Fl_Menu_Bar_insert(self.menu().raw(), idx, name, shortcut, shim, @as(usize, @bitCast(msg)), @intFromEnum(flag));
        }

        pub fn remove(self: *Self, idx: u32) void {
            _ = c.Fl_Menu_Bar_remove(self.menu().raw(), idx);
        }

        pub fn findItem(self: *Self, path: [*c]const u8) MenuItem {
            return MenuItem{ .inner = c.Fl_Menu_Bar_get_item(self.menu().raw(), path) };
        }

        pub fn clear(self: *const Self) void {
            c.Fl_Menu_Bar_clear(self.menu().raw());
        }

        pub fn setTextFont(self: *const Self, font: enums.Font) void {
            c.Fl_Menu_Bar_set_text_font(self.menu().raw(), @intFromEnum(font));
        }

        pub fn setTextColor(self: *const Self, col: enums.Color) void {
            c.Fl_Menu_Bar_set_text_color(self.menu().raw(), col.toRgbi());
        }

        pub fn setTextSize(self: *Self, sz: i32) void {
            c.Fl_Menu_Bar_set_text_size(self.menu().raw(), sz);
        }
    };
}

pub const MenuItem = struct {
    inner: ?*c.Fl_Menu_Item,
    pub fn setCallback(self: *const MenuItem, comptime cb: fn (w: ?*c.Fl_Widget, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Menu_Item_set_callback(self.inner, cb, data);
    }

    pub fn setLabel(self: *const MenuItem, str: [*c]const u8) void {
        c.Fl_Menu_Item_set_label(self.inner, str);
    }

    pub fn color(self: *const MenuItem) enums.Color {
        return enums.Color.fromRgbi(c.Fl_Menu_Item_color(self.inner));
    }

    pub fn labelColor(self: *const MenuItem) enums.Color {
        return enums.Color.fromRgbi(c.Fl_Menu_Item_label_color(self.inner));
    }

    pub fn setLabelColor(self: *const MenuItem, col: enums.Color) void {
        c.Fl_Menu_Item_set_label_color(self.inner, col.toRgbi());
    }

    pub fn labelFont(self: *const MenuItem) enums.Font {
        return  @enumFromInt(c.Fl_Menu_Item_label_font(self.inner));
    }

    pub fn setLabelFont(self: *const MenuItem, font: enums.Font) void {
        c.Fl_Menu_Item_set_label_font(self.inner, @intFromEnum(font));
    }

    pub fn labelSize(self: *const MenuItem) i32 {
        c.Fl_Menu_Item_label_size(self.inner);
    }

    pub fn setLabelSize(self: *const MenuItem, sz: i32) void {
        c.Fl_Menu_Item_set_label_size(self.inner, sz);
    }

    pub fn show(self: *const MenuItem) void {
        c.Fl_Menu_Item_show(self.inner);
    }

    pub fn hide(self: *const MenuItem) void {
        c.Fl_Menu_Item_hide(self.inner);
    }
};

export fn zfltk_menu_cb_handler_ex(wid: ?*c.Fl_Widget, data: ?*anyopaque) callconv(.C) void {
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
