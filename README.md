# fltk-zig-example

This is an example repo showing how to build fltk apps using zig.

## Usage
After cloning or using this repo as a template, run:
```
$ zig build
$ ./zig-cache/bin/fltk_app
```

## Dependencies 

CMake (version > 3.0), Git and a C++11 compiler need to be installed and in your PATH for a crossplatform build from source.

- Windows: No dependencies.
- MacOS: No dependencies.
- Linux: X11 and OpenGL development headers need to be installed for development. The libraries themselves are available on linux distros with a graphical user interface.

For Debian-based GUI distributions, that means running:
```
$ sudo apt-get install libx11-dev libxext-dev libxft-dev libxinerama-dev libxcursor-dev libxrender-dev libxfixes-dev libpango1.0-dev libpng-dev libgl1-mesa-dev libglu1-mesa-dev
```
For RHEL-based GUI distributions, that means running:
```
$ sudo yum groupinstall "X Software Development" && yum install pango-devel libXinerama-devel libpng-devel
```
For Arch-based GUI distributions, that means running:
```
$ sudo pacman -S libx11 libxext libxft libxinerama libxcursor libxrender libxfixes libpng pango cairo libgl mesa --needed
```
For Alpine linux:
```
$ apk add pango-dev fontconfig-dev libxinerama-dev libxfixes-dev libxcursor-dev libpng-dev mesa-gl
```

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
