const std = @import("std");
const c = @cImport({
  @cInclude("cfl.h");
  @cInclude("cfl_enums.h");
  @cInclude("cfl_button.h");
  @cInclude("cfl_box.h");
  @cInclude("cfl_window.h");
});

pub fn cb(w: ?*c.Fl_Widget, data: ?*c_void) callconv(.C) void {
  c.Fl_Box_set_label(@ptrCast(*c.Fl_Box, data), "Hello World!");
  c.Fl_Button_set_color(@ptrCast(*c.Fl_Button, w), @enumToInt(c.Fl_Color_Red));
}

pub fn main() !void {
    var win = c.Fl_Window_new(100, 100, 400, 300, "Hello");
    var but = c.Fl_Button_new(160, 200, 80, 40, "Click me!");
    var box = c.Fl_Box_new(0, 0, 400, 200, "");
    c.Fl_Window_end(win);
    c.Fl_Window_show(win);
    c.Fl_Button_set_callback(but, cb, box);
    _ = c.Fl_run();
}
