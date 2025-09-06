const zfltk = @import("zfltk.zig");
const app = zfltk.app;
const std = @import("std");
const Widget = @import("widget.zig").Widget;
const Event = @import("enums.zig").Event;
const widget = zfltk.widget;
const enums = zfltk.enums;
const c = zfltk.c;

pub const Box = struct {
    const Self = @This();
    pub const RawPtr = *c.Fl_Box;
    // Namespaced widget methods (Zig 0.15.1 no usingnamespace)
    pub const widget_ns = zfltk.widget.methods(Self, *c.Fl_Box);
    pub inline fn widget_methods(self: *Self) zfltk.widget.MethodsProxy(Self, RawPtr) { return .{ .self = self }; }

    pub inline fn widget(self: *Self) *Widget {
        return widget_ns.widget(self);
    }
    pub inline fn raw(self: *Self) RawPtr {
        return widget_ns.raw(self);
    }
    pub inline fn fromRaw(ptr: *anyopaque) *Self {
        return widget_ns.fromRaw(ptr);
    }

    pub const Options = struct {
        x: u31 = 0,
        y: u31 = 0,
        w: u31 = 0,
        h: u31 = 0,

        label: ?[:0]const u8 = null,

        boxtype: enums.BoxType = .none,
    };

    pub inline fn init(opts: Options) !*Self {
        const label = if (opts.label != null) opts.label.?.ptr else null;

        if (c.Fl_Box_new(opts.x, opts.y, opts.w, opts.h, label)) |ptr| {
            if (opts.boxtype != .none) {
                c.Fl_Widget_set_box(@ptrCast(ptr), @intFromEnum(opts.boxtype));
            }

            return @ptrCast(ptr);
        }

        unreachable;
    }

    pub inline fn deinit(self: *Self) void {
        c.Fl_Box_delete(self.raw());
        app.allocator.destroy(self);
    }
};

test "all" {
    @import("std").testing.refAllDeclsRecursive(@This());
}
