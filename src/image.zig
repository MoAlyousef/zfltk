const c = @cImport({
    @cInclude("cfl_image.h");
});

pub const Image = struct {
    inner: ?*c.Fl_Image,
    pub fn scale(self: *Image, width: i32, height: i32, proportional: bool, can_expand: bool) void {
        c.Fl_Image_scale(self.inner, width, height, @boolToInt(proportional), @boolToInt(can_expand));
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
