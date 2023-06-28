const c = @cImport({
    @cInclude("cfl_draw.h");
});
const Font = @import("enums.zig").Font;
const BoxType = @import("enums.zig").BoxType;
const Cursor = @import("enums.zig").Cursor;
const Color = @import("enums.zig").Color;

pub const LineStyle = enum(i32) {
    /// Solid line
    Solid = 0,
    /// Dash
    Dash,
    /// Dot
    Dot,
    /// Dash dot
    DashDot,
    /// Dash dot dot
    DashDotDot,
    /// Cap flat
    CapFlat = 100,
    /// Cap round
    CapRound = 200,
    /// Cap square
    CapSquare = 300,
    /// Join miter
    JoinMiter = 1000,
    /// Join round
    JoinRound = 2000,
    /// Join bevel
    JoinBevel = 3000,
};

/// Opaque type around Fl_Region
pub const Region = ?*anyopaque;

/// Opaque type around Fl_Offscreen
pub const Offscreen = struct {
    inner: ?*anyopaque,
    pub fn new(w: i32, h: i32) Offscreen {
        return Offscreen{ .inner = c.Fl_create_offscreen(w, h) };
    }
    /// Begins drawing in the offscreen
    pub fn begin(self: *const Offscreen) void {
        c.Fl_begin_offscreen(self.inner);
    }

    /// Ends drawing in the offscreen
    pub fn end() void {
        c.Fl_end_offscreen();
    }

    /// Copies the offscreen
    pub fn copy(self: *const Offscreen, x: i32, y: i32, w: i32, h: i32, srcx: i32, srcy: i32) void {
        c.Fl_copy_offscreen(x, y, w, h, self.inner, srcx, srcy);
    }

    /// Rescales the offscreen
    pub fn rescale(self: *const Offscreen) void {
        c.Fl_rescale_offscreen(self.inner);
    }

    pub fn delete(self: *const Offscreen) void {
        c.Fl_delete_offscreen(self._inner);
    }
};

/// Shows a color map and returns the selected color
pub fn showColorMap(old_color: Color) Color {
    return Color.fromRgbi(c.Fl_show_colormap(old_color.toRgbi()));
}

/// Change the draw color
pub fn setColor(col: Color) void {
    c.Fl_set_color_int(col.toRgbi());
}

/// Gets the last used color
pub fn color() Color {
    return Color.fromRbgi(c.Fl_get_color());
}

/// Draws a line
pub fn line(x1: i32, y1: i32, x2: i32, y2: i32) void {
    c.Fl_line(x1, y1, x2, y2);
}

/// Draws a point
pub fn point(x: i32, y: i32) void {
    c.Fl_point(x, y);
}

/// Draws a rectangle
pub fn rect(x: i32, y: i32, w: i32, h: i32) void {
    c.Fl_rect(x, y, w, h);
}

/// Draws a rectangle with border color
pub fn rectWithColor(x: i32, y: i32, w: i32, h: i32, col: Color) void {
    c.Fl_rect_with_color(x, y, w, h, col.toRgbi());
}

/// Draws a non-filled 3-sided polygon
pub fn loop(x1: i32, y1: i32, x2: i32, y2: i32, x3: i32, y3: i32) void {
    c.Fl_loop(x1, y1, x2, y2, x3, y3);
}

/// Draws a filled rectangle
pub fn rectFill(x: i32, y: i32, w: i32, h: i32) void {
    c.Fl_rectf(x, y, w, h);
}

/// Draws a filled rectangle
pub fn rectFillWithColor(x: i32, y: i32, w: i32, h: i32, col: Color) void {
    c.Fl_rectf_with_color(x, y, w, h, col.toRgbi());
}

/// Draws a focus rectangle
pub fn focusRect(x: i32, y: i32, w: i32, h: i32) void {
    c.Fl_focus_rect(x, y, w, h);
}

/// Draws a circle
pub fn circle(x: f64, y: f64, r: f64) void {
    c.Fl_circle(x, y, r);
}

/// Draws an arc
pub fn arc(x: i32, y: i32, w: i32, h: i32, a: f64, b: f64) void {
    c.Fl_arc(x, y, w, h, a, b);
}

/// Draws an arc
pub fn arc2(x: f64, y: f64, r: f64, start: f64, end: f64) void {
    c.Fl_arc2(x, y, r, start, end);
}

/// Draws a filled pie
pub fn pie(x: i32, y: i32, w: i32, h: i32, a: f64, b: f64) void {
    c.Fl_pie(x, y, w, h, a, b);
}

/// Sets the line style
pub fn setLineStyle(style: LineStyle, thickness: i32) void {
    c.Fl_line_style(
        style,
        thickness,
        null,
    );
}

/// Limits drawing to a region
pub fn pushClip(x: i32, y: i32, w: i32, h: i32) void {
    c.Fl_push_clip(x, y, w, h);
}

/// Puts the drawing back
pub fn popClip() void {
    c.Fl_pop_clip();
}

