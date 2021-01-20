const c = @cImport({
    @cInclude("cfl_group.h");
});
const widget = @import("widget.zig");

pub const GroupPtr = ?*c.Fl_Group;

pub const Group = struct {
    inner: ?*c.Fl_Group,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [:0]const u8) Group {
        const ptr = c.Fl_Group_new(x, y, w, h, title);
        if (ptr == null) {
            unreachable;
        }
        return Group{
            .inner = ptr,
        };
    }
    pub fn raw(self: *Group) ?*c.Fl_Group {
        return self.inner;
    }
    pub fn fromRaw(ptr: ?*c.Fl_Group) Group {
        return Group{
            .inner = ptr,
        };
    }
    pub fn fromWidgetPtr(w: widget.WidgetPtr) Group {
        return Group{
            .inner = @ptrCast(*c.Fl_Group, w),
        };
    }
    pub fn fromVoidPtr(ptr: ?*c_void) Group {
        return Group{
            .inner = @ptrCast(*c.Fl_Group, ptr),
        };
    }
    pub fn asWidget(self: *Group) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }
    pub fn end(self: *Group) void {
        c.Fl_Group_end(self.inner);
    }
};
