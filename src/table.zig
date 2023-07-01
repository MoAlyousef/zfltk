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

        pub fn handle(self: *Self, comptime cb: fn (w: widget.RawPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
            c.Fl_Table_handle(self.table().raw(), @ptrCast(cb), data);
        }

        pub fn draw(self: *Self, comptime cb: fn (w: widget.RawPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
            c.Fl_Table_draw(self.table().raw(), @ptrCast(cb), data);
        }
    };
}

test "all" {
    @import("std").testing.refAllDeclsRecursive(@This());
}
