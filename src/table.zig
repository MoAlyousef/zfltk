const zfltk = @import("zfltk.zig");
const app = zfltk.app;
const widget = @import("widget.zig");
const Widget = widget.Widget;
const enums = @import("enums.zig");
const Event = enums.Event;
const std = @import("std");
const c = zfltk.c;

pub const TableKind = enum {
    table,
    table_row,
};

pub fn Table(comptime kind: TableKind) type {
    return struct {
        const Self = @This();

        pub usingnamespace zfltk.widget.methods(Self, RawPtr);
        pub usingnamespace methods(Self);

        pub const RawPtr = switch (kind) {
            .table => *c.Fl_Table,
            .table_row => *c.Fl_Table_Row,
        };

        pub const Options = struct {
            x: i32 = 0,
            y: i32 = 0,
            w: u31 = 0,
            h: u31 = 0,

            label: ?[:0]const u8 = null,
        };

        pub inline fn init(opts: Options) !*Self {
            const initFn = switch (kind) {
                .table => c.Fl_Table,
                .table_row => c.Fl_Table_Row,
            };

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
        pub inline fn table(self: *Self) *Table(.table) {
            return @ptrCast(self);
        }

        pub inline fn setEventHandler(self: *Self, comptime f: fn (*Self, enums.Event) bool) void {
            c.Fl_Table_handle(
                self.raw(),
                &widget.zfltk_event_handler,
                @ptrFromInt(@intFromPtr(&f)),
            );
        }

        pub inline fn setEventHandlerEx(self: *Self, comptime f: fn (*Self, enums.Event, ?*anyopaque) bool, data: ?*anyopaque) void {
            var allocator = @import("std").heap.c_allocator;
            var container = allocator.alloc(usize, 2) catch unreachable;

            container[0] = @intFromPtr(&f);
            container[1] = @intFromPtr(data);

            c.Fl_Table_handle(
                self.raw(),
                &widget.zfltk_event_handler_ex,
                @ptrCast(container.ptr),
            );
        }

        pub inline fn setDrawHandler(self: *Self, comptime f: fn (*Self) void) void {
            c.Fl_Table_draw(
                self.raw(),
                &widget.zfltk_draw_handler,
                @ptrFromInt(@intFromPtr(&f)),
            );
        }

        pub inline fn setDrawHandlerEx(self: *Self, comptime f: fn (*Self, ?*anyopaque) void, data: ?*anyopaque) void {
            var allocator = std.heap.c_allocator;
            var container = allocator.alloc(usize, 2) catch unreachable;

            container[0] = @intFromPtr(&f);
            container[1] = @intFromPtr(data);

            c.Fl_Table_draw(
                self.raw(),
                &widget.zfltk_event_handler_ex,
                @ptrCast(container.ptr),
            );
        }
    };
}

test "all" {
    @import("std").testing.refAllDeclsRecursive(@This());
}
