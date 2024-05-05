// TODO: rename enums to snake_case to match Zig style guide
// <https://github.com/ziglang/zig/issues/2101>

const std = @import("std");
const draw = @import("draw.zig");
const builtin = @import("builtin");
const native_endian = builtin.cpu.arch.endian();

const c = @cImport({
    @cInclude("cfl.h");
});

// DO NOT add more elements to this stuct.
// Using 4 `u8`s in a packed struct makes an identical memory layout to a u32
// (the color format FLTK uses) so this trick can be used to make Colors both
// efficient and easy to use
pub const Color = switch (native_endian) {
    .big => packed struct {
        r: u8 = 0,
        g: u8 = 0,
        b: u8 = 0,
        i: u8 = 0,

        pub usingnamespace methods;
    },

    .little => packed struct {
        i: u8 = 0,
        b: u8 = 0,
        g: u8 = 0,
        r: u8 = 0,

        pub usingnamespace methods;
    },
};

pub const methods = packed struct {
    pub const Names = enum(u8) {
        foreground = 0,
        background2 = 7,
        inactive = 8,
        selection = 15,
        gray0 = 32,
        dark3 = 39,
        dark2 = 45,
        dark1 = 47,
        background = 49,
        light1 = 50,
        light2 = 52,
        light3 = 54,
        black = 56,
        red = 88,
        green = 63,
        yellow = 95,
        blue = 216,
        magenta = 248,
        cyan = 223,
        dark_red = 72,
        dark_green = 60,
        dark_yellow = 76,
        dark_blue = 136,
        dark_magenta = 152,
        dark_cyan = 140,
        white = 255,
    };

    pub fn fromName(name: Names) Color {
        return Color.fromIndex(@intFromEnum(name));
    }

    pub fn fromIndex(idx: u8) Color {
        var col = Color{
            .r = undefined,
            .g = undefined,
            .b = undefined,
            .i = idx,
        };

        c.Fl_get_color_rgb(idx, &col.r, &col.g, &col.b);

        return col;
    }

    pub fn mapSelection(col: Color) Color {
        return draw.showColorMap(col);
    }

    pub fn fromRgb(r: u8, g: u8, b: u8) Color {
        // This is a special exception as FLTK's `0` index is the
        // foreground for some reason. Eg: if you override the foreground
        // color then try to set another color to black, it would set it to
        // the new foreground color
        if (r | g | b == 0) {
            return Color.fromName(.black);
        }

        return Color{
            .r = r,
            .g = g,
            .b = b,
            .i = 0,
        };
    }

    pub fn toRgbi(col: Color) u32 {
        // Drop the RGB bytes if color is indexed
        // This is because colors where both the index byte and color u24 are
        // non-0 are reserved
        if (col.i != 0) {
            return col.i;
        }

        return @bitCast(col);
    }

    pub fn fromRgbi(val: u32) Color {
        var col: Color = @bitCast(val);

        // If the color is indexed, set find out what the R, G and B values
        // are and set the struct's fields
        if (col.i != 0) {
            c.Fl_get_color_rgb(col.i, &col.r, &col.g, &col.b);
        }

        return col;
    }

    pub fn toHex(col: Color) u24 {
        const temp: u32 = @bitCast(col);
        return @truncate(temp >> 8);
    }

    pub fn fromHex(val: u24) Color {
        if (val == 0) {
            return Color.fromName(.black);
        }

        return @bitCast(std.mem.nativeToLittle(u32, @as(u32, val) << 8));
    }

    // Seems really redundant and the FLTK docs don't even appear to document
    // how much a color gets darkened/lightened
    //    pub fn darker(col: Color) Color {
    //        return Color.fromRgbi(c.Fl_darker(col.toRgbi()));
    //    }

    pub fn darken(col: Color, val: u8) Color {
        var new_col = col;

        new_col.r -|= val;
        new_col.g -|= val;
        new_col.b -|= val;

        return new_col;
    }

    pub fn lighten(col: Color, val: u8) Color {
        var new_col = col;

        new_col.r +|= val;
        new_col.g +|= val;
        new_col.b +|= val;

        return new_col;
    }
};

pub const Align = struct {
    pub const center = 0;
    pub const top = 1;
    pub const bottom = 2;
    pub const left = 4;
    pub const right = 8;
    pub const inside = 16;
    pub const text_over_image = 20;
    pub const clip = 40;
    pub const wrap = 80;
    pub const image_next_to_text = 100;
    pub const text_next_to_image = 120;
    pub const image_backdrop = 200;
    pub const top_left = 1 | 4;
    pub const top_right = 1 | 8;
    pub const bottom_left = 2 | 4;
    pub const bottom_right = 2 | 8;
    pub const left_top = 7;
    pub const right_top = 11;
    pub const left_bottom = 13;
    pub const right_bottom = 14;
    pub const position_mask = 15;
    pub const image_mask = 320;
};

pub const LabelType = enum(i32) {
    normal = 0,
    none,
    shadow,
    engraved,
    embossed,
    multi,
    icon,
    image,
    free,
};

