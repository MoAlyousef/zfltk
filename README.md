# zfltk
A Zig wrapper for the FLTK gui library.

## Running the examples
After cloning the repo, run:
```
$ zig build run-simple
$ zig build run-capi
```

## Dependencies 

CMake (version > 3.15), Git and a C++11 compiler need to be installed and in your PATH for a crossplatform build from source.

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
Using the Zig wrapper (under development):
```zig
const zfltk = @import("zfltk");
const app = zfltk.app;
const widget = zfltk.widget;
const window = zfltk.window;
const button = zfltk.button;
const box = zfltk.box;
const enums = zfltk.enums;

pub fn butCb(w: widget.WidgetPtr, data: ?*c_void) callconv(.C) void {
    var mybox = widget.Widget.fromVoidPtr(data);
    mybox.setLabel("Hello World!");
    var but = button.Button.fromWidgetPtr(w); // You can still you a Widget.fromWidgetPtr
    but.asWidget().setColor(enums.Color.Cyan);
}

pub fn main() !void {
    try app.init();
    app.setScheme(.Gtk);
    var win = window.Window.new(100, 100, 400, 300, "Hello");
    var but = button.Button.new(160, 200, 80, 40, "Click");
    var mybox = box.Box.new(0, 0, 400, 200, "");
    win.asGroup().end();
    win.asWidget().show();
    but.asWidget().setCallback(butCb, @ptrCast(?*c_void, mybox.raw()));
    try app.run();
}
```

Using the C Api directly:
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

![alt_test](screenshots/image.jpg)
