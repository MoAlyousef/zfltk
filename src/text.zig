const c = @cImport({
    @cInclude("cfl_text.h");
});
const widget = @import("widget.zig");
const enums = @import("enums.zig");

pub const StyleTableEntry = struct {
    /// Font color
    color: enums.Color,
    /// Font type
    font: enums.Font,
    /// Font size
    size: i32,
};

pub const TextBuffer = struct {
    inner: ?*c.Fl_Text_Buffer,
    pub fn new() TextBuffer {
        return TextBuffer{
            .inner = c.Fl_Text_Buffer_new(),
        };
    }

    pub fn fromVoidPtr(ptr: ?*anyopaque) TextBuffer {
        return TextBuffer{
            .inner = @ptrCast(?*c.Fl_Text_Buffer, ptr),
        };
    }

    pub fn toVoidPtr(self: *const TextBuffer) ?*anyopaque {
        return @ptrCast(?*anyopaque, self.inner);
    }

    pub fn delete(self: *const TextBuffer) void {
        c.Fl_Text_Buffer_delete(self.inner);
    }

    /// Sets the text of the buffer
    pub fn setText(self: *const TextBuffer, txt: [*c]const u8) void {
        return c.Fl_Text_Buffer_set_text(self.inner, txt);
    }

    /// Returns the text of the buffer
    pub fn text(self: *const TextBuffer) [*c]const u8 {
        return c.Fl_Text_Buffer_txt(self.inner);
    }

    /// Appends to the buffer
    pub fn append(self: *const TextBuffer, str: [*c]const u8) void {
        return c.Fl_Text_Buffer_append(self.inner, str);
    }

    /// Get the length of the buffer
    pub fn length(self: *const TextBuffer) u32 {
        return c.Fl_Text_Buffer_length(self.inner);
    }

    /// Removes from the buffer
    pub fn remove(self: *const TextBuffer, start: u32, end: u32) void {
        return c.Fl_Text_Buffer_remove(self.inner, start, end);
    }
    /// Returns the text within the range
    pub fn textRange(self: *const TextBuffer, start: u32, end: u32) [*c]const u8 {
        return c.Fl_Text_Buffer_text_range(self.inner, start, end);
    }

    /// Inserts text into a position
    pub fn insert(self: *const TextBuffer, pos: u32, str: [*c]const u8) void {
        c.Fl_Text_Buffer_insert(self.inner, pos, str.as_ptr());
    }

    /// Replaces text from position ```start``` to ```end```
    pub fn replace(self: *const TextBuffer, start: u32, end: u32, txt: [*c]const u8) void {
        c.Fl_Text_Buffer_replace(self.inner, start, end, txt);
    }

    /// Copies text from a source buffer into the current buffer
    pub fn copyFrom(self: *const TextBuffer, source_buf: *TextBuffer, start: u32, end: u32, to: u32) void {
        c.Fl_Text_Buffer_copy(
            self.inner,
            source_buf.inner,
            start,
            end,
            to,
        );
    }

    /// Copies whole text from a source buffer into a new buffer
    pub fn copy(self: *const TextBuffer) TextBuffer {
        var temp = TextBuffer.new();
        temp.copy_from(self, 0, 0, self.length());
    }

    /// Performs an undo operation on the buffer
    pub fn undo(self: *const TextBuffer) void {
        _ = c.Fl_Text_Buffer_undo(self.inner, null);
    }

    /// Sets whether the buffer can undo
    pub fn canUndo(self: *const TextBuffer, flag: bool) void {
        c.Fl_Text_Buffer_canUndo(self.inner, @boolToInt(flag));
    }

    pub fn lineStart(self: *const TextBuffer, pos: u32) u32 {
        return c.Fl_Text_Buffer_line_start(self.inner, pos);
    }
    /// Loads a file into the buffer
    pub fn loadFile(self: *const TextBuffer, path: [*c]const u8) !void {
        const ret = c.Fl_Text_Buffer_load_file(self.inner, path);
        if (ret != 0) return error.InvalidParameter;
    }

    /// Saves a buffer into a file
    pub fn saveFile(self: *const TextBuffer, path: [*c]const u8) !void {
        const ret = c.Fl_Text_Buffer_save_file(self.inner, path);
        if (ret != 0) return error.InvalidParameter;
    }

    /// Returns the tab distance for the buffer
    pub fn tabDistance(self: *const TextBuffer) u32 {
        c.Fl_Text_Buffer_tab_distance(self.inner);
    }

    /// Sets the tab distance
    pub fn setTabDistance(self: *const TextBuffer, tab_dist: u32) void {
        c.Fl_Text_Buffer_set_tab_distance(self.inner, tab_dist);
    }

    /// Selects the text from start to end
    pub fn select(self: *const TextBuffer, start: u32, end: u32) void {
        c.Fl_Text_Buffer_select(self.inner, start, end);
    }

    /// Returns whether text is selected
    pub fn selected(self: *const TextBuffer) bool {
        return c.Fl_Text_Buffer_selected(self.inner) != 0;
    }

    /// Unselects text
    pub fn unselect(self: *const TextBuffer) void {
        return c.Fl_Text_Buffer_unselect(self.inner);
    }
};

