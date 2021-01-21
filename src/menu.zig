const c = @cImport({
    @cInclude("cfl_menu.h");
});
const widget = @import("widget.zig");

pub const WidgetPtr = ?*c.Fl_Widget;

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

    pub fn raw(self: *Menu) ?*c.Fl_Menu_Bar {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Menu_Bar) Menu {
        return Menu{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: ?*c.Fl_Widget) Menu {
        return Menu{
            .inner = @ptrCast(*c.Fl_Menu_Bar, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) Menu {
        return Menu{
            .inner = @ptrCast(*c.Fl_Menu_Bar, ptr),
        };
    }

    pub fn toVoidPtr(self: *Menu) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asWidget(self: *const Menu) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn handle(self: *Menu, cb: fn (ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Menu_Bar_handle(self.inner, cb, data);
    }

    pub fn draw(self: *Menu, cb: fn (data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Menu_Bar_draw(self.inner, cb, data);
    }

    pub fn add(self: *Menu, name: [*c]const u8, shortcut: i32, flag: MenuFlag, cb: fn (w: ?*c.Fl_Widget, data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        _ = c.Fl_Menu_Bar_add(self.inner, name, shortcut, cb, data, @enumToInt(flag));
    }

    pub fn insert(self: *Menu, idx: u32, name: [*c]const u8, shortcut: i32, flag: MenuFlag, cb: fn (w: ?*c.Fl_Widget, data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        _ = c.Fl_Menu_Bar_insert(self.inner, idx, name, shortcut, cb, data, @enumToInt(flag));
    }

    pub fn remove(self: *Menu, idx: u32) void {
        _ = c.Fl_Menu_Bar_remove(self.inner, idx);
    }

    pub fn clear(self: *Menu) void {
        c.Fl_Menu_Bar_clear(self.inner);
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

    pub fn raw(self: *MenuBar) ?*c.Fl_Menu_Bar {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Menu_Bar) MenuBar {
        return MenuBar{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: ?*c.Fl_Widget) MenuBar {
        return MenuBar{
            .inner = @ptrCast(*c.Fl_Menu_Bar, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) MenuBar {
        return MenuBar{
            .inner = @ptrCast(*c.Fl_Menu_Bar, ptr),
        };
    }

    pub fn toVoidPtr(self: *MenuBar) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asWidget(self: *const MenuBar) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asMenu(self: *const MenuBar) Menu {
        return Menu{
            .inner = @ptrCast(?*c.Fl_Menu_Bar, self.inner),
        };
    }

    pub fn handle(self: *MenuBar, cb: fn (ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Menu_Bar_handle(self.inner, cb, data);
    }

    pub fn draw(self: *MenuBar, cb: fn (data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Menu_Bar_draw(self.inner, cb, data);
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

    pub fn raw(self: *Choice) ?*c.Fl_Choice {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Choice) Choice {
        return Menu{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: ?*c.Fl_Widget) Choice {
        return Menu{
            .inner = @ptrCast(*c.Fl_Choice, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) Choice {
        return Choice{
            .inner = @ptrCast(*c.Fl_Choice, ptr),
        };
    }

    pub fn toVoidPtr(self: *Choice) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asWidget(self: *const Choice) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asMenu(self: *const Choice) Menu {
        return Menu{
            .inner = @ptrCast(?*c.Fl_Menu_Bar, self.inner),
        };
    }

    pub fn handle(self: *Menu, cb: fn (ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Choice_handle(self.inner, cb, data);
    }

    pub fn draw(self: *Menu, cb: fn (data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Choice_draw(self.inner, cb, data);
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

    pub fn raw(self: *SysMenuBar) ?*c.Fl_Sys_Menu_Bar {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Sys_Menu_Bar) SysMenuBar {
        return SysMenuBar{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: ?*c.Fl_Widget) SysMenuBar {
        return SysMenuBar{
            .inner = @ptrCast(*c.Fl_Sys_Menu_Bar, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) SysMenuBar {
        return SysMenuBar{
            .inner = @ptrCast(*c.Fl_Sys_Menu_Bar, ptr),
        };
    }

    pub fn toVoidPtr(self: *SysMenuBar) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asWidget(self: *const SysMenuBar) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asMenu(self: *const SysMenuBar) Menu {
        return Menu{
            .inner = @ptrCast(?*c.Fl_Menu_Bar, self.inner),
        };
    }

    pub fn handle(self: *Menu, cb: fn (ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Sys_Menu_Bar_handle(self.inner, cb, data);
    }

    pub fn draw(self: *Menu, cb: fn (data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Sys_Menu_Bar_draw(self.inner, cb, data);
    }
};
