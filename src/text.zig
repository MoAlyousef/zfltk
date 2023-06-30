const zfltk = @import("zfltk.zig");
const app = zfltk.app;
const Widget = zfltk.Widget;
const enums = zfltk.enums;
const c = zfltk.c;

pub const StyleTableEntry = struct {
    /// Font color
    color: enums.Color,
    /// Font type
    font: enums.Font,
    /// Font size
    size: i32,
};

pub const TextKind = enum {
    normal,
    editor,
};

pub const TextBuffer = struct {
    const Self = @This();

    pub usingnamespace zfltk.widget.methods(TextBuffer, RawPtr);

    pub const RawPtr = *c.Fl_Text_Buffer;

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
    pub fn setText(self: *TextBuffer, txt: [*]const u8) void {
        return c.Fl_Text_Buffer_set_text(self.raw(), txt);
    }

    /// Returns the text of the buffer
    pub fn text(self: *const TextBuffer) [*]const u8 {
        return c.Fl_Text_Buffer_txt(self.raw());
    }

    /// Appends to the buffer
    pub fn append(self: *const TextBuffer, str: [*]const u8) void {
        return c.Fl_Text_Buffer_append(self.raw(), str);
    }

    /// Get the length of the buffer
    pub fn length(self: *TextBuffer) u31 {
        return @intCast(c.Fl_Text_Buffer_length(self.raw()));
    }

    /// Removes from the buffer
    pub fn remove(self: *const TextBuffer, start: u32, end: u32) void {
        return c.Fl_Text_Buffer_remove(self.raw(), start, end);
    }
    /// Returns the text within the range
    pub fn textRange(self: *const TextBuffer, start: u32, end: u32) [*]const u8 {
        return c.Fl_Text_Buffer_text_range(self.raw(), start, end);
    }

    /// Inserts text into a position
    pub fn insert(self: *const TextBuffer, pos: u32, str: [*]const u8) void {
        c.Fl_Text_Buffer_insert(self.raw(), pos, str.as_ptr());
    }

    /// Replaces text from position ```start``` to ```end```
    pub fn replace(self: *const TextBuffer, start: u32, end: u32, txt: [*]const u8) void {
        c.Fl_Text_Buffer_replace(self.raw(), start, end, txt);
    }

    /// Copies text from a source buffer into the current buffer
    pub fn copyFrom(self: *TextBuffer, source_buf: *TextBuffer, start: u31, end: u31, to: u31) void {
        c.Fl_Text_Buffer_copy(
            self.raw(),
            source_buf.raw(),
            start,
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
    pub fn undo(self: *const TextBuffer) void {
        _ = c.Fl_Text_Buffer_undo(self.raw(), null);
    }

    /// Sets whether the buffer can undo
    pub fn canUndo(self: *const TextBuffer, flag: bool) void {
        c.Fl_Text_Buffer_canUndo(self.raw(), @intFromBool(flag));
    }

    pub fn lineStart(self: *const TextBuffer, pos: u32) u32 {
        return c.Fl_Text_Buffer_line_start(self.raw(), pos);
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
    pub fn tabDistance(self: *const TextBuffer) u32 {
        c.Fl_Text_Buffer_tab_distance(self.raw());
    }

    /// Sets the tab distance
    pub fn setTabDistance(self: *TextBuffer, tab_dist: u32) void {
        c.Fl_Text_Buffer_set_tab_distance(self.raw(), tab_dist);
    }

    /// Selects the text from start to end
    pub fn select(self: *TextBuffer, start: u32, end: u32) void {
        c.Fl_Text_Buffer_select(self.raw(), start, end);
    }

    /// Returns whether text is selected
    pub fn selected(self: *const TextBuffer) bool {
        return c.Fl_Text_Buffer_selected(self.raw()) != 0;
    }

    /// Unselects text
    pub fn unselect(self: *const TextBuffer) void {
        return c.Fl_Text_Buffer_unselect(self.raw());
    }
};

pub fn TextDisplay(comptime kind: TextKind) type {
    return struct {
        const Self = @This();

        // Expose methods from `inherited` structs
        pub usingnamespace zfltk.widget.methods(Self, RawPtr);
        pub usingnamespace methods(Self);

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
                var self = Self.fromRaw(ptr);

                if (opts.buffer) {
                    var buf = try TextBuffer.init();
                    self.setBuffer(buf);
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

        pub fn handle(self: *const Self, cb: fn (w: Widget.RawPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
            c.Fl_Text_Display_handle(self.raw(), @ptrCast(cb), data);
        }

        pub fn draw(self: *const TextDisplay, cb: fn (w: Widget.RawPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
            c.Fl_Text_Display_handle(self.raw(),  @ptrCast(cb), data);
        }

    };
}

pub fn methods(comptime Self: type) type {
    return struct {
        pub inline fn textDisplay(self: *Self) *TextDisplay(.normal) {
            return @ptrCast(self);
        }

        pub inline fn buffer(self: *Self) ?*TextBuffer {
            if (c.Fl_Text_Display_get_buffer(self.textDisplay().raw())) |ptr| {
                return TextBuffer.fromRaw(ptr);
            }

            return null;
        }

        pub inline fn styleBuffer(self: *Self) ?TextBuffer {
            if (c.Fl_Text_Display_get_style_buffer(self.textDisplay().raw())) |ptr| {
                return TextBuffer.fromRaw(ptr);
            }
        }

        pub inline fn setBuffer(self: *Self, buf: *TextBuffer) void {
            c.Fl_Text_Display_set_buffer(self.textDisplay().textDisplay().raw(), buf.raw());
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
                colors[i] =  @bitCast(e.color);
                fonts[i] = @intFromEnum(e.font);
                fontszs[i] = e.size;
                attrs[i] = 0;
                bgcolors[i] = 0;
                i += 1;
            }
            c.Fl_Text_Display_set_highlight_data(self.textDisplay().raw(), sbuf.*.inner, &colors, &fonts, &fontszs, &attrs, &bgcolors,  @intCast(sz));
        }

        pub fn setTextFont(self: *Self, font: enums.Font) void {
            c.Fl_Text_Display_set_text_font(self.textDisplay().raw(), @intFromEnum(font));
        }

        pub fn setTextColor(self: *Self, col: enums.Color) void {
            c.Fl_Text_Display_set_text_color(self.textDisplay().raw(), col.inner());
        }

        pub fn setTextSize(self: *Self, sz: i32) void {
            c.Fl_Text_Display_set_text_size(self.textDisplay().raw(), sz);
        }

        pub fn scroll(self: *Self, topLineNum: i32, horizOffset: i32) void {
            c.Fl_Text_Display_scroll(self.textDisplay().raw(), topLineNum, horizOffset);
        }

        pub fn insert(self: *Self, text: [*c]const u8) void {
            c.Fl_Text_Display_insert(self.textDisplay().raw(), text);
        }

        pub fn setInsertPosition(self: *Self, newPos: u32) void {
            c.Fl_Text_Display_set_insert_position(self.textDisplay().raw(), newPos);
        }

        pub fn insertPosition(self: *Self) u32 {
            return c.Fl_Text_Display_insert_position(self.textDisplay().raw());
        }

        pub fn countLines(self: *Self, start: u32, end: u32, is_line_start: bool) u32 {
            return c.Fl_Text_Display_count_lines(self.textDisplay().raw(), start, end, @intFromBool(is_line_start));
        }

        pub fn moveRight(self: *Self) void {
            _ = c.Fl_Text_Display_move_right(self.textDisplay().raw());
        }

        pub fn moveLeft(self: *Self) void {
            _ = c.Fl_Text_Display_move_left(self.textDisplay().raw());
        }

        pub fn moveUp(self: *Self) void {
            _ = c.Fl_Text_Display_move_up(self.textDisplay().raw());
        }

        pub fn moveDown(self: *Self) void {
            _ = c.Fl_Text_Display_move_down(self.textDisplay().raw());
        }

        pub fn showCursor(self: *Self, val: bool) void {
            c.Fl_Text_Display_show_cursor(self.textDisplay().raw(), @intFromBool(val));
        }

        pub fn setCursorStyle(self: *Self, style: enums.TextCursor) void {
            c.Fl_Text_Display_set_cursor_style(self.textDisplay().raw(), @intFromEnum(style));
        }

        pub fn setCursorColor(self: *Self, col: enums.Color) void {
            c.Fl_Text_Display_set_cursor_color(self.textDisplay().raw(), col.inner());
        }

        pub fn setScrollbarSize(self: *Self, size: u32) void {
            c.Fl_Text_Display_set_scrollbar_size(self.textDisplay().raw(), size);
        }

        pub fn setScrollbarAlign(self: *Self, a: i32) void {
            c.Fl_Text_Display_set_scrollbar_align(self.textDisplay().raw(), a);
        }

        pub fn setLinenumberWidth(self: *Self, w: i32) void {
            c.Fl_Text_Display_set_linenumber_width(self.textDisplay().raw(), w);
        }

        // Text editor only methods
        pub fn cut(self: *TextDisplay(.editor)) void {
            _ = c.Fl_Text_Editor_kf_cut(self.raw());
        }

        pub fn paste(self: *TextDisplay(.editor)) void {
            _ = c.Fl_Text_Editor_kf_paste(self.raw());
        }

        pub fn copy(self: *TextDisplay(.editor)) void {
            _ = c.Fl_Text_Editor_kf_copy(self.raw());
        }
    };
}

test "all" {
    @import("std").testing.refAllDecls(@This());
}