/// Sets the clip region
pub fn setClipRegion(r: Region) void {
    c.Fl_set_clip_region(r);
}

/// Gets the clip region
pub fn clipRegion() Region {
    return c.Fl_clip_region();
}

/// Pushes an empty clip region onto the stack so nothing will be clipped
pub fn pushNoClip() void {
    c.Fl_push_no_clip();
}

/// Returns whether the rectangle intersect with the current clip region
pub fn notClipped(x: i32, y: i32, w: i32, h: i32) bool {
    return c.Fl_not_clipped(x, y, w, h) != 0;
}

/// Restores the clip region
pub fn resoreClip() void {
    c.Fl_restore_clip();
}

/// Transforms coordinate using the current transformation matrix
pub fn transformX(x: f64, y: f64) f64 {
    return c.Fl_transform_x(x, y);
}

/// Transforms coordinate using the current transformation matrix
pub fn transformY(x: f64, y: f64) f64 {
    return c.Fl_transform_y(x, y);
}

/// Transforms distance using current transformation matrix
pub fn transformDX(x: f64, y: f64) f64 {
    return c.Fl_transform_dx(x, y);
}

/// Transforms distance using current transformation matrix
pub fn transformDY(x: f64, y: f64) f64 {
    return c.Fl_transform_dy(x, y);
}

/// Adds coordinate pair to the vertex list without further transformations
pub fn transformedVertex(xf: f64, yf: f64) void {
    c.Fl_transformed_vertex(xf, yf);
}

/// Fills a 3-sided polygon. The polygon must be convex
pub fn polygon(x: i32, y: i32, x1: i32, y1: i32, x2: i32, y2: i32) void {
    c.Fl_polygon(x, y, x1, y1, x2, y2);
}

/// Draws a horizontal line from (x,y) to (x1,y)
// Maybe the API shouldn't be changed? I think this looks better when following
// Zig's conventions though
pub fn lineXY(x: i32, y: i32, x1: i32) void {
    c.Fl_xyline(x, y, x1);
}

/// Draws a horizontal line from (x,y) to (x1,y), then vertical from (x1,y) to (x1,y2)
pub fn lineXY2(x: i32, y: i32, x1: i32, y2: i32) void {
    c.Fl_xyline2(x, y, x1, y2);
}

/// Draws a horizontal line from (x,y) to (x1,y), then a vertical from (x1,y) to (x1,y2)
/// and then another horizontal from (x1,y2) to (x3,y2)
pub fn lineXY3(x: i32, y: i32, x1: i32, y2: i32, x3: i32) void {
    c.Fl_xyline3(x, y, x1, y2, x3);
}

/// Draws a vertical line from (x,y) to (x,y1)
pub fn lineYX(x: i32, y: i32, y1: i32) void {
    c.Fl_yxline(x, y, y1);
}

/// Draws a vertical line from (x,y) to (x,y1), then a horizontal from (x,y1) to (x2,y1)
pub fn lineYX2(x: i32, y: i32, y1: i32, x2: i32) void {
    c.Fl_yxline2(x, y, y1, x2);
}

///  Draws a vertical line from (x,y) to (x,y1) then a horizontal from (x,y1)
/// to (x2,y1), then another vertical from (x2,y1) to (x2,y3)
pub fn lineYX3(x: i32, y: i32, y1: i32, x2: i32, y3: i32) void {
    c.Fl_yxline3(x, y, y1, x2, y3);
}

/// Saves the current transformation matrix on the stack
pub fn pushMatrix() void {
    c.Fl_push_matrix();
}

/// Pops the current transformation matrix from the stack
pub fn popMatrix() void {
    c.Fl_pop_matrix();
}

/// Concatenates scaling transformation onto the current one
pub fn scale(x: f64, y: f64) void {
    c.Fl_scale(x, y);
}

/// Concatenates scaling transformation onto the current one
pub fn scale2(x: f64) void {
    c.Fl_scale2(x);
}

/// Concatenates translation transformation onto the current one
pub fn translate(x: f64, y: f64) void {
    c.Fl_translate(x, y);
}

/// Concatenates rotation transformation onto the current one
pub fn rotate(d: f64) void {
    c.Fl_rotate(d);
}

/// Concatenates another transformation onto the current one
pub fn multMatrix(val_a: f64, val_b: f64, val_c: f64, val_d: f64, x: f64, y: f64) void {
    c.Fl_mult_matrix(val_a, val_b, val_c, val_d, x, y);
}

/// Starts drawing a list of points. Points are added to the list with fl_vertex()
pub fn beginPoints() void {
    c.Fl_begin_points();
}

/// Starts drawing a list of lines
pub fn beginLine() void {
    c.Fl_begin_line();
}

/// Starts drawing a closed sequence of lines
pub fn beginLoop() void {
    c.Fl_begin_loop();
}

/// Starts drawing a convex filled polygon
pub fn beginPolygon() void {
    c.Fl_begin_polygon();
}

/// Adds a single vertex to the current path
pub fn vertex(x: f64, y: f64) void {
    c.Fl_vertex(x, y);
}

