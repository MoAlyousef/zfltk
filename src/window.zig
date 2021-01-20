const c = @cImport({
    @cInclude("cfl_window.h");
});
const widget = @import("widget.zig");
const group = @import("group.zig");

pub const Window = struct {
    inner: ?*c.Fl_Double_Window,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [:0]const u8) Window {
        const ptr = c.Fl_Double_Window_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return Window{
            .inner = ptr,
        };
    }
    pub fn raw(self: *Window) ?*c.Fl_Double_Window {
        return self.inner;
    }
    pub fn fromRaw(ptr: ?*c.Fl_Double_Window) Window {
        return Window{
            .inner = ptr,
        };
    }
    pub fn fromWidgetPtr(w: widget.WidgetPtr) Window {
        return Window{
            .inner = @ptrCast(*c.Fl_Double_Window, w),
        };
    }
    pub fn fromVoidPtr(ptr: ?*c_void) Window {
        return Window{
            .inner = @ptrCast(*c.Fl_Double_Window, ptr),
        };
    }
    pub fn asWidget(self: *const Window) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }
    pub fn asGroup(self: *Window) group.Group {
        return group.Group{
            .inner = @ptrCast(group.GroupPtr, self.inner),
        };
    }
    pub fn handle(self: *Double_Window, cb: fn (ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Double_Window_handle(self.inner, cb, data);
    }
    pub fn draw(self: *Double_Window, cb: fn (data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Double_Window_draw(self.inner, cb, data);
    }
};
