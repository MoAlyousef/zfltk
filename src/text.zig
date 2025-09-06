const zfltk = @import("zfltk.zig");
const app = zfltk.app;
const Widget = zfltk.Widget;
const enums = zfltk.enums;
const widget = zfltk.widget;
const c = zfltk.c;
const std = @import("std");

pub const StyleTableEntry = struct {
    /// Font color
    color: enums.Color,
    /// Font type
    font: enums.Font,
    /// Font size
    size: i32,
};

const TextKind = enum {
    normal,
    editor,
};

pub const TextDisplay = TextDisplayType(.normal);
pub const TextEditor = TextDisplayType(.editor);

pub const TextBuffer = struct {
    const Self = @This();
    pub const RawPtr = *c.Fl_Text_Buffer;

    pub inline fn raw(self: *Self) RawPtr {
        return @ptrCast(@alignCast(self));
    }
    pub inline fn fromRaw(ptr: *anyopaque) *Self {
        return @ptrCast(ptr);
    }

    pub inline fn init() !*TextBuffer {
        if (c.Fl_Text_Buffer_new()) |ptr| {
            return Self.fromRaw(ptr);
        }

        unreachable;
    }

    pub inline fn deinit(self: *Self) void {
        c.Fl_Text_Buffer_delete(self.raw());
        app.allocator.destroy(self);
    }

    // TODO: find a fast way to implement these methods using slices
    /// Sets the text of the buffer
    pub fn setText(self: *TextBuffer, txt: [:0]const u8) void {
        return c.Fl_Text_Buffer_set_text(self.raw(), txt);
    }

    /// Returns the text of the buffer
    pub fn text(self: *TextBuffer) [:0]const u8 {
        return std.mem.span(c.Fl_Text_Buffer_text(self.raw()));
    }

    /// Appends to the buffer
    pub fn append(self: *TextBuffer, str: [:0]const u8) void {
        return c.Fl_Text_Buffer_append(self.raw(), str);
    }

    /// Get the length of the buffer
    pub fn length(self: *TextBuffer) u31 {
        return @intCast(c.Fl_Text_Buffer_length(self.raw()));
    }

    /// Removes from the buffer
    pub fn remove(self: *TextBuffer, start: u32, end: u32) void {
        return c.Fl_Text_Buffer_remove(self.raw(), @intCast(start), @intCast(end));
    }
    /// Returns the text within the range
    pub fn textRange(self: *TextBuffer, start: u32, end: u32) [:0]const u8 {
        return std.mem.span(c.Fl_Text_Buffer_text_range(self.raw(), @intCast(start), @intCast(end)));
    }

    /// Inserts text into a position
    pub fn insert(self: *TextBuffer, pos: u32, str: [:0]const u8) void {
        c.Fl_Text_Buffer_insert(self.raw(), @intCast(pos), str);
    }

    /// Replaces text from position ```start``` to ```end```
    pub fn replace(self: *TextBuffer, start: u32, end: u32, txt: [:0]const u8) void {
        c.Fl_Text_Buffer_replace(self.raw(), @intCast(start), @intCast(end), txt);
    }

    /// Copies text from a source buffer into the current buffer
    pub fn copyFrom(self: *TextBuffer, source_buf: *TextBuffer, start: u31, end: u31, to: u31) void {
        c.Fl_Text_Buffer_copy(
            self.raw(),
            source_buf.raw(),
            @intCast(start),
            end,
            to,
        );
    }

    /// Copies whole text from a source buffer into a new buffer
    pub fn copy(self: *TextBuffer) !*TextBuffer {
        var temp = try TextBuffer.init();
        temp.copyFrom(self, 0, 0, self.length());
        return temp;
    }

    /// Performs an undo operation on the buffer
    pub fn undo(self: *TextBuffer) void {
        _ = c.Fl_Text_Buffer_undo(self.raw(), null);
    }

    /// Sets whether the buffer can undo
    pub fn canUndo(self: *TextBuffer, flag: bool) void {
        c.Fl_Text_Buffer_canUndo(self.raw(), @intFromBool(flag));
    }

    pub fn lineStart(self: *TextBuffer, pos: u32) u32 {
        return @intCast(c.Fl_Text_Buffer_line_start(self.raw(), @intCast(pos)));
    }
    /// Loads a file into the buffer
    pub fn loadFile(self: *TextBuffer, path: [:0]const u8) !void {
        const ret = c.Fl_Text_Buffer_load_file(self.raw(), path.ptr);
        if (ret != 0) return error.InvalidParameter;
    }

    /// Saves a buffer into a file
    pub fn saveFile(self: *TextBuffer, path: [:0]const u8) !void {
        const ret = c.Fl_Text_Buffer_save_file(self.raw(), path.ptr);
        if (ret != 0) return error.InvalidParameter;
    }

    /// Returns the tab distance for the buffer
    pub fn tabDistance(self: *TextBuffer) u32 {
        return @intCast(c.Fl_Text_Buffer_tab_distance(self.raw()));
    }

    /// Sets the tab distance
    pub fn setTabDistance(self: *TextBuffer, tab_dist: u32) void {
        c.Fl_Text_Buffer_set_tab_distance(self.raw(), @intCast(tab_dist));
    }

    /// Selects the text from start to end
    pub fn select(self: *TextBuffer, start: u32, end: u32) void {
        c.Fl_Text_Buffer_select(self.raw(), @intCast(start), @intCast(end));
    }

    /// Returns whether text is selected
    pub fn selected(self: *TextBuffer) bool {
        return c.Fl_Text_Buffer_selected(self.raw()) != 0;
    }

    /// Unselects text
    pub fn unselect(self: *TextBuffer) void {
        return c.Fl_Text_Buffer_unselect(self.raw());
    }
};

