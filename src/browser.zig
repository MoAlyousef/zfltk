const zfltk = @import("zfltk.zig");
const app = zfltk.app;
const Widget = @import("widget.zig").Widget;
const Valuator = @import("valuator.zig").Valuator;
const enums = @import("enums.zig");
const c = zfltk.c;

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

        pub inline fn raw(self: *const Self) RawPtr {
            return self.inner;
        }

        pub inline fn fromRaw(ptr: RawPtr) Self {
            return .{ .inner = ptr };
        }

        pub inline fn fromWidget(wid: Widget) Self {
            return Self.fromRaw(@ptrCast(RawPtr, wid.inner));
        }

        pub inline fn fromVoidPtr(ptr: *anyopaque) Self {
            return .{ .inner = @ptrCast(RawPtr, ptr) };
        }

        pub inline fn toVoidPtr(self: *const Self) *anyopaque {
            return @ptrCast(*anyopaque, self.inner);
        }

        pub inline fn widget(self: *const Self) Widget {
            return Widget.fromRaw(@ptrCast(Widget.RawPtr, self.inner));
        }

        pub fn handle(self: *const Self, cb: fn (w: widget.WidgetPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
            c.Fl_Browser_handle(self.browser(), @ptrCast(c.custom_handler_callback, cb), data);
        }

        pub fn draw(self: *const Self, cb: fn (w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
            c.Fl_Browser_handle(@ptrCast(BrowserRawPtr, self.inner), @ptrCast(c.custom_draw_callback, cb), data);
        }

        pub fn remove(self: *const Self, line: u32) void {
            return c.Fl_Browser_remove(@ptrCast(BrowserRawPtr, self.inner), line);
        }

        pub fn add(self: *const Self, item: [:0]const u8) void {
            return c.Fl_Browser_add(@ptrCast(BrowserRawPtr, self.inner), item.ptr);
        }

        pub fn insert(self: *const Self, line: u32, item: [:0]const u8) void {
            return c.Fl_Browser_insert(@ptrCast(BrowserRawPtr, self.inner), line, item.ptr);
        }

        pub fn moveItem(self: *const Self, to: u32, from: u32) void {
            return c.Fl_Browser_move_item(@ptrCast(BrowserRawPtr, self.inner), to, from);
        }

        pub fn swap(self: *const Self, a: u32, b: u32) void {
            return c.Fl_Browser_swap(@ptrCast(BrowserRawPtr, self.inner), a, b);
        }

        pub fn clear(self: *const Self) void {
            return c.Fl_Browser_clear(@ptrCast(BrowserRawPtr, self.inner));
        }

        pub fn size(self: *const Self) u32 {
            return c.Fl_Browser_size(@ptrCast(BrowserRawPtr, self.inner));
        }

        pub fn setSize(self: *const Self, w: i32, h: i32) void {
            return c.Fl_Browser_set_size(@ptrCast(BrowserRawPtr, self.inner), w, h);
        }

        pub fn select(self: *const Self, line: u32) void {
            if (line <= self.size()) return c.Fl_Browser_select(@ptrCast(BrowserRawPtr, self.inner), line);
        }

        pub fn selected(self: *const Self, line: u32) bool {
            return c.Fl_Browser_selected(@ptrCast(BrowserRawPtr, self.inner), line) != 0;
        }

        pub fn text(self: *const Self, line: u32) [:0]const u8 {
            return c.Fl_Browser_text(@ptrCast(BrowserRawPtr, self.inner), line);
        }

        pub fn setText(self: *const Self, line: u32, txt: [*c]const u8) void {
            return c.Fl_Browser_set_text(@ptrCast(BrowserRawPtr, self.inner), line, txt);
        }

        pub fn load(self: *const Self, path: [*c]const u8) void {
            return c.Fl_Browser_load_file(@ptrCast(BrowserRawPtr, self.inner), path);
        }

        pub fn textSize(self: *const Self) u32 {
            return c.Fl_Browser_text_size(@ptrCast(BrowserRawPtr, self.inner));
        }

        pub fn setTextSize(self: *const Self, val: u32) void {
            return c.Fl_Browser_set_text_size(@ptrCast(BrowserRawPtr, self.inner), val);
        }

        pub fn topline(self: *const Self, line: u32) void {
            return c.Fl_Browser_topline(@ptrCast(BrowserRawPtr, self.inner), line);
        }

        pub fn bottomline(self: *const Self, line: u32) void {
            return c.Fl_Browser_bottomline(@ptrCast(BrowserRawPtr, self.inner), line);
        }

        pub fn middleline(self: *const Self, line: u32) void {
            return c.Fl_Browser_middleline(@ptrCast(BrowserRawPtr, self.inner), line);
        }

        pub fn formatChar(self: *const Self) u8 {
            return c.Fl_Browser_format_char(@ptrCast(BrowserRawPtr, self.inner));
        }

        pub fn setFormatChar(self: *const Self, char: u8) void {
            return c.Fl_Browser_set_format_char(@ptrCast(BrowserRawPtr, self.inner), char);
        }

        pub fn columnChar(self: *const Self) u8 {
            return c.Fl_Browser_column_char(@ptrCast(BrowserRawPtr, self.inner));
        }

        pub fn setColumnChar(self: *const Self, char: u8) void {
            return c.Fl_Browser_set_column_char(@ptrCast(BrowserRawPtr, self.inner), char);
        }

        pub fn setColumnWidths(self: *const Self, arr: [:0]const i32) void {
            return c.Fl_Browser_set_column_widths(@ptrCast(BrowserRawPtr, self.inner), arr.ptr);
        }

        pub fn displayed(self: *const Self, line: u31) bool {
            return c.Fl_Browser_displayed(@ptrCast(BrowserRawPtr, self.inner), line) != 0;
        }

        pub fn makeVisible(self: *const Self, line: u31) void {
            return c.Fl_Browser_make_visible(@ptrCast(BrowserRawPtr, self.inner), line);
        }

        pub fn position(self: *const Self) u31 {
            return c.Fl_Browser_position(@ptrCast(BrowserRawPtr, self.inner));
        }

        pub fn setPosition(self: *const Self, pos: u31) void {
            return c.Fl_Browser_set_position(@ptrCast(BrowserRawPtr, self.inner), pos);
        }

        pub fn hposition(self: *const Self) u31 {
            return c.Fl_Browser_hposition(@ptrCast(BrowserRawPtr, self.inner));
        }

        pub fn setHposition(self: *const Self, pos: u31) void {
            return c.Fl_Browser_set_hposition(@ptrCast(BrowserRawPtr, self.inner), pos);
        }

        pub fn hasScrollbar(self: *const Self) enums.BrowserScrollbar {
            return c.Fl_Browser_has_scrollbar(@ptrCast(BrowserRawPtr, self.inner));
        }

        pub fn setHasScrollbar(self: *const Self, mode: enums.BrowserScrollbar) void {
            return c.Fl_Browser_set_has_scrollbar(@ptrCast(BrowserRawPtr, self.inner), mode);
        }

        pub fn scrollbarSize(self: *const Self) u31 {
            return c.Fl_Browser_scrollbar_size(@ptrCast(BrowserRawPtr, self.inner));
        }

        pub fn setScrollbarSize(self: *const Self, new_size: u31) void {
            return c.Fl_Browser_set_scrollbar_size(@ptrCast(BrowserRawPtr, self.inner), new_size);
        }

        pub fn sort(self: *const Self) void {
            return c.Fl_Browser_sort(@ptrCast(BrowserRawPtr, self.inner));
        }

        pub fn scrollbar(self: *const Self) Valuator {
            return .{ .inner = c.Fl_Browser_scrollbar(@ptrCast(BrowserRawPtr, self.inner)) };
        }

        pub fn hscrollbar(self: *const Self) .Valuator {
            return .{ .inner = c.Fl_Browser_hscrollbar(@ptrCast(BrowserRawPtr, self.inner)) };
        }
    };
}

test "all" {
    @import("std").testing.refAllDecls(@This());
}
