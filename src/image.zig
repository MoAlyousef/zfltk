// TODO: update to new API

const zfltk = @import("zfltk.zig");
const c = zfltk.c;
const std = @import("std");

// TODO: Add more error types
pub const ImageError = error{
    NoImage,
    FileAccess,
    InvalidFormat,
    MemoryAccess,
    Error,
};

// Converts a C error code to a Zig error enum
inline fn ImageErrorFromInt(err: c_int) ImageError!void {
    return switch (err) {
        0 => {},
        -1 => ImageError.NoImage,
        -2 => ImageError.FileAccess,
        -3 => ImageError.InvalidFormat,
        -4 => ImageError.MemoryAccess,

        else => ImageError.Error,
    };
}

pub const Image = struct {
    inner: RawPtr,

    pub const RawPtr = *c.Fl_Image;

    pub const RawImageOptions = struct {
        data: []const u8,

        w: u31,
        h: u31,

        depth: enum(c_int) {
            grayscale = 0,
            grayscale_alpha,
            rgb,
            rgba,
        },

        line_data: u31 = 0,
    };

    pub const Kind = enum {
        normal,
        shared,
        svg,
        jpeg,
        bmp,
        raw,
        png,
        gif,
        tiled,
    };

    pub fn load(comptime kind: Kind, path: [:0]const u8) !Image {
        const loadFn = switch (kind) {
            .shared => c.Fl_Shared_Image_get,
            .svg => c.Fl_SVG_Image_new,
            .jpeg => c.Fl_JPEG_Image_new,
            .bmp => c.Fl_BMP_Image_new,
            .png => c.Fl_PNG_Image_new,
            .gif => c.Fl_GIF_Image_new,

            else => @compileError("this image type cannot be loaded from file"),
        };

        const failFn = switch (kind) {
            .shared => c.Fl_Shared_Image_fail,
            .svg => c.Fl_SVG_Image_fail,
            .jpeg => c.Fl_JPEG_Image_fail,
            .bmp => c.Fl_BMP_Image_fail,
            .png => c.Fl_PNG_Image_fail,
            .gif => c.Fl_GIF_Image_fail,

            else => unreachable,
        };

        _ = switch (kind) {
            .shared => {
                if (loadFn(path.ptr, 0, 0)) |ptr| {
                    try ImageErrorFromInt(failFn(ptr));
                    return Image.fromRaw(@ptrCast(ptr));
                }
            },
            else => {
                if (loadFn(path.ptr)) |ptr| {
                    try ImageErrorFromInt(failFn(ptr));
                    return Image.fromRaw(@ptrCast(ptr));
                }
            },
        };

        unreachable;
    }

    pub inline fn init(comptime kind: Kind, data: []const u8) !Image {
        const loadFn = switch (kind) {
            .svg => c.Fl_SVG_Image_from,
            .jpeg => c.Fl_JPEG_Image_from,
            .bmp => c.Fl_BMP_Image_from,
            .png => c.Fl_PNG_Image_from,
            .gif => c.Fl_GIF_Image_from,

            .raw => @compileError("use `fromRawData` instead"),
            else => @compileError("this image type cannot be loaded from data"),
        };

        const failFn = switch (kind) {
            .svg => c.Fl_SVG_Image_fail,
            .jpeg => c.Fl_JPEG_Image_fail,
            .bmp => c.Fl_BMP_Image_fail,
            .png => c.Fl_PNG_Image_fail,
            .gif => c.Fl_GIF_Image_fail,

            else => unreachable,
        };

        // JPEG and SVG currently do not use a length arg in cfltk
        switch (kind) {
            .jpeg, .svg => {
                if (loadFn(data.ptr)) |ptr| {
                    try ImageErrorFromInt(failFn(ptr));
                    return Image.fromRaw(@ptrCast(ptr));
                }
            },
            else => {
                if (loadFn(data.ptr,  @intCast(data.len))) |ptr| {
                    try ImageErrorFromInt(failFn(ptr));
                    return Image.fromRaw(@ptrCast(ptr));
                }
            },
        }

        unreachable;
    }

    /// Only used on raw image types (grayscale, RGB, RGBA)
    pub inline fn fromRawData(opts: RawImageOptions) Image {
        // TODO error handling
        if (c.Fl_RGB_Image_new(opts.data.ptr, opts.w, opts.h, @intFromEnum(opts.depth), opts.line_data)) |ptr| {
            try ImageErrorFromInt(c.Fl_RGB_Image_fail(ptr));
            return Image.fromRaw(ptr);
        }

        unreachable;
    }

    pub inline fn scale(self: *const Image, width: u31, height: u31, proportional: bool, can_expand: bool) void {
        c.Fl_Image_scale(@ptrCast(self.inner), width, height, @intFromBool(proportional), @intFromBool(can_expand));
    }

    pub inline fn raw(self: *const Image) RawPtr {
        return self.inner;
    }

    pub inline fn fromRaw(ptr: RawPtr) Image {
        return .{ .inner = ptr };
    }

    pub inline fn fromVoidPtr(ptr: *anyopaque) Image {
        return Image.fromRaw(@ptrCast(ptr));
    }

    pub inline fn toVoidPtr(self: *const Image) ?*anyopaque {
        return  @ptrCast(self.inner);
    }

    pub inline fn deinit(self: *const Image) void {
        c.Fl_Image_delete(@ptrCast(self.inner));
    }

    /// Returns a tiled version of the input image
    pub inline fn tile(self: *const Image, _w: u31, _h: u31) Image {
        if (c.Fl_Tiled_Image_new(self.inner, _w, _h)) |ptr| {
            return Image.fromRaw(@ptrCast(ptr));
        }

        unreachable;
    }

    pub inline fn copy(self: *const Image) Image {
        if (c.Fl_Image_copy(self.inner)) |ptr| {
            return Image.fromRaw(ptr);
        }

        unreachable;
    }

    pub fn draw(self: *const Image, arg2: u31, arg3: u31, arg4: u31, arg5: u31) void {
        return c.Fl_Image_draw(self.inner, arg2, arg3, arg4, arg5);
    }

    pub fn w(self: *const Image) u31 {
        return c.Fl_Image_width(self.inner);
    }

    pub fn h(self: *const Image) u31 {
        return c.Fl_Image_height(self.inner);
    }

    pub fn count(self: *const Image) u31 {
        return c.Fl_Image_count(self.inner);
    }

    pub fn dataW(self: *const Image) u31 {
        return c.Fl_Image_data_w(self.inner);
    }

    pub fn dataH(self: *const Image) u31 {
        return c.Fl_Image_data_h(self.inner);
    }

    pub fn depth(self: *const Image) u31 {
        return c.Fl_Image_d(self.inner);
    }

    pub fn ld(self: *const Image) u31 {
        return c.Fl_Image_ld(self.inner);
    }
};

test "all" {
    @import("std").testing.refAllDecls(@This());
}
