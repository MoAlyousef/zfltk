const c = @cImport({
    @cInclude("cfl.h"); // Fl_init_all, Fl_run
    @cInclude("cfl_enums.h"); // Fl_Color_*
    @cInclude("cfl_image.h"); // Fl_register_images
    @cInclude("cfl_button.h"); // Fl_Button
    @cInclude("cfl_box.h"); // Fl_Box
    @cInclude("cfl_window.h"); // Fl_Window
});

// fltk initizialization of optional functionalities
pub fn fltkInit() void {
    c.Fl_init_all(); // inits all styles, if needed
    c.Fl_register_images(); // register image types supported by fltk, if needed
    _ = c.Fl_lock(); // enable multithreading, if needed
}

// Button callback
pub fn butCb(w: ?*c.Fl_Widget, data: ?*anyopaque) callconv(.C) void {
    c.Fl_Box_set_label(@ptrCast(?*c.Fl_Box, data), "Hello World!");
    c.Fl_Button_set_color(@ptrCast(?*c.Fl_Button, w), c.Fl_Color_Cyan);
}

pub fn main() !void {
    fltkInit();

    _ = c.Fl_set_scheme("gtk+");
    var win = c.Fl_Window_new(100, 100, 400, 300, "Hello");
    var but = c.Fl_Button_new(160, 220, 80, 40, "Click me!");
    var box = c.Fl_Box_new(10, 10, 380, 180, "");
    c.Fl_Box_set_box(box, c.Fl_BoxType_UpBox);
    c.Fl_Box_set_label_size(box, 18);
    c.Fl_Box_set_label_font(box, c.Fl_Font_Courier);
    c.Fl_Window_end(win);
    c.Fl_Window_show(win);
    c.Fl_Button_set_callback(but, butCb, box);
    _ = c.Fl_run();
}
