const c = @cImport({
    @cInclude("cfl_tree.h");
});
const widget = @import("widget.zig");

pub const Tree = struct {
    inner: ?*c.Fl_Tree,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) Tree {
        const ptr = c.Fl_Tree_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return Tree{
            .inner = ptr,
        };
    }

    pub fn raw(self: *const Tree) ?*c.Fl_Tree {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Tree) Tree {
        return Tree{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) Tree {
        return Tree{
            .inner = @ptrCast(?*c.Fl_Tree, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*anyopaque) Tree {
        return Tree{
            .inner = @ptrCast(?*c.Fl_Tree, ptr),
        };
    }

    pub fn toVoidPtr(self: *const Tree) ?*anyopaque {
        return @ptrCast(?*anyopaque, self.inner);
    }

    pub fn asWidget(self: *const Tree) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn handle(self: *const Tree, cb: fn (w: widget.WidgetPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
        c.Fl_Tree_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *const Tree, cb: fn (w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Tree_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }
};

pub const TreeItem = struct {
    inner: ?*c.Fl_Tree_Item,
    pub fn raw(self: *const TreeItem) ?*c.Fl_Tree_Item {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Tree_Item) TreeItem {
        return TreeItem{
            .inner = ptr,
        };
    }

    pub fn fromVoidPtr(ptr: ?*anyopaque) TreeItem {
        return TreeItem{
            .inner = @ptrCast(?*c.Fl_Tree_Item, ptr),
        };
    }

    pub fn toVoidPtr(self: *const TreeItem) ?*anyopaque {
        return @ptrCast(?*anyopaque, self.inner);
    }
};

test "all" {
    @import("std").testing.refAllDecls(@This());
}
