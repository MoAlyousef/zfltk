const c = @cImport({
    @cInclude("cfl_browser.h");
});
const widget = @import("widget.zig");
const valuator = @import("valuator.zig");
const enums = @import("enums.zig");

pub const Browser = struct {
    inner: ?*c.Fl_Browser,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) Browser {
        const ptr = c.Fl_Browser_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return Browser{
            .inner = ptr,
        };
    }

    pub fn raw(self: *Browser) ?*c.Fl_Browser {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Browser) Browser {
        return Browser{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) Browser {
        return Browser{
            .inner = @ptrCast(?*c.Fl_Browser, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) Browser {
        return Browser{
            .inner = @ptrCast(?*c.Fl_Browser, ptr),
        };
    }

    pub fn toVoidPtr(self: *Browser) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asWidget(self: *const Browser) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn handle(self: *Browser, cb: fn (w: widget.WidgetPtr,  ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Browser_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *Browser, cb: fn (w: widget.WidgetPtr,  data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Browser_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }

    pub fn remove(self: *Browser, line: u32) void {
        return c.Fl_Browser_remove(self.inner, line);
    }

    pub fn add(self: *Browser, item: [*c]const u8) void {
        return c.Fl_Browser_add(self.inner, item);
    }

    pub fn insert(self: *Browser, line: u32, item: [*c]const u8) void {
        return c.Fl_Browser_insert(self.inner, line, item);
    }
    pub fn moveItem(self: *Browser, to: u32, from: u32) void {
        return c.Fl_Browser_move_item(self.inner, to, from);
    }

    pub fn swap(self: *Browser, a: u32, b: u32) void {
        return c.Fl_Browser_swap(self.inner, a, b);
    }

    pub fn clear(self: *Browser) void {
        return c.Fl_Browser_clear(self.inner);
    }

    pub fn size(self: *const Browser) u32 {
        return c.Fl_Browser_size(self.inner);
    }

    pub fn setSize(self: *Browser, w: i32, h: i32) void {
        return c.Fl_Browser_set_size(self.inner, w, h);
    }

    pub fn select(self: *Browser, line: u32) void {
        if (line <= self.size()) return c.Fl_Browser_select(self.inner, line);
    }

    pub fn selected(self: *const Browser, line: u32) bool {
        return c.Fl_Browser_selected(self.inner, line) != 0;
    }

    pub fn text(self: *const Browser, line: u32) [*c]const u8 {
        return c.Fl_Browser_text(self.inner, line);
    }

    pub fn setText(self: *Browser, line: u32, txt: [*c]const u8) void {
        return c.Fl_Browser_set_text(self.inner, line, txt);
    }

    pub fn load(self: *Browser, path: [*c]const u8) void {
        return c.Fl_Browser_load_file(self.inner, path);
    }

    pub fn textSize(self: *const Browser) u32 {
        return c.Fl_Browser_text_size(self.inner);
    }

    pub fn setTextSize(self: *Browser, val: u32) void {
        return c.Fl_Browser_set_text_size(self.inner, val);
    }

    pub fn topline(self: *Browser, line: u32) void {
        return c.Fl_Browser_topline(self.inner, line);
    }

    pub fn bottomline(self: *Browser, line: u32) void {
        return c.Fl_Browser_bottomline(self.inner, line);
    }

    pub fn middleline(self: *Browser, line: u32) void {
        return c.Fl_Browser_middleline(self.inner, line);
    }

    pub fn formatChar(self: *const Browser) u8 {
        return c.Fl_Browser_format_char(self.inner);
    }

    pub fn setFormatChar(self: *Browser, char: u8) void {
        return c.Fl_Browser_set_format_char(self.inner, char);
    }

    pub fn columnChar(self: *const Browser) u8 {
        return c.Fl_Browser_column_char(self.inner);
    }

    pub fn setColumnChar(self: *Browser, char: u8) void {
        return c.Fl_Browser_set_column_char(self.inner, char);
    }

    pub fn setColumnWidths(self: *Browser, arr: [:0]const i32) void {
        return c.Fl_Browser_set_column_widths(self.inner, arr);
    }

    pub fn displayed(self: *const Browser, line: u32) bool {
        return c.Fl_Browser_displayed(self.inner, line) != 0;
    }

    pub fn makeVisible(self: *Browser, line: u32) void {
        return c.Fl_Browser_make_visible(self.inner, line);
    }

    pub fn position(self: *const Browser) u32 {
        return c.Fl_Browser_position(self.inner);
    }

    pub fn setPosition(self: *Browser, pos: u32) void {
        return c.Fl_Browser_set_position(self.inner, pos);
    }

    pub fn hposition(self: *const Browser) u32 {
        return c.Fl_Browser_hposition(self.inner);
    }

    pub fn setHposition(self: *Browser, pos: u32) void {
        return c.Fl_Browser_set_hposition(self.inner, pos);
    }

    pub fn hasScrollbar(self: *const Browser) enums.BrowserScrollbar {
        return c.Fl_Browser_has_scrollbar(self.inner);
    }

    pub fn setHasScrollbar(self: *Browser, mode: enums.BrowserScrollbar) void {
        return c.Fl_Browser_set_has_scrollbar(self.inner, mode);
    }

    pub fn scrollbarSize(self: *const Browser) u32 {
        return c.Fl_Browser_scrollbar_size(self.inner);
    }

    pub fn setScrollbarSize(self: *Browser, new_size: u32) void {
        return c.Fl_Browser_set_scrollbar_size(self.inner, new_size);
    }

    pub fn sort(self: *Browser) void {
        return c.Fl_Browser_sort(self.inner);
    }

    pub fn scrollbar(self: *const Browser) valuator.Valuator {
        return valuator.Valuator{ .inner = c.Fl_Browser_scrollbar(self.inner) };
    }

    pub fn hscrollbar(self: *const Browser) valuator.Valuator {
        return valuator.Valuator{ .inner = c.Fl_Browser_hscrollbar(self.inner) };
    }
};

pub const SelectBrowser = struct {
    inner: ?*c.Fl_Select_Browser,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) SelectBrowser {
        const ptr = c.Fl_Select_Browser_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return SelectBrowser{
            .inner = ptr,
        };
    }

    pub fn raw(self: *SelectBrowser) ?*c.Fl_Select_Browser {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Select_Browser) SelectBrowser {
        return SelectBrowser{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) SelectBrowser {
        return SelectBrowser{
            .inner = @ptrCast(?*c.Fl_Select_Browser, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) SelectBrowser {
        return SelectBrowser{
            .inner = @ptrCast(?*c.Fl_Select_Browser, ptr),
        };
    }

    pub fn toVoidPtr(self: *SelectBrowser) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asWidget(self: *const SelectBrowser) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asBrowser(self: *const SelectBrowser) Browser {
        return Browser{
            .inner = @ptrCast(?*c.Fl_Browser, self.inner),
        };
    }

    pub fn handle(self: *SelectBrowser, cb: fn (w: widget.WidgetPtr,  ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Select_Browser_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *SelectBrowser, cb: fn (w: widget.WidgetPtr,  data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Select_Browser_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }
};

pub const HoldBrowser = struct {
    inner: ?*c.Fl_Hold_Browser,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) HoldBrowser {
        const ptr = c.Fl_Hold_Browser_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return HoldBrowser{
            .inner = ptr,
        };
    }

    pub fn raw(self: *HoldBrowser) ?*c.Fl_Hold_Browser {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Hold_Browser) HoldBrowser {
        return HoldBrowser{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) HoldBrowser {
        return HoldBrowser{
            .inner = @ptrCast(?*c.Fl_Hold_Browser, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) HoldBrowser {
        return HoldBrowser{
            .inner = @ptrCast(?*c.Fl_Hold_Browser, ptr),
        };
    }

    pub fn toVoidPtr(self: *HoldBrowser) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asWidget(self: *const HoldBrowser) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asBrowser(self: *const HoldBrowser) Browser {
        return Browser{
            .inner = @ptrCast(?*c.Fl_Browser, self.inner),
        };
    }

    pub fn handle(self: *HoldBrowser, cb: fn (w: widget.WidgetPtr,  ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Hold_Browser_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *HoldBrowser, cb: fn (w: widget.WidgetPtr,  data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Hold_Browser_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }
};

pub const MultiBrowser = struct {
    inner: ?*c.Fl_Multi_Browser,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) MultiBrowser {
        const ptr = c.Fl_Multi_Browser_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return MultiBrowser{
            .inner = ptr,
        };
    }

    pub fn raw(self: *MultiBrowser) ?*c.Fl_Multi_Browser {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Multi_Browser) MultiBrowser {
        return MultiBrowser{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) MultiBrowser {
        return MultiBrowser{
            .inner = @ptrCast(?*c.Fl_Multi_Browser, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) MultiBrowser {
        return MultiBrowser{
            .inner = @ptrCast(?*c.Fl_Multi_Browser, ptr),
        };
    }

    pub fn toVoidPtr(self: *MultiBrowser) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asWidget(self: *const MultiBrowser) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asBrowser(self: *const MultiBrowser) Browser {
        return Browser{
            .inner = @ptrCast(?*c.Fl_Browser, self.inner),
        };
    }

    pub fn handle(self: *MultiBrowser, cb: fn (w: widget.WidgetPtr,  ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Multi_Browser_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *MultiBrowser, cb: fn (w: widget.WidgetPtr,  data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Multi_Browser_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }
};

pub const FileBrowser = struct {
    inner: ?*c.Fl_File_Browser,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) FileBrowser {
        const ptr = c.Fl_File_Browser_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return FileBrowser{
            .inner = ptr,
        };
    }

    pub fn raw(self: *FileBrowser) ?*c.Fl_File_Browser {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_File_Browser) FileBrowser {
        return FileBrowser{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) FileBrowser {
        return FileBrowser{
            .inner = @ptrCast(?*c.Fl_File_Browser, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) FileBrowser {
        return FileBrowser{
            .inner = @ptrCast(?*c.Fl_File_Browser, ptr),
        };
    }

    pub fn toVoidPtr(self: *FileBrowser) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asWidget(self: *const FileBrowser) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asBrowser(self: *const FileBrowser) Browser {
        return Browser{
            .inner = @ptrCast(?*c.Fl_Browser, self.inner),
        };
    }

    pub fn handle(self: *FileBrowser, cb: fn (w: widget.WidgetPtr,  ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_File_Browser_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *FileBrowser, cb: fn (w: widget.WidgetPtr,  data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_File_Browser_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }
};

test "" {
    @import("std").testing.refAllDecls(@This());
}