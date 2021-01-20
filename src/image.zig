const c = @cImport({
    @cInclude("cfl_image.h");
});

pub const Image = struct {
    inner: ?*c.Fl_Image,
    pub fn scale(self: *Image, width: i32, height: i32, proportional: bool, can_expand: bool) void {
        c.Fl_Image_scale(self.inner, width, height, @boolToInt(proportional), @boolToInt(can_expand));
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

    pub fn width(self: *const Image) i32 {
        return c.Fl_Image_width(self.inner);
    }

    pub fn height(self: *const Image) i32 {
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
    pub fn load(path: [:0]const u8) SharedImage {
        const ptr = c.Fl_Shared_Image_get(path, 0, 0);
        if (ptr == null) unreachable;
        return SharedImage{ .inner = ptr };
    }

    pub fn asImage(self: *const SharedImage) Image {
        return Image{ .inner = @ptrCast(*c.Fl_Image, self.inner) };
    }
};
