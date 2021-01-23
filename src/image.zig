const c = @cImport({
    @cInclude("cfl_image.h");
});

pub const Image = struct {
    inner: ?*c.Fl_Image,
    pub fn scale(self: *Image, width: i32, height: i32, proportional: bool, can_expand: bool) void {
        c.Fl_Image_scale(self.inner, width, height, @boolToInt(proportional), @boolToInt(can_expand));
    }

    pub fn raw(self: *Image) ?*c.Fl_Image {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Image) Image {
        return Image{
            .inner = ptr,
        };
    }

    pub fn fromImagePtr(img: ?*c.Fl_Image) Image {
        return Image{
            .inner = @ptrCast(?*c.Fl_Image, img),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) Image {
        return Image{
            .inner = @ptrCast(?*c.Fl_Image, ptr),
        };
    }

    pub fn toVoidPtr(self: *Image) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn delete(self: *Image) void {
        c.Fl_Image_delete(self.inner);
        self.inner = null;
    }

    pub fn copy(self: *const Image) Image {
        const img = c.Fl_Image_copy(self.inner);
        return Image{
            .inner = img,
        };
    }

    pub fn draw(self: *Image, arg2: i32, arg3: i32, arg4: i32, arg5: i32) void {
        return c.Fl_Image_draw(self.inner, arg2, arg3, arg4, arg5);
    }

    pub fn w(self: *const Image) i32 {
        return c.Fl_Image_width(self.inner);
    }

    pub fn h(self: *const Image) i32 {
        return c.Fl_Image_height(self.inner);
    }

    pub fn count(self: *const Image) u32 {
        return c.Fl_Image_count(self.inner);
    }

    pub fn dataW(self: *const Image) u32 {
        return c.Fl_Image_data_w(self.inner);
    }

    pub fn dataH(self: *const Image) u32 {
        return c.Fl_Image_data_h(self.inner);
    }

    pub fn depth(self: *const Image) u32 {
        return c.Fl_Image_d(self.inner);
    }

    pub fn ld(self: *const Image) u32 {
        return c.Fl_Image_ld(self.inner);
    }
};

pub const SharedImage = struct {
    inner: ?*c.Fl_Shared_Image,
    pub fn load(path: [*c]const u8) !SharedImage {
        const ptr = c.Fl_Shared_Image_get(path, 0, 0);
        if (ptr == null or c.Fl_Shared_Image_fail(ptr) < 0) return error.InvalidParemeter;
        return SharedImage{ .inner = ptr };
    }

    pub fn fromImage(img: *const Image) !SharedImage {
        const x = c.Fl_Shared_Image_from_rgb(img.inner, 0);
        if (x == null or c.Fl_Shared_Image_fail(x) < 0) return error.InvalidParemeter;
        return SharedImage{.inner = x};
    }

    pub fn raw(self: *SharedImage) ?*c.Fl_Shared_Image {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Shared_Image) SharedImage {
        return SharedImage{
            .inner = ptr,
        };
    }

    pub fn fromImagePtr(img: ?*c.Fl_Image) SharedImage {
        return SharedImage{
            .inner = @ptrCast(?*c.Fl_Shared_Image, img),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) SharedImage {
        return SharedImage{
            .inner = @ptrCast(?*c.Fl_Shared_Image, ptr),
        };
    }

    pub fn toVoidPtr(self: *SharedImage) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asImage(self: *const SharedImage) Image {
        return Image{ .inner = @ptrCast(?*c.Fl_Image, self.inner) };
    }
};

pub const SvgImage = struct {
    inner: ?*c.Fl_SVG_Image,
    pub fn load(path: [*c]const u8) !SvgImage {
        const x = c.Fl_SVG_Image_new(path);
        if (x == null or c.Fl_SVG_Image_fail(x) < 0) return error.InvalidParemeter;
        return SvgImage{ .inner = x };
    }

    pub fn fromData(data: [*c]const u8) !SvgImage {
        const x = c.Fl_SVG_Image_from(data);
        if (x == null or c.Fl_SVG_Image_fail(x) < 0) return error.InvalidParemeter;
        return SvgImage{.inner = x};
    }

    pub fn raw(self: *SvgImage) ?*c.Fl_SVG_Image {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_SVG_Image) SvgImage {
        return SvgImage{
            .inner = ptr,
        };
    }

    pub fn fromImagePtr(img: ?*c.Fl_Image) SvgImage {
        return SvgImage{
            .inner = @ptrCast(?*c.Fl_SVG_Image, img),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) SvgImage {
        return SvgImage{
            .inner = @ptrCast(?*c.Fl_SVG_Image, ptr),
        };
    }

    pub fn toVoidPtr(self: *SvgImage) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asImage(self: *const SvgImage) Image {
        return Image{ .inner = @ptrCast(?*c.Fl_Image, self.inner) };
    }
};

pub const JpegImage = struct {
    inner: ?*c.Fl_JPEG_Image,
    pub fn load(path: [*c]const u8) !JpegImage {
        const x = c.Fl_JPEG_Image_new(path);
        if (x == null or c.Fl_JPEG_Image_fail(x) < 0) return error.InvalidParemeter;
        return JpegImage{ .inner = x };
    }

    pub fn fromData(data: [*c]const u8) !JpegImage {
        const x = c.Fl_JPEG_Image_from(data);
        if (x == null or c.Fl_JPEG_Image_fail(x) < 0) return error.InvalidParemeter;
        return JpegImage{.inner = x};
    }

    pub fn raw(self: *JpegImage) ?*c.Fl_JPEG_Image {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_JPEG_Image) JpegImage {
        return JpegImage{
            .inner = ptr,
        };
    }

    pub fn fromImagePtr(img: ?*c.Fl_Image) JpegImage {
        return JpegImage{
            .inner = @ptrCast(?*c.Fl_JPEG_Image, img),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) JpegImage {
        return JpegImage{
            .inner = @ptrCast(?*c.Fl_JPEG_Image, ptr),
        };
    }

    pub fn toVoidPtr(self: *JpegImage) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asImage(self: *const JpegImage) Image {
        return Image{ .inner = @ptrCast(?*c.Fl_Image, self.inner) };
    }
};

pub const BmpImage = struct {
    inner: ?*c.Fl_BMP_Image,
    pub fn load(path: [*c]const u8) !BmpImage {
        const x = c.Fl_BMP_Image_new(path);
        if (x == null or c.Fl_BMP_Image_fail(x) < 0) return error.InvalidParemeter;
        return BmpImage{ .inner = x };
    }

    pub fn fromData(data: [*c]const u8) !BmpImage {
        const x = c.Fl_BMP_Image_from(data);
        if (x == null or c.Fl_BMP_Image_fail(x) < 0) return error.InvalidParemeter;
        return BmpImage{.inner = x};
    }

    pub fn raw(self: *BmpImage) ?*c.Fl_BMP_Image {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_BMP_Image) BmpImage {
        return BmpImage{
            .inner = ptr,
        };
    }

    pub fn fromImagePtr(img: ?*c.Fl_Image) BmpImage {
        return BmpImage{
            .inner = @ptrCast(?*c.Fl_BMP_Image, img),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) BmpImage {
        return BmpImage{
            .inner = @ptrCast(?*c.Fl_BMP_Image, ptr),
        };
    }

    pub fn toVoidPtr(self: *BmpImage) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asImage(self: *const BmpImage) Image {
        return Image{ .inner = @ptrCast(?*c.Fl_Image, self.inner) };
    }
};

pub const RgbImage = struct {
    inner: ?*c.Fl_RGB_Image,
    pub fn new(data: [*c]const u8, w: u32, h: u32, depth: u32) !RgbImage {
        const ptr = c.Fl_RGB_Image_new(data, w, h, depth);
        if (ptr == null or c.Fl_RGB_Image_fail(ptr) < 0) return error.InvalidParemeter;
        return RgbImage{ .inner = ptr };
    }

    pub fn fromData(data: [*c]const u8, w: u32, h: u32, depth: u32) !RgbImage {
        const ptr = c.Fl_RGB_Image_from_data(data, w, h, depth);
        if (ptr == null or c.Fl_RGB_Image_fail(ptr) < 0) return error.InvalidParemeter;
        return RgbImage{ .inner = ptr };
    }

    pub fn raw(self: *RgbImage) ?*c.Fl_RGB_Image {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_RGB_Image) RgbImage {
        return RgbImage{
            .inner = ptr,
        };
    }

    pub fn fromImagePtr(img: ?*c.Fl_Image) RgbImage {
        return RgbImage{
            .inner = @ptrCast(?*c.Fl_RGB_Image, img),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) RgbImage {
        return RgbImage{
            .inner = @ptrCast(?*c.Fl_RGB_Image, ptr),
        };
    }

    pub fn toVoidPtr(self: *RgbImage) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asImage(self: *const RgbImage) Image {
        return Image{ .inner = @ptrCast(?*c.Fl_Image, self.inner) };
    }
};

pub const PngImage = struct {
    inner: ?*c.Fl_PNG_Image,
    pub fn load(path: [*c]const u8) !PngImage {
        const x = c.Fl_PNG_Image_new(path);
        if (x == null or c.Fl_PNG_Image_fail(x) < 0) return error.InvalidParemeter;
        return PngImage{ .inner = x };
    }

    pub fn fromData(data: [*c]const u8) !PngImage {
        const x = c.Fl_PNG_Image_from(data);
        if (x == null or c.Fl_PNG_Image_fail(x) < 0) return error.InvalidParemeter;
        return PngImage{.inner = x};
    }

    pub fn raw(self: *PngImage) ?*c.Fl_PNG_Image {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_PNG_Image) PngImage {
        return PngImage{
            .inner = ptr,
        };
    }

    pub fn fromImagePtr(img: ?*c.Fl_Image) PngImage {
        return PngImage{
            .inner = @ptrCast(?*c.Fl_PNG_Image, img),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) PngImage {
        return PngImage{
            .inner = @ptrCast(?*c.Fl_PNG_Image, ptr),
        };
    }

    pub fn toVoidPtr(self: *PngImage) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asImage(self: *const PngImage) Image {
        return Image{ .inner = @ptrCast(?*c.Fl_Image, self.inner) };
    }
};

pub const GifImage = struct {
    inner: ?*c.Fl_GIF_Image,
    pub fn load(path: [*c]const u8) !GifImage {
        const x = c.Fl_GIF_Image_new(path);
        if (x == null or c.Fl_GIF_Image_fail(x) < 0) return error.InvalidParemeter;
        return GifImage{ .inner = x };
    }

    pub fn fromData(data: [*c]const u8) !GifImage {
        const x = c.Fl_GIF_Image_from(data);
        if (x == null or c.Fl_GIF_Image_fail(x) < 0) return error.InvalidParemeter;
        return GifImage{.inner = x};
    }

    pub fn raw(self: *GifImage) ?*c.Fl_GIF_Image {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_GIF_Image) GifImage {
        return GifImage{
            .inner = ptr,
        };
    }

    pub fn fromImagePtr(img: ?*c.Fl_Image) GifImage {
        return GifImage{
            .inner = @ptrCast(?*c.Fl_GIF_Image, img),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) GifImage {
        return GifImage{
            .inner = @ptrCast(?*c.Fl_GIF_Image, ptr),
        };
    }

    pub fn toVoidPtr(self: *GifImage) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asImage(self: *const GifImage) Image {
        return Image{ .inner = @ptrCast(?*c.Fl_Image, self.inner) };
    }
};

pub const TiledImage = struct {
    inner: ?*c.Fl_Tiled_Image,
    pub fn new(img: *const Image, w: i32, h: i32) TiledImage {
        const ptr = c.Fl_Tiled_Image_new(img.inner, w, h);
        return TiledImage{ .inner = ptr };
    }

    pub fn raw(self: *TiledImage) ?*c.Fl_Tiled_Image {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Tiled_Image) TiledImage {
        return TiledImage{
            .inner = ptr,
        };
    }

    pub fn fromImagePtr(img: ?*c.Fl_Image) TiledImage {
        return TiledImage{
            .inner = @ptrCast(?*c.Fl_Tiled_Image, img),
        };
    }

    pub fn fromVoidPtr(ptr: ?*c_void) TiledImage {
        return TiledImage{
            .inner = @ptrCast(?*c.Fl_Tiled_Image, ptr),
        };
    }

    pub fn toVoidPtr(self: *TiledImage) ?*c_void {
        return @ptrCast(?*c_void, self.inner);
    }

    pub fn asImage(self: *const TiledImage) Image {
        return Image{ .inner = @ptrCast(?*c.Fl_Image, self.inner) };
    }
};
