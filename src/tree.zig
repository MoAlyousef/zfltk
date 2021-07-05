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

    pub fn raw(self: *Tree) ?*c.Fl_Tree {
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

    pub fn fromVoidPtr(ptr: ?*c_void) Tree {
        return Tree{
            .inner = @ptrCast(?*c.Fl_Tree, ptr),
        };
    }

    pub fn toVoidPtr(self: *Tree) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asWidget(self: *const Tree) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn handle(self: *Tree, cb: fn (w: *widget.WidgetPtr, ev: i32, data: ?*c_void) callconv(.C) i32, data: ?*c_void) void {
        c.Fl_Tree_handle(self.inner, cb, data);
    }

    pub fn draw(self: *Tree, cb: fn (w: *widget.WidgetPtr, data: ?*c_void) callconv(.C) void, data: ?*c_void) void {
        c.Fl_Tree_draw(self.inner, cb, data);
    }
};

pub const TreeItem = struct {
    inner: ?*c.Fl_Tree_Item,
    pub fn raw(self: *TreeItem) ?*c.Fl_Tree_Item {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Tree_Item) TreeItem {
        return TreeItem{
            .inner = ptr,
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) TreeItem {
        return TreeItem{
            .inner = @ptrCast(?*c.Fl_Tree_Item, ptr),
        };
    }

    pub fn toVoidPtr(self: *TreeItem) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }
};

test "" {
    @import("std").testing.refAllDecls(@This());
}