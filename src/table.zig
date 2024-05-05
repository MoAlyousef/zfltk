const zfltk = @import("zfltk.zig");
const app = zfltk.app;
const widget = @import("widget.zig");
const Widget = widget.Widget;
const enums = @import("enums.zig");
const Event = enums.Event;
const std = @import("std");
const c = zfltk.c;

const TableKind = enum {
    table,
    table_row,
};

pub const Table = TableType(.table);
pub const TableRow = TableType(.table_row);

fn TableType(comptime kind: TableKind) type {
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
                .table => c.Fl_Table_new,
                .table_row => c.Fl_Table_Row_new,
            };

            const label = if (opts.label != null) opts.label.?.ptr else null;

            if (initFn(opts.x, opts.y, opts.w, opts.h, label)) |ptr| {
                const self = Self.fromRaw(ptr);
                return self;
            }

            unreachable;
        }

        pub inline fn deinit(self: *Self) void {
            const deinitFn = switch (kind) {
                .table => c.Fl_Table_delete,
                .table_row => c.Fl_Table_Row_delete,
            };

            deinitFn(self.raw());
            app.allocator.destroy(self);
        }
    };
}

fn methods(comptime Self: type) type {
    return struct {
        pub inline fn table(self: *Self) *TableType(.table) {
            return @ptrCast(self);
        }
    };
}

test "all" {
    @import("std").testing.refAllDeclsRecursive(@This());
}
