const zfltk = @import("zfltk.zig");
const app = zfltk.app;
const widget = @import("widget.zig");
const Widget = widget.Widget;
const enums = @import("enums.zig");
const Event = enums.Event;
const std = @import("std");
const c = zfltk.c;

pub fn Tree() type {
    return struct {
        const Self = @This();

        pub usingnamespace zfltk.widget.methods(Self, RawPtr);
        pub usingnamespace methods(Self);

        pub const RawPtr = *c.Fl_Tree;

        pub const Options = struct {
            x: i32 = 0,
            y: i32 = 0,
            w: u31 = 0,
            h: u31 = 0,

            label: ?[:0]const u8 = null,
        };

        pub inline fn init(opts: Options) !*Self {
            const initFn = c.Fl_Tree_new;

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
        pub inline fn tree(self: *Self) *Tree {
            return @ptrCast(self);
        }

        pub fn handle(self: *Self, comptime cb: fn (w: widget.RawPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
            c.Fl_Tree_handle(self.tree().raw(), @ptrCast(cb), data);
        }

        pub fn draw(self: *Self, comptime cb: fn (w: widget.RawPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
            c.Fl_Tree_draw(self.tree().raw(), @ptrCast(cb), data);
        }
    };
}

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
            .inner = @ptrCast(ptr),
        };
    }

    pub fn toVoidPtr(self: *const TreeItem) ?*anyopaque {
        return @ptrCast(self.inner);
    }
};

test "all" {
    @import("std").testing.refAllDeclsRecursive(@This());
}