pub const BoxType = enum(c_int) {
    none = 0,
    flat,
    up,
    down,
    up_frame,
    down_frame,
    thin_up,
    thin_down,
    thin_up_frame,
    thin_down_frame,
    engraved,
    embossed,
    engraved_frame,
    embossed_frame,
    border,
    shadow,
    border_frame,
    shadow_frame,
    rounded,
    rshadow,
    rounded_frame,
    rflat,
    round_up,
    round_down,
    diamand_up,
    diamond_down,
    oval,
    oshadow,
    oval_frame,
    oflat,
    plastic_up,
    plastic_down,
    plastic_up_frame,
    plastic_down_frame,
    plastic_thin_up,
    plastic_thin_down,
    plastic_round_up,
    plsatic_round_down,
    gtk_up,
    gtk_down,
    gtk_up_frame,
    gtk_down_frame,
    gtk_thin_up,

    gtk_thin_down_box,
    gtk_thin_up_frame,
    gtk_thin_down_frame,
    gtk_round_up_frame,
    gtk_round_down_frame,
    gleam_up_box,
    gleam_down_box,
    gleam_up_frame,
    gleam_down_frame,
    gleam_thin_up_box,
    gleam_thin_down_box,
    gleam_round_up_box,
    gleam_round_down_box,
    free,
};

pub const BrowserScrollbar = enum(i32) {
    none = 0,
    horizontal = 1,
    vertical = 2,
    both = 3,
    always = 4,
    horizontal_always = 5,
    vertical_always = 6,
    both_always = 7,
};

pub const Event = enum(c_int) {
    none = 0,
    push,
    release,
    enter,
    leave,
    drag,
    focus,
    unfocus,
    key_down,
    key_up,
    close,
    move,
    shortcut,
    deactivate,
    activate,
    hide,
    show,
    paste,
    selection_clear,
    mouse_wheel,
    dnd_enter,
    dnd_drag,
    dnd_leave,
    dnd_release,
    screen_config_changed,
    fullscreen,
    zoom_gesture,
    zoom_event,
    FILLER, // FLTK sends `28` as an event occasionally and this doesn't appear
    // to be documented anywhere. This is only included to keep
    // programs from crashing from a non-existent enum
};

pub const Font = enum(c_int) {
    helvetica = 0,
    helvetica_bold,
    helvetica_italic,
    helvetica_bold_italic,
    courier,
    courier_bold,
    courier_italic,
    courier_bold_italic,
    times,
    times_bold,
    times_italic,
    times_bold_italic,
    symbol,
    screen,
    screen_bold,
    zapfdingbats,
};

pub const Key = struct {
    pub const None = 0;
    pub const Button = 0xfee8;
    pub const BackSpace = 0xff08;
    pub const Tab = 0xff09;
    pub const IsoKey = 0xff0c;
    pub const Enter = 0xff0d;
    pub const Pause = 0xff13;
    pub const ScrollLock = 0xff14;
    pub const Escape = 0xff1b;
    pub const Kana = 0xff2e;
    pub const Eisu = 0xff2f;
    pub const Yen = 0xff30;
    pub const JISUnderscore = 0xff31;
    pub const Home = 0xff50;
    pub const Left = 0xff51;
    pub const Up = 0xff52;
    pub const Right = 0xff53;
    pub const Down = 0xff54;
    pub const PageUp = 0xff55;
    pub const PageDown = 0xff56;
    pub const End = 0xff57;
    pub const Print = 0xff61;
    pub const Insert = 0xff63;
    pub const Menu = 0xff67;
    pub const Help = 0xff68;
    pub const NumLock = 0xff7f;
    pub const KP = 0xff80;
    pub const KPEnter = 0xff8d;
    pub const KPLast = 0xffbd;
    pub const FLast = 0xffe0;
    pub const ShiftL = 0xffe1;
    pub const ShiftR = 0xffe2;
    pub const ControlL = 0xffe3;
    pub const ControlR = 0xffe4;
    pub const CapsLock = 0xffe5;
    pub const MetaL = 0xffe7;
    pub const MetaR = 0xffe8;
    pub const AltL = 0xffe9;
    pub const AltR = 0xffea;
    pub const Delete = 0xffff;

    // TODO: add `fromName` and related methods
};

pub const Shortcut = struct {
    pub const None = 0;
    pub const Shift = 0x00010000;
    pub const CapsLock = 0x00020000;
    pub const Ctrl = 0x00040000;
    pub const Alt = 0x00080000;
};

pub const CallbackTrigger = struct {
    pub const Never = 0;
    pub const Changed = 1;
    pub const NotChanged = 2;
    pub const Release = 4;
    pub const ReleaseAlways = 6;
    pub const EnterKey = 8;
    pub const EnterKeyAlways = 10;
    pub const EnterKeyChanged = 11;
};

pub const Cursor = enum(i32) {
    default = 0,
    arrow = 35,
    cross = 66,
    wait = 76,
    insert = 77,
    hand = 31,
    help = 47,
    move = 27,
    ns = 78,
    we = 79,
    nwse = 80,
    nesw = 81,
    n = 70,
    ne = 69,
    e = 49,
    se = 8,
    s = 9,
    sw = 7,
    w = 36,
    nw = 68,
    none = 255,
};

pub const TextCursor = enum(u8) {
    normal,
    caret,
    dim,
    block,
    heavy,
    simple,
};

pub const Mode = struct {
    /// Rgb color (not indexed)
    pub const rgb = 0;
    /// Single buffered
    pub const single = 0;
    /// Indexed mode
    pub const index = 1;
    /// Double buffered
    pub const double = 2;
    /// Accumulation buffer
    pub const accum = 4;
    /// Alpha channel in color
    pub const alpha = 8;
    /// Depth buffer
    pub const depth = 16;
    /// Stencil buffer
    pub const stencil = 32;
    /// Rgb8 color with at least 8 bits of each color
    pub const rgb8 = 64;
    /// MultiSample anti-aliasing
    pub const multi_sample = 128;
    /// Stereoscopic rendering
    pub const stereo = 256;
    /// Fake single buffered windows using double-buffer
    pub const fake_single = 512;
    /// Use OpenGL version 3.0 or more
    pub const opengl3 = 1024;
};

test "all" {
    @import("std").testing.refAllDeclsRecursive(@This());
}
