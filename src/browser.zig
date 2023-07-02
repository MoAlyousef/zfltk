const zfltk = @import("zfltk.zig");
const app = zfltk.app;
const Widget = @import("widget.zig").Widget;
const Valuator = @import("valuator.zig").Valuator;
const enums = @import("enums.zig");
const c = zfltk.c;
const std = @import("std");

pub const BrowserKind = enum {
    normal,
    select,
    hold,
    multi,
    file,
};

pub fn Browser(comptime kind: BrowserKind) type {
    return struct {
        const Self = @This();

        const BrowserRawPtr = *c.Fl_Browser;

        pub const RawPtr = switch (kind) {
            .normal => *c.Fl_Browser,
            .select => *c.Fl_Select_Browser,
            .hold => *c.Fl_Hold_Browser,
            .multi => *c.Fl_Multi_Browser,
            .file => *c.Fl_File_Browser,
        };

        inner: RawPtr,

        pub usingnamespace zfltk.widget.methods(Self, RawPtr);

        pub inline fn init(opts: Widget.Options) !*Self {
            const init_func = switch (kind) {
                .normal => c.Fl_Browser_new,
                .select => c.Fl_Select_Browser_new,
                .hold => c.Fl_Hold_Browser_new,
                .multi => c.Fl_Multi_Browser_new,
                .file => c.Fl_File_Browser_new,
            };

            const label = if (opts.label != null) opts.label.?.ptr else null;

            if (init_func(opts.x, opts.y, opts.w, opts.h, label)) |ptr| {
                var self = try app.allocator.create(Self);
                self.inner = ptr;

                return self;
            }

            unreachable;
        }

        pub inline fn deinit(self: *Self) void {
            const deinit_func = switch (kind) {
                .normal => c.Fl_Browser_delete,
                .select => c.Fl_Select_Browser_delete,
                .hold => c.Fl_Hold_Browser_delete,
                .multi => c.Fl_Multi_Browser_delete,
                .file => c.Fl_File_Browser_delete,
            };

            deinit_func(self.inner);
        }

        pub inline fn raw(self: *Self) RawPtr {
            return self.inner;
        }

        pub inline fn fromRaw(ptr: RawPtr) Self {
            return .{ .inner = ptr };
        }

        pub inline fn fromWidget(wid: Widget) Self {
            return Self.fromRaw(@ptrCast(wid.inner));
        }

        pub inline fn fromVoidPtr(ptr: *anyopaque) Self {
            return .{ .inner = @ptrCast(ptr) };
        }

        pub inline fn toVoidPtr(self: *Self) *anyopaque {
            return @ptrCast(self.inner);
        }

        pub fn remove(self: *Self, line: u32) void {
            return c.Fl_Browser_remove(@ptrCast(self.inner), line);
        }

        pub fn add(self: *Self, item: [:0]const u8) void {
            return c.Fl_Browser_add(@ptrCast(self.inner), item.ptr);
        }

        pub fn insert(self: *Self, line: u32, item: [:0]const u8) void {
            return c.Fl_Browser_insert(@ptrCast(self.inner), line, item.ptr);
        }

        pub fn moveItem(self: *Self, to: u32, from: u32) void {
            return c.Fl_Browser_move_item(@ptrCast(self.inner), to, from);
        }

        pub fn swap(self: *Self, a: u32, b: u32) void {
            return c.Fl_Browser_swap(@ptrCast(self.inner), a, b);
        }

        pub fn clear(self: *Self) void {
            return c.Fl_Browser_clear(@ptrCast(self.inner));
        }

        pub fn size(self: *Self) u32 {
            return c.Fl_Browser_size(@ptrCast(self.inner));
        }

        pub fn setSize(self: *Self, w: i32, h: i32) void {
            return c.Fl_Browser_set_size(@ptrCast(self.inner), w, h);
        }

        pub fn select(self: *Self, line: u32) void {
            if (line <= self.size()) return c.Fl_Browser_select(@ptrCast(self.inner), line);
        }

        pub fn selected(self: *Self, line: u32) bool {
            return c.Fl_Browser_selected(@ptrCast(self.inner), line) != 0;
        }

        pub fn text(self: *Self, line: u32) [:0]const u8 {
            return c.Fl_Browser_text(@ptrCast(self.inner), line);
        }

        pub fn setText(self: *Self, line: u32, txt: [*c]const u8) void {
            return c.Fl_Browser_set_text(@ptrCast(self.inner), line, txt);
        }

        pub fn load(self: *Self, path: [*c]const u8) void {
            return c.Fl_Browser_load_file(@ptrCast(self.inner), path);
        }

        pub fn textSize(self: *Self) u32 {
            return c.Fl_Browser_text_size(@ptrCast(self.inner));
        }

        pub fn setTextSize(self: *Self, val: u32) void {
            return c.Fl_Browser_set_text_size(@ptrCast(self.inner), val);
        }

        pub fn topline(self: *Self, line: u32) void {
            return c.Fl_Browser_topline(@ptrCast(self.inner), line);
        }

        pub fn bottomline(self: *Self, line: u32) void {
            return c.Fl_Browser_bottomline(@ptrCast(self.inner), line);
        }

        pub fn middleline(self: *Self, line: u32) void {
            return c.Fl_Browser_middleline(@ptrCast(self.inner), line);
        }

        pub fn formatChar(self: *Self) u8 {
            return c.Fl_Browser_format_char(@ptrCast(self.inner));
        }

        pub fn setFormatChar(self: *Self, char: u8) void {
            return c.Fl_Browser_set_format_char(@ptrCast(self.inner), char);
        }

        pub fn columnChar(self: *Self) u8 {
            return c.Fl_Browser_column_char(@ptrCast(self.inner));
        }

        pub fn setColumnChar(self: *Self, char: u8) void {
            return c.Fl_Browser_set_column_char(@ptrCast(self.inner), char);
        }

        pub fn setColumnWidths(self: *Self, arr: [:0]const i32) void {
            return c.Fl_Browser_set_column_widths(@ptrCast(self.inner), arr.ptr);
        }

        pub fn displayed(self: *Self, line: u31) bool {
            return c.Fl_Browser_displayed(@ptrCast(self.inner), line) != 0;
        }

        pub fn makeVisible(self: *Self, line: u31) void {
            return c.Fl_Browser_make_visible(@ptrCast(self.inner), line);
        }

        pub fn position(self: *Self) u31 {
            return c.Fl_Browser_position(@ptrCast(self.inner));
        }

        pub fn setPosition(self: *Self, pos: u31) void {
            return c.Fl_Browser_set_position(@ptrCast(self.inner), pos);
        }

        pub fn hposition(self: *Self) u31 {
            return c.Fl_Browser_hposition(@ptrCast(self.inner));
        }

        pub fn setHposition(self: *Self, pos: u31) void {
            return c.Fl_Browser_set_hposition(@ptrCast(self.inner), pos);
        }

        pub fn hasScrollbar(self: *Self) enums.BrowserScrollbar {
            return c.Fl_Browser_has_scrollbar(@ptrCast(self.inner));
        }

        pub fn setHasScrollbar(self: *Self, mode: enums.BrowserScrollbar) void {
            return c.Fl_Browser_set_has_scrollbar(@ptrCast(self.inner), mode);
        }

        pub fn scrollbarSize(self: *Self) u31 {
            return c.Fl_Browser_scrollbar_size(@ptrCast(self.inner));
        }

        pub fn setScrollbarSize(self: *Self, new_size: u31) void {
            return c.Fl_Browser_set_scrollbar_size(@ptrCast(self.inner), new_size);
        }

        pub fn sort(self: *Self) void {
            return c.Fl_Browser_sort(@ptrCast(self.inner));
        }

        pub fn scrollbar(self: *Self) Valuator {
            return .{ .inner = c.Fl_Browser_scrollbar(@ptrCast(self.inner)) };
        }

        pub fn hscrollbar(self: *Self) .Valuator {
            return .{ .inner = c.Fl_Browser_hscrollbar(@ptrCast(self.inner)) };
        }
    };
}

test "all" {
    @import("std").testing.refAllDeclsRecursive(@This());
}