fn TextDisplayType(comptime kind: TextKind) type {
    return struct {
        const Self = @This();

        // Namespaced method sets (Zig 0.15.1 no usingnamespace)
        pub const widget_ns = zfltk.widget.methods(Self, RawPtr);
        pub const own_ns = methods(Self);
        pub inline fn asWidget(self: *Self) zfltk.widget.MethodsProxy(Self, RawPtr) {
            return .{ .self = self };
        }
        pub inline fn asBase(self: *Self) TextMethodsProxy(Self) {
            return .{ .self = self };
        }
        pub inline fn widget(self: *Self) *Widget {
            return widget_ns.widget(self);
        }
        pub inline fn raw(self: *Self) RawPtr {
            return widget_ns.raw(self);
        }
        pub inline fn fromRaw(ptr: *anyopaque) *Self {
            return widget_ns.fromRaw(ptr);
        }

        const TextDisplayRawPtr = *c.Fl_Text_Display;

        pub const RawPtr = switch (kind) {
            .normal => *c.Fl_Text_Display,
            .editor => *c.Fl_Text_Editor,
        };

        pub const Options = struct {
            x: i32 = 0,
            y: i32 = 0,
            w: i32 = 0,
            h: i32 = 0,

            label: ?[:0]const u8 = null,

            // Whether or not to automatically attach a TextBuffer
            buffer: bool = true,
        };

        pub inline fn init(opts: Options) !*Self {
            const initFn = switch (kind) {
                .normal => c.Fl_Text_Display_new,
                .editor => c.Fl_Text_Editor_new,
            };

            const label = if (opts.label != null) opts.label.?.ptr else null;

            if (initFn(opts.x, opts.y, opts.w, opts.h, label)) |ptr| {
                const self = Self.fromRaw(ptr);

                if (opts.buffer) {
                    const buf = try TextBuffer.init();
                    own_ns.setBuffer(self, buf);
                }

                return self;
            }

            unreachable;
        }

        pub inline fn deinit(self: *Self) void {
            const deinitFn = switch (kind) {
                .normal => c.Fl_Text_Display_delete,
                .editor => c.Fl_Text_Editor_delete,
            };

            deinitFn(self.raw());
            app.allocator.destroy(self);
        }
    };
}

