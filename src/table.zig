//TODO: update to new API

const c = @cImport({
    @cInclude("cfl_table.h");
});
const widget = @import("widget.zig");

pub const Table = struct {
    inner: ?*c.Fl_Table,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) Table {
        const ptr = c.Fl_Table_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return Table{
            .inner = ptr,
        };
    }

    pub fn raw(self: *const Table) ?*c.Fl_Table {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Table) Table {
        return Table{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) Table {
        return Table{
            .inner = @ptrCast(?*c.Fl_Table, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*anyopaque) Table {
        return Table{
            .inner = @ptrCast(?*c.Fl_Table, ptr),
        };
    }

    pub fn toVoidPtr(self: *const Table) ?*anyopaque {
        return @ptrCast(?*anyopaque, self.inner);
    }

    pub fn asWidget(self: *const Table) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn handle(self: *const Table, cb: fn (w: widget.WidgetPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
        c.Fl_Table_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *const Table, cb: fn (w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Table_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }
};

pub const TableRow = struct {
    inner: ?*c.Fl_Table_Row,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) TableRow {
        const ptr = c.Fl_Table_Row_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return TableRow{
            .inner = ptr,
        };
    }

    pub fn raw(self: *const TableRow) ?*c.Fl_Table_Row {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Table_Row) TableRow {
        return TableRow{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) TableRow {
        return TableRow{
            .inner = @ptrCast(?*c.Fl_Table_Row, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*anyopaque) TableRow {
        return TableRow{
            .inner = @ptrCast(?*c.Fl_Table_Row, ptr),
        };
    }

    pub fn toVoidPtr(self: *const TableRow) ?*anyopaque {
        return @ptrCast(?*anyopaque, self.inner);
    }

    pub fn asWidget(self: *const TableRow) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asTable(self: *const TableRow) Table {
        return Table{
            .inner = @ptrCast(?*c.Fl_Table, self.inner),
        };
    }

    pub fn handle(self: *const TableRow, cb: fn (w: widget.WidgetPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
        c.Fl_Table_Row_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *const TableRow, cb: fn (w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Table_Row_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }
};

test "all" {
    @import("std").testing.refAllDecls(@This());
}
