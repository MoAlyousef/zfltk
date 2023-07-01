const zfltk = @import("zfltk.zig");
const app = zfltk.app;
const std = @import("std");
const Widget = @import("widget.zig").Widget;
const Event = @import("enums.zig").Event;
const enums = zfltk.enums;
const c = zfltk.c;

pub const Box = struct {
    const Self = @This();

    pub usingnamespace zfltk.widget.methods(Self, *c.Fl_Box);

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
        c.Fl_Box_delete(self.inner);
        app.allocator.destroy(self);
    }

    pub inline fn fromDynWidgetPtr(w: *c.Fl_Widget) ?Self {
        if (c.Fl_Box_from_dyn_ptr(@ptrCast(w))) |v| {
            return .{
                .inner = v,
            };
        } else {
            return null;
        }
    }

    pub inline fn setEventHandler(self: *Self, f: *const fn (*Self, Event) bool) void {
        c.Fl_Box_handle(
            self.raw(),
            zfltk_box_event_handler,
            @ptrFromInt(@intFromPtr(&f)),
        );
    }

    pub inline fn setEventHandlerEx(self: *Self, f: *const fn (*Self, Event, ?*anyopaque) bool, data: ?*anyopaque) void {
        var container = app.allocator.alloc(usize, 2) catch unreachable;

        container[0] = @intFromPtr(f);
        container[1] = @intFromPtr(data);

        c.Fl_Box_handle(
            self.raw(),
            zfltk_box_event_handler_ex,
            @ptrCast(container.ptr),
        );
    }

    // TODO: refactor this to match `setHandle` for memory safety
    pub fn draw(self: *Self, cb: fn (w: *c.Fl_Widget, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Box_handle(self.raw(), @ptrCast(cb), data);
    }
};

export fn zfltk_box_event_handler(wid: ?*c.Fl_Widget, ev: c_int, data: ?*anyopaque) callconv(.C) c_int {
    const cb: *const fn (*Widget, Event) bool = @ptrCast(
        data,
    );

    return @intFromBool(cb(
        Widget.fromRaw(wid.?),
        @enumFromInt(ev),
    ));
}

export fn zfltk_box_event_handler_ex(wid: ?*c.Fl_Widget, ev: c_int, data: ?*anyopaque) callconv(.C) c_int {
    const container: *[2]usize = @ptrCast(@alignCast(data));

    const cb: *const fn (*Widget, Event, ?*anyopaque) bool = @ptrFromInt(
        container[0],
    );

    return @intFromBool(cb(
        Widget.fromRaw(wid.?),
        @enumFromInt(ev),
        @ptrFromInt(container[1]),
    ));
}

test "all" {
    @import("std").testing.refAllDecls(@This());
}
