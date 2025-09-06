const zfltk = @import("zfltk.zig");
const app = zfltk.app;
const Widget = @import("widget.zig").Widget;
const ScrollVal = struct { inner: ?*c.Fl_Scrollbar };
const enums = @import("enums.zig");
const c = zfltk.c;
const std = @import("std");

pub const Browser = BrowserType(.normal);
pub const SelectBrowser = BrowserType(.select);
pub const HoldBrowser = BrowserType(.hold);
pub const MultiBrowser = BrowserType(.multi);
pub const FileBrowser = BrowserType(.file);

const BrowserKind = enum {
    normal,
    select,
    hold,
    multi,
    file,
};

fn BrowserType(comptime kind: BrowserKind) type {
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

        // Namespaced widget methods (Zig 0.15.1 no usingnamespace)
        pub const widget_ns = zfltk.widget.methods(Self, RawPtr);
        pub inline fn widget_methods(self: *Self) zfltk.widget.MethodsProxy(Self, RawPtr) { return .{ .self = self }; }
        pub inline fn widget(self: *Self) *Widget { return widget_ns.widget(self); }
        pub inline fn raw(self: *Self) RawPtr { return widget_ns.raw(self); }
        pub inline fn fromRaw(ptr: *anyopaque) *Self { return widget_ns.fromRaw(ptr); }

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
                return Self.fromRaw(ptr);
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

            deinit_func(self.raw());
        }

        pub fn remove(self: *Self, line: u32) void {
            return c.Fl_Browser_remove(@ptrCast(self.raw()), @as(c_int, @intCast(line)));
        }

        pub fn add(self: *Self, item: [:0]const u8) void {
            return c.Fl_Browser_add(@ptrCast(self.raw()), item.ptr);
        }

        pub fn insert(self: *Self, line: u32, item: [:0]const u8) void {
            return c.Fl_Browser_insert(@ptrCast(self.raw()), @as(c_int, @intCast(line)), item.ptr);
        }

        // move_item/swap are not available in cfltk headers in some builds; omit wrappers

        pub fn clear(self: *Self) void {
            return c.Fl_Browser_clear(@ptrCast(self.raw()));
        }

        pub fn size(self: *Self) i32 {
            return c.Fl_Browser_size(@ptrCast(self.raw()));
        }

        pub fn setSize(self: *Self, w: i32, h: i32) void {
            return c.Fl_Browser_set_size(@ptrCast(self.raw()), w, h);
        }

        pub fn select(self: *Self, line: u32) void {
            if (line <= self.size()) return c.Fl_Browser_select(@ptrCast(self.raw()), @as(c_int, @intCast(line)));
        }

        pub fn selected(self: *Self, line: u32) bool {
            return c.Fl_Browser_selected(@ptrCast(self.raw()), @as(c_int, @intCast(line))) != 0;
        }

        pub fn text(self: *Self, line: u32) [:0]const u8 {
            return c.Fl_Browser_text(@ptrCast(self.raw()), @as(c_int, @intCast(line)));
        }

        pub fn setText(self: *Self, line: u32, txt: [*c]const u8) void {
            return c.Fl_Browser_set_text(@ptrCast(self.raw()), @as(c_int, @intCast(line)), txt);
        }

        pub fn load(self: *Self, path: [*c]const u8) void {
            return c.Fl_Browser_load_file(@ptrCast(self.raw()), path);
        }

        pub fn textSize(self: *Self) u32 {
            return c.Fl_Browser_text_size(@ptrCast(self.raw()));
        }

        pub fn setTextSize(self: *Self, val: u32) void {
            return c.Fl_Browser_set_text_size(@ptrCast(self.raw()), val);
        }

        pub fn topline(self: *Self, line: u32) void {
            return c.Fl_Browser_topline(@ptrCast(self.raw()), @as(c_int, @intCast(line)));
        }

        pub fn bottomline(self: *Self, line: u32) void {
            return c.Fl_Browser_bottomline(@ptrCast(self.raw()), @as(c_int, @intCast(line)));
        }

        pub fn middleline(self: *Self, line: u32) void {
            return c.Fl_Browser_middleline(@ptrCast(self.raw()), @as(c_int, @intCast(line)));
        }

        pub fn formatChar(self: *Self) u8 {
            return c.Fl_Browser_format_char(@ptrCast(self.raw()));
        }

        pub fn setFormatChar(self: *Self, char: u8) void {
            return c.Fl_Browser_set_format_char(@ptrCast(self.raw()), char);
        }

        pub fn columnChar(self: *Self) u8 {
            return c.Fl_Browser_column_char(@ptrCast(self.raw()));
        }

        pub fn setColumnChar(self: *Self, char: u8) void {
            return c.Fl_Browser_set_column_char(@ptrCast(self.raw()), char);
        }

        pub fn setColumnWidths(self: *Self, arr: [:0]const i32) void {
            return c.Fl_Browser_set_column_widths(@ptrCast(self.raw()), arr.ptr);
        }

        pub fn displayed(self: *Self, line: u31) bool {
            return c.Fl_Browser_displayed(@ptrCast(self.raw()), line) != 0;
        }

        pub fn makeVisible(self: *Self, line: u31) void {
            return c.Fl_Browser_make_visible(@ptrCast(self.raw()), @as(c_int, @intCast(line)));
        }

        pub fn position(self: *Self) u31 {
            return c.Fl_Browser_position(@ptrCast(self.raw()));
        }

        pub fn setPosition(self: *Self, pos: u31) void {
            return c.Fl_Browser_set_position(@ptrCast(self.raw()), pos);
        }

        pub fn hposition(self: *Self) u31 {
            return c.Fl_Browser_hposition(@ptrCast(self.raw()));
        }

        pub fn setHposition(self: *Self, pos: u31) void {
            return c.Fl_Browser_set_hposition(@ptrCast(self.raw()), pos);
        }

        pub fn hasScrollbar(self: *Self) enums.BrowserScrollbar {
            return c.Fl_Browser_has_scrollbar(@ptrCast(self.raw()));
        }

        pub fn setHasScrollbar(self: *Self, mode: enums.BrowserScrollbar) void {
            return c.Fl_Browser_set_has_scrollbar(@ptrCast(self.raw()), mode);
        }

        pub fn scrollbarSize(self: *Self) u31 {
            return c.Fl_Browser_scrollbar_size(@ptrCast(self.raw()));
        }

        pub fn setScrollbarSize(self: *Self, new_size: u31) void {
            return c.Fl_Browser_set_scrollbar_size(@ptrCast(self.raw()), new_size);
        }

        pub fn sort(self: *Self) void {
            return c.Fl_Browser_sort(@ptrCast(self.raw()));
        }

        pub fn scrollbar(self: *Self) ScrollVal {
            return .{ .inner = c.Fl_Browser_scrollbar(@ptrCast(self.raw())) };
        }

        pub fn hscrollbar(self: *Self) ScrollVal {
            return .{ .inner = c.Fl_Browser_hscrollbar(@ptrCast(self.raw())) };
        }
    };
}

test "all" {
    @import("std").testing.refAllDeclsRecursive(@This());
}