/// Ends list of points, and draws
pub fn endPoints() void {
    c.Fl_end_points();
}

/// Ends list of lines, and draws
pub fn endLine() void {
    c.Fl_end_line();
}

/// Ends closed sequence of lines, and draws
pub fn endLoop() void {
    c.Fl_end_loop();
}

/// Ends closed sequence of lines, and draws
pub fn endPolygon() void {
    c.Fl_end_polygon();
}

/// Starts drawing a complex filled polygon
pub fn beginComplexPolygon() void {
    c.Fl_begin_complex_polygon();
}

/// Call gap() to separate loops of the path
pub fn gap() void {
    c.Fl_gap();
}

/// Ends complex filled polygon, and draws
pub fn endComplexPolygon() void {
    c.Fl_end_complex_polygon();
}

/// Sets the current font, which is then used in various drawing routines
pub fn setFont(face: Font, fsize: u32) void {
    c.Fl_set_draw_font(@intFromEnum(face), fsize);
}

/// Gets the current font, which is used in various drawing routines
pub fn font() Font {
    return c.Fl_font();
}

/// Gets the current font size, which is used in various drawing routines
pub fn size() u32 {
    return c.Fl_size();
}

/// Returns the recommended minimum line spacing for the current font
pub fn height() i32 {
    return c.Fl_height();
}

/// Sets the line spacing for the current font
pub fn setHeight(f: Font, sz: u32) void {
    c.Fl_set_height(@intFromEnum(f), sz);
}

/// Returns the recommended distance above the bottom of a height() tall box to
/// draw the text at so it looks centered vertically in that box
pub fn descent() i32 {
    return c.Fl_descent();
}

pub fn width(txt: [*c]const u8) f64 {
    return c.Fl_width(txt);
}

/// Returns the typographical width of a sequence of n characters
pub fn width2(txt: [*c]const u8, n: i32) f64 {
    return c.Fl_width2(txt, n);
}

/// Returns the typographical width of a single character
pub fn charWidth(val: u8) f64 {
    return c.Fl_width3(val);
}

/// Converts text from Windows/X11 latin1 character set to local encoding
pub fn latin1ToLocal(txt: [*c]const u8, n: i32) [*c]const u8 {
    return c.Fl_latin1_to_local(txt, n);
}

/// Converts text from local encoding to Windowx/X11 latin1 character set
pub fn localToLatin1(txt: [*c]const u8, n: i32) [*c]const u8 {
    return c.Fl_local_to_latin1(txt, n);
}

/// Draws a string starting at the given x, y location
pub fn drawText(txt: [*c]const u8, x: i32, y: i32) void {
    c.Fl_draw(txt, x, y);
}

/// Draws a string starting at the given x, y location with width and height and alignment
pub fn drawText2(string: [*c]const u8, x: i32, y: i32, w: i32, h: i32, al: i32) void {
    c.Fl_draw_text2(string, x, y, w, h, al);
}

/// Draws a string starting at the given x, y location, rotated to an angle
pub fn drawTextAngled(angle: i32, txt: [*c]const u8, x: i32, y: i32) void {
    c.Fl_draw2(angle, txt, x, y);
}

/// Draws a frame with text
pub fn drawFrame(string: [*c]const u8, x: i32, y: i32, w: i32, h: i32) void {
    c.Fl_frame(string, x, y, w, h);
}

/// Draws a frame with text.
/// Differs from frame() by the order of the line segments
pub fn drawFrame2(string: [*c]const u8, x: i32, y: i32, w: i32, h: i32) void {
    c.Fl_frame2(string, x, y, w, h);
}

/// Draws a box given the box type, size, position and color
pub fn box(box_type: BoxType, x: i32, y: i32, w: i32, h: i32, col: Color) void {
    c.Fl_draw_box(@intFromEnum(box_type), x, y, w, h, col.toRgbi());
}

/// Checks whether platform supports true alpha blending for RGBA images
pub fn canDoAlphaBlending() bool {
    return c.Fl_can_do_alpha_blending() != 0;
}

/// Get a human-readable string from a shortcut value
pub fn shortcutLabel(shortcut: i32) [*c]const u8 {
    return c.Fl_shortcut_label(shortcut);
}

/// Draws a selection rectangle, erasing a previous one by XOR'ing it first.
pub fn overlayRect(x: i32, y: i32, w: i32, h: i32) void {
    c.Fl_overlay_rect(x, y, w, h);
}

/// Erase a selection rectangle without drawing a new one
pub fn overlayClear() void {
    c.Fl_overlay_clear();
}

/// Sets the cursor style
pub fn setCursor(cursor: Cursor) void {
    c.Fl_set_cursor(@intFromEnum(cursor));
}

/// Sets the cursor style
pub fn setCursorWithColor(cursor: Cursor, fg: Color, bg: Color) void {
    c.Fl_set_cursor2(@intFromEnum(cursor), fg.toRgbi(), bg.toRgbi());
}

test "all" {
    @import("std").testing.refAllDecls(@This());
}