fn methods(comptime Self: type) type {
    return struct {
        pub inline fn textDisplay(self: *Self) *TextDisplayType(.normal) {
            return @ptrCast(self);
        }

        pub inline fn buffer(self: *Self) ?*TextBuffer {
            if (c.Fl_Text_Display_get_buffer(textDisplay(self).raw())) |ptr| {
                return TextBuffer.fromRaw(ptr);
            }

            return null;
        }

        pub inline fn styleBuffer(self: *Self) ?*TextBuffer {
            if (c.Fl_Text_Display_get_style_buffer(textDisplay(self).raw())) |ptr| {
                return TextBuffer.fromRaw(ptr);
            }
            return null;
        }

        pub inline fn setBuffer(self: *Self, buf: *TextBuffer) void {
            c.Fl_Text_Display_set_buffer(textDisplay(self).raw(), buf.raw());
        }

        pub fn setHighlightData(self: *Self, sbuf: *TextBuffer, entries: []const StyleTableEntry) void {
            const sz = entries.len;
            var colors: [28]c_uint = undefined;
            var fonts: [28]i32 = undefined;
            var fontszs: [28]i32 = undefined;
            var attrs: [28]c_uint = undefined;
            var bgcolors: [28]c_uint = undefined;
            var i: usize = 0;
            for (entries) |e| {
                colors[i] = @bitCast(e.color);
                fonts[i] = @intFromEnum(e.font);
                fontszs[i] = e.size;
                attrs[i] = 0;
                bgcolors[i] = 0;
                i += 1;
            }
            c.Fl_Text_Display_set_highlight_data(textDisplay(self).raw(), sbuf.raw(), &colors, &fonts, &fontszs, &attrs, &bgcolors, @intCast(sz));
        }

        pub fn setTextFont(self: *Self, font: enums.Font) void {
            c.Fl_Text_Display_set_text_font(textDisplay(self).raw(), @intFromEnum(font));
        }

        pub fn setTextColor(self: *Self, col: enums.Color) void {
            c.Fl_Text_Display_set_text_color(textDisplay(self).raw(), @intCast(col.toRgbi()));
        }

        pub fn setTextSize(self: *Self, sz: i32) void {
            c.Fl_Text_Display_set_text_size(textDisplay(self).raw(), sz);
        }

        pub fn scroll(self: *Self, topLineNum: i32, horizOffset: i32) void {
            c.Fl_Text_Display_scroll(textDisplay(self).raw(), topLineNum, horizOffset);
        }

        pub fn insert(self: *Self, text: [*c]const u8) void {
            c.Fl_Text_Display_insert(textDisplay(self).raw(), text);
        }

        pub fn setInsertPosition(self: *Self, newPos: u32) void {
            c.Fl_Text_Display_set_insert_position(textDisplay(self).raw(), @intCast(newPos));
        }

        pub fn insertPosition(self: *Self) u32 {
            return @intCast(c.Fl_Text_Display_insert_position(textDisplay(self).raw()));
        }

        pub fn countLines(self: *Self, start: u32, end: u32, is_line_start: bool) u32 {
            return @intCast(c.Fl_Text_Display_count_lines(textDisplay(self).raw(), @intCast(start), @intCast(end), @intFromBool(is_line_start)));
        }

        pub fn moveRight(self: *Self) void {
            _ = c.Fl_Text_Display_move_right(textDisplay(self).raw());
        }

        pub fn moveLeft(self: *Self) void {
            _ = c.Fl_Text_Display_move_left(textDisplay(self).raw());
        }

        pub fn moveUp(self: *Self) void {
            _ = c.Fl_Text_Display_move_up(textDisplay(self).raw());
        }

        pub fn moveDown(self: *Self) void {
            _ = c.Fl_Text_Display_move_down(textDisplay(self).raw());
        }

        pub fn showCursor(self: *Self, val: bool) void {
            c.Fl_Text_Display_show_cursor(textDisplay(self).raw(), @intFromBool(val));
        }

        pub fn setCursorStyle(self: *Self, style: enums.TextCursor) void {
            c.Fl_Text_Display_set_cursor_style(textDisplay(self).raw(), @intFromEnum(style));
        }

        pub fn setCursorColor(self: *Self, col: enums.Color) void {
            c.Fl_Text_Display_set_cursor_color(textDisplay(self).raw(), @intCast(col.toRgbi()));
        }

        pub fn setScrollbarSize(self: *Self, size: u32) void {
            c.Fl_Text_Display_set_scrollbar_size(textDisplay(self).raw(), @as(c_int, @intCast(size)));
        }

        pub fn setScrollbarAlign(self: *Self, a: i32) void {
            c.Fl_Text_Display_set_scrollbar_align(textDisplay(self).raw(), a);
        }

        pub fn setLinenumberWidth(self: *Self, w: i32) void {
            c.Fl_Text_Display_set_linenumber_width(textDisplay(self).raw(), w);
        }

        // Text editor only methods
        pub fn cut(self: *TextDisplayType(.editor)) void {
            _ = c.Fl_Text_Editor_kf_cut(self.raw());
        }

        pub fn paste(self: *TextDisplayType(.editor)) void {
            _ = c.Fl_Text_Editor_kf_paste(self.raw());
        }

        pub fn copy(self: *TextDisplayType(.editor)) void {
            _ = c.Fl_Text_Editor_kf_copy(self.raw());
        }
    };
}

pub fn TextMethodsProxy(comptime Self: type) type {
    const TM = methods(Self);
    return struct {
        self: *Self,
        pub inline fn buffer(p: @This()) ?*TextBuffer {
            return TM.buffer(p.self);
        }
        pub inline fn setBuffer(p: @This(), buf: *TextBuffer) void {
            TM.setBuffer(p.self, buf);
        }
        pub inline fn setTextFont(p: @This(), font: enums.Font) void {
            TM.setTextFont(p.self, font);
        }
        pub inline fn setTextColor(p: @This(), col: enums.Color) void {
            TM.setTextColor(p.self, col);
        }
        pub inline fn setTextSize(p: @This(), sz: i32) void {
            TM.setTextSize(p.self, sz);
        }
        pub inline fn scroll(p: @This(), t: i32, h: i32) void {
            TM.scroll(p.self, t, h);
        }
        pub inline fn insert(p: @This(), s: [*c]const u8) void {
            TM.insert(p.self, s);
        }
        pub inline fn setInsertPosition(p: @This(), pos: u32) void {
            TM.setInsertPosition(p.self, pos);
        }
        pub inline fn setLinenumberWidth(p: @This(), w: i32) void {
            TM.setLinenumberWidth(p.self, w);
        }
        pub inline fn showCursor(p: @This(), v: bool) void {
            TM.showCursor(p.self, v);
        }
        pub inline fn cut(p: @This()) void {
            TM.cut(p.self);
        }
        pub inline fn copy(p: @This()) void {
            TM.copy(p.self);
        }
        pub inline fn paste(p: @This()) void {
            TM.paste(p.self);
        }
    };
}

test "all" {
    @import("std").testing.refAllDeclsRecursive(@This());
}
