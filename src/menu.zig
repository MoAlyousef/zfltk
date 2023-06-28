const c = @cImport({
    @cInclude("cfl.h");
    @cInclude("cfl_menu.h");
});
const widget = @import("widget.zig");
const Widget = widget.Widget;
const enums = @import("enums.zig");

pub const WidgetPtr = ?*c.Fl_Widget;

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

pub const Menu = struct {
    inner: ?*c.Fl_Menu_Bar,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) Menu {
        const ptr = c.Fl_Menu_Bar_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return Menu{
            .inner = ptr,
        };
    }

    pub fn raw(self: *const Menu) ?*c.Fl_Menu_Bar {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Menu_Bar) Menu {
        return Menu{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: ?*c.Fl_Widget) Menu {
        return Menu{
            .inner = @ptrCast(w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*anyopaque) Menu {
        return Menu{
            .inner = @ptrCast(ptr),
        };
    }

    pub fn toVoidPtr(self: *const Menu) ?*anyopaque {
        return  @ptrCast(self.inner);
    }

    pub fn asWidget(self: *const Menu) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(self.inner),
        };
    }

    pub fn handle(self: *const Menu, cb: fn (w: widget.WidgetPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
        c.Fl_Menu_Bar_handle(self.inner, @ptrCast(cb), data);
    }

    pub fn draw(self: *const Menu, cb: fn (w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Menu_Bar_handle(self.inner,  @ptrCast(cb), data);
    }

    pub fn add(self: *const Menu, name: [*c]const u8, shortcut: i32, flag: MenuFlag, f: *const fn (w: *Widget) void) void {
        _ = c.Fl_Menu_Bar_add(self.inner, name, shortcut, @ptrCast(f), null, @intFromEnum(flag));
    }

    pub fn addEx(self: *const Menu, name: [*c]const u8, shortcut: i32, flag: MenuFlag, f: *const fn (w: *Widget, data: ?*anyopaque) void, data: ?*anyopaque) void {
        _ = c.Fl_Menu_Bar_add(self.inner, name, shortcut, @ptrCast(f), data, @intFromEnum(flag));
    }

    pub fn insert(self: *const Menu, idx: u32, name: [*c]const u8, shortcut: i32, flag: MenuFlag, cb: fn (w: ?*c.Fl_Widget, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        _ = c.Fl_Menu_Bar_insert(self.inner, idx, name, shortcut, cb, data, @intFromEnum(flag));
    }

    pub fn addEmit(self: *const Menu, name: [*c]const u8, shortcut: i32, flag: MenuFlag, comptime T: type, msg: T) void {
        _ = c.Fl_Menu_Bar_add(self.inner, name, shortcut, shim, @ptrFromInt(@intFromEnum(msg)), @intFromEnum(flag));
    }

    pub fn insertEmit(self: *const Menu, idx: u32, name: [*c]const u8, shortcut: i32, flag: MenuFlag, comptime T: type, msg: T) void {
        _ = c.Fl_Menu_Bar_insert(self.inner, idx, name, shortcut, shim, @as(usize, @bitCast(msg)), @intFromEnum(flag));
    }

    pub fn remove(self: *const Menu, idx: u32) void {
        _ = c.Fl_Menu_Bar_remove(self.inner, idx);
    }

    pub fn findItem(self: *const Menu, path: [*c]const u8) MenuItem {
        return MenuItem{ .inner = c.Fl_Menu_Bar_get_item(self.inner, path) };
    }

    pub fn clear(self: *const Menu) void {
        c.Fl_Menu_Bar_clear(self.inner);
    }

    pub fn setTextFont(self: *const Menu, font: enums.Font) void {
        c.Fl_Menu_Bar_set_text_font(self.inner, @intFromEnum(font));
    }

    pub fn setTextColor(self: *const Menu, col: enums.Color) void {
        c.Fl_Menu_Bar_set_text_color(self.inner, col.toRgbi());
    }

    pub fn setTextSize(self: *const Menu, sz: i32) void {
        c.Fl_Menu_Bar_set_text_size(self.inner, sz);
    }
};

pub const MenuBar = struct {
    inner: ?*c.Fl_Menu_Bar,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) MenuBar {
        const ptr = c.Fl_Menu_Bar_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return MenuBar{
            .inner = ptr,
        };
    }

    pub fn raw(self: *const MenuBar) ?*c.Fl_Menu_Bar {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Menu_Bar) MenuBar {
        return MenuBar{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: ?*c.Fl_Widget) MenuBar {
        return MenuBar{
            .inner = @ptrCast(w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*anyopaque) MenuBar {
        return MenuBar{
            .inner = @ptrCast(ptr),
        };
    }

    pub fn toVoidPtr(self: *const MenuBar) ?*anyopaque {
        return  @ptrCast(self.inner);
    }

    pub fn asWidget(self: *const MenuBar) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(self.inner),
        };
    }

    pub fn asMenu(self: *const MenuBar) Menu {
        return Menu{
            .inner = @ptrCast(self.inner),
        };
    }

    pub fn handle(self: *const MenuBar, cb: fn (w: widget.WidgetPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
        c.Fl_Menu_Bar_handle(self.inner, @ptrCast(cb), data);
    }

    pub fn draw(self: *const MenuBar, cb: fn (w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Menu_Bar_handle(self.inner,  @ptrCast(cb), data);
    }
};

pub const Choice = struct {
    inner: ?*c.Fl_Choice,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) Choice {
        const ptr = c.Fl_Choice_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return Choice{
            .inner = ptr,
        };
    }

    pub fn raw(self: *const Choice) ?*c.Fl_Choice {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Choice) Choice {
        return Menu{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: ?*c.Fl_Widget) Choice {
        return Menu{
            .inner = @ptrCast(w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*anyopaque) Choice {
        return Choice{
            .inner = @ptrCast(ptr),
        };
    }

    pub fn toVoidPtr(self: *const Choice) ?*anyopaque {
        return  @ptrCast(self.inner);
    }

    pub fn asWidget(self: *const Choice) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(self.inner),
        };
    }

    pub fn asMenu(self: *const Choice) Menu {
        return Menu{
            .inner = @ptrCast(self.inner),
        };
    }

    pub fn handle(self: *const Menu, cb: fn (w: widget.WidgetPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
        c.Fl_Choice_handle(self.inner, @ptrCast(cb), data);
    }

    pub fn draw(self: *const Menu, cb: fn (w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Choice_handle(self.inner,  @ptrCast(cb), data);
    }
};

pub const SysMenuBar = struct {
    inner: ?*c.Fl_Sys_Menu_Bar,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) SysMenuBar {
        const ptr = c.Fl_Sys_Menu_Bar_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return SysMenuBar{
            .inner = ptr,
        };
    }

    pub fn raw(self: *const SysMenuBar) ?*c.Fl_Sys_Menu_Bar {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Sys_Menu_Bar) SysMenuBar {
        return SysMenuBar{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: ?*c.Fl_Widget) SysMenuBar {
        return SysMenuBar{
            .inner = @ptrCast(w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*anyopaque) SysMenuBar {
        return SysMenuBar{
            .inner = @ptrCast(ptr),
        };
    }

    pub fn toVoidPtr(self: *const SysMenuBar) ?*anyopaque {
        return  @ptrCast(self.inner);
    }

    pub fn asWidget(self: *const SysMenuBar) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(self.inner),
        };
    }

    pub fn asMenu(self: *const SysMenuBar) Menu {
        return Menu{
            .inner = @ptrCast(self.inner),
        };
    }

    pub fn handle(self: *const Menu, cb: fn (w: widget.WidgetPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
        c.Fl_Sys_Menu_Bar_handle(self.inner, @ptrCast(cb), data);
    }

    pub fn draw(self: *const Menu, cb: fn (w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Sys_Menu_Bar_handle(self.inner,  @ptrCast(cb), data);
    }
};

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

test "all" {
    @import("std").testing.refAllDecls(@This());
}
