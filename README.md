# fltk-zig-example

This is an example repo showing how to build fltk apps using zig.

## Usage
Run:
```
$ zig build
$ ./zig-cache/bin/fltk_app
```

## Dependencies
Check the [cfltk](https://github.com/moalyousef/cfltk) repo for the necessary dependencies on each system/distro.

## API
The code currently calls directly into the C wrapper and looks like this:
```zig
const c = @cImport({
    @cInclude("cfl.h"); // Fl_run
    @cInclude("cfl_enums.h"); // Fl_Color_*
    @cInclude("cfl_button.h"); // Fl_Button
    @cInclude("cfl_box.h"); // Fl_Box
    @cInclude("cfl_window.h"); // Fl_Window
});

pub fn but_cb(w: ?*c.Fl_Widget, data: ?*c_void) callconv(.C) void {
    c.Fl_Box_set_label(@ptrCast(*c.Fl_Box, data), "Hello World!");
    c.Fl_Button_set_color(@ptrCast(*c.Fl_Button, w), c.Fl_Color_Cyan);
}

pub fn main() void {
    c.Fl_set_scheme("gtk+");
    var win = c.Fl_Window_new(100, 100, 400, 300, "Hello");
    var but = c.Fl_Button_new(160, 220, 80, 40, "Click me!");
    var box = c.Fl_Box_new(10, 10, 380, 180, "");
    c.Fl_Window_end(win);
    c.Fl_Window_show(win);
    c.Fl_Button_set_callback(but, but_cb, box);
    
    _ = c.Fl_run();
}
```
Hopefully I would get some time to work on a more idiomatic Zig wrapper.

![alt_test](assets/image.jpg)