pub const TextDisplay = struct {
    inner: ?*c.Fl_Text_Display,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) TextDisplay {
        const ptr = c.Fl_Text_Display_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return TextDisplay{
            .inner = ptr,
        };
    }

    pub fn raw(self: *const TextDisplay) ?*c.Fl_Text_Display {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Text_Display) TextDisplay {
        return TextDisplay{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) TextDisplay {
        return TextDisplay{
            .inner = @ptrCast(?*c.Fl_Text_Display, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*anyopaque) TextDisplay {
        return TextDisplay{
            .inner = @ptrCast(?*c.Fl_Text_Display, ptr),
        };
    }

    pub fn toVoidPtr(self: *const TextDisplay) ?*anyopaque {
        return @ptrCast(?*anyopaque, self.inner);
    }

    pub fn asWidget(self: *const TextDisplay) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn handle(self: *const TextDisplay, cb: fn (w: widget.WidgetPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
        c.Fl_Text_Display_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *const TextDisplay, cb: fn (w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Text_Display_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }

    pub fn buffer(self: *const TextDisplay) TextBuffer {
        const buf = c.Fl_Text_Display_get_buffer(self.inner);
        return TextBuffer{ .inner = buf };
    }

    pub fn styleBuffer(self: *const TextDisplay) TextBuffer {
        const buf = c.Fl_Text_Display_get_style_buffer(self.inner);
        return TextBuffer{ .inner = buf };
    }

    pub fn setBuffer(self: *const TextDisplay, buf: *TextBuffer) void {
        c.Fl_Text_Display_set_buffer(self.inner, buf.*.inner);
    }

    pub fn setHighlightData(self: *const TextDisplay, sbuf: *TextBuffer, entries: []const StyleTableEntry) void {
        const sz = entries.len;
        var colors: [28]c_uint = undefined;
        var fonts: [28]i32 = undefined;
        var fontszs: [28]i32 = undefined;
        var attrs: [28]c_uint = undefined;
        var bgcolors: [28]c_uint = undefined;
        var i: usize = 0;
        for (entries) |e| {
            colors[i] = @bitCast(c_uint, e.color);
            fonts[i] = @enumToInt(e.font);
            fontszs[i] = e.size;
            attrs[i] = 0;
            bgcolors[i] = 0;
            i += 1;
        }
        c.Fl_Text_Display_set_highlight_data(self.inner, sbuf.*.inner, &colors, &fonts, &fontszs, &attrs, &bgcolors, @intCast(i32, sz));
    }

    pub fn setTextFont(self: *const TextDisplay, font: enums.Font) void {
        c.Fl_Text_Display_set_text_font(self.inner, @enumToInt(font));
    }

    pub fn setTextColor(self: *const TextDisplay, col: enums.Color) void {
        c.Fl_Text_Display_set_text_color(self.inner, col.inner());
    }

    pub fn setTextSize(self: *const TextDisplay, sz: i32) void {
        c.Fl_Text_Display_set_text_size(self.inner, sz);
    }

    pub fn scroll(self: *const TextDisplay, topLineNum: i32, horizOffset: i32) void {
        c.Fl_Text_Display_scroll(self.inner, topLineNum, horizOffset);
    }

    pub fn insert(self: *const TextDisplay, text: [*c]const u8) void {
        c.Fl_Text_Display_insert(self.inner, text);
    }

    pub fn setInsertPosition(self: *const TextDisplay, newPos: u32) void {
        c.Fl_Text_Display_set_insert_position(self.inner, newPos);
    }

    pub fn insertPosition(self: *const TextDisplay) u32 {
        return c.Fl_Text_Display_insert_position(self.inner);
    }

    pub fn countLines(self: *const TextDisplay, start: u32, end: u32, is_line_start: bool) u32 {
        return c.Fl_Text_Display_count_lines(self.inner, start, end, @boolToInt(is_line_start));
    }

    pub fn moveRight(self: *const TextDisplay) void {
        _ = c.Fl_Text_Display_move_right(self.inner);
    }

    pub fn moveLeft(self: *const TextDisplay) void {
        _ = c.Fl_Text_Display_move_left(self.inner);
    }

    pub fn moveUp(self: *const TextDisplay) void {
        _ = c.Fl_Text_Display_move_up(self.inner);
    }

    pub fn moveDown(self: *const TextDisplay) void {
        _ = c.Fl_Text_Display_move_down(self.inner);
    }

    pub fn showCursor(self: *const TextDisplay, val: bool) void {
        c.Fl_Text_Display_show_cursor(self.inner, @boolToInt(val));
    }

    pub fn setCursorStyle(self: *const TextDisplay, style: enums.TextCursor) void {
        c.Fl_Text_Display_set_cursor_style(self.inner, @enumToInt(style));
    }

    pub fn setCursorColor(self: *const TextDisplay, col: enums.Color) void {
        c.Fl_Text_Display_set_cursor_color(self.inner, col.inner());
    }

    pub fn setScrollbarSize(self: *const TextDisplay, size: u32) void {
        c.Fl_Text_Display_set_scrollbar_size(self.inner, size);
    }

    pub fn setScrollbarAlign(self: *const TextDisplay, a: i32) void {
        c.Fl_Text_Display_set_scrollbar_align(self.inner, a);
    }

    pub fn setLinenumberWidth(self: *const TextDisplay, w: i32) void {
        c.Fl_Text_Display_set_linenumber_width(self.inner, w);
    }
};

pub const TextEditor = struct {
    inner: ?*c.Fl_Text_Editor,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) TextEditor {
        const ptr = c.Fl_Text_Editor_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return TextEditor{
            .inner = ptr,
        };
    }

    pub fn raw(self: *const TextEditor) ?*c.Fl_Text_Editor {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Text_Editor) TextEditor {
        return TextEditor{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) TextEditor {
        return TextEditor{
            .inner = @ptrCast(?*c.Fl_Text_Editor, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*anyopaque) TextEditor {
        return TextEditor{
            .inner = @ptrCast(?*c.Fl_Text_Editor, ptr),
        };
    }

    pub fn toVoidPtr(self: *const TextEditor) ?*anyopaque {
        return @ptrCast(?*anyopaque, self.inner);
    }

    pub fn asWidget(self: *const TextEditor) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asTextDisplay(self: *const TextEditor) TextDisplay {
        return TextDisplay{
            .inner = @ptrCast(?*c.Fl_Text_Display, self.inner),
        };
    }

    pub fn handle(self: *const TextEditor, cb: fn (w: widget.WidgetPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
        c.Fl_Text_Editor_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *const TextEditor, cb: fn (w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Text_Editor_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }

    /// Copies the text within the TextEditor widget
    pub fn copy(self: *const TextEditor) void {
        _ = c.Fl_Text_Editor_kf_copy(self.inner);
    }

    /// Cuts the text within the TextEditor widget
    pub fn cut(self: *const TextEditor) void {
        _ = c.Fl_Text_Editor_kf_cut(self.inner);
    }

    /// Pastes text from the clipboard into the TextEditor widget
    pub fn paste(self: *const TextEditor) void {
        _ = c.Fl_Text_Editor_kf_paste(self.inner);
    }
};

test "all" {
    @import("std").testing.refAllDecls(@This());
}
