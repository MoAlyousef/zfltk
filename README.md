# zfltk
A Zig wrapper for the FLTK gui library.

## Building the package from source
```
git clone https://github.com/MoAlyousef/zfltk
cd zfltk
zig build
```

To build the examples, pass `-Dzfltk-build-examples=true` to your `zig build` command.

## Usage
zfltk supports the zig package manager. You can add it as a dependency to your project in your build.zig.zon:
```zig
.{
    .name = "app",
    .version = "0.0.1",
    .paths = .{
        "src",
        "build.zig",
        "build.zig.zon",
    },
    .dependencies = .{
        .zfltk = .{
            .url = "https://github.com/MoAlyousef/zfltk/archive/refs/tags/pkg0.5.0.tar.gz",
        },
    }
}
```
(This is missing the hash, zig build will give you the correct hash, which you should add after the url)

In your build.zig:
```zig
const std = @import("std");
const Sdk = @import("zfltk");
const Build = std.Build;

pub fn build(b: *Build) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "app",
        .root_source_file = b.path("src/main.zig"),
        .optimize = mode,
        .target = target,
    });

    const sdk = try Sdk.init(b);
    const zfltk_module = sdk.getZfltkModule(b);
    exe.root_module.addImport("zfltk", zfltk_module);
    try sdk.link(exe);

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
```
Then you can run:
```
zig build run
```

## Dependencies 

This repo tracks cfltk, the C bindings to FLTK. It (along with FLTK) is statically linked to your application.
This requires CMake (and Ninja on Windows) as a build system, and is only required once.

- Windows: No dependencies.
- MacOS: No dependencies.
- Linux: X11 and OpenGL development headers need to be installed for development. The libraries themselves are available on linux distros with a graphical user interface.

For Debian-based GUI distributions, that means running:
```
sudo apt-get install libx11-dev libxext-dev libxft-dev libxinerama-dev libxcursor-dev libxrender-dev libxfixes-dev libpango1.0-dev libpng-dev libgl1-mesa-dev libglu1-mesa-dev
```
For RHEL-based GUI distributions, that means running:
```
sudo yum groupinstall "X Software Development" && yum install pango-devel libXinerama-devel libpng-devel libstdc++-static
```
For Arch-based GUI distributions, that means running:
```
sudo pacman -S libx11 libxext libxft libxinerama libxcursor libxrender libxfixes libpng pango cairo libgl mesa --needed
```
For Alpine linux:
```
apk add pango-dev fontconfig-dev libxinerama-dev libxfixes-dev libxcursor-dev libpng-dev mesa-gl
```
For nixos:
```
nix-shell --packages rustc cmake git gcc xorg.libXext xorg.libXft xorg.libXinerama xorg.libXcursor xorg.libXrender xorg.libXfixes libcerf pango cairo libGL mesa pkg-config
```

## API
Using the Zig wrapper (under development):
```zig
const zfltk = @import("zfltk");
const app = zfltk.app;
const Window = zfltk.window.Window;
const Button = zfltk.button.Button;
const Box = zfltk.box.Box;
const Color = zfltk.enums.Color;

fn butCb(but: *Button, data: ?*anyopaque) void {
    var box = Box.fromRaw(data.?);

    box.setLabel("Hello World!");

    but.setColor(Color.fromName(.cyan));
}

pub fn main() !void {
    try app.init();
    app.setScheme(.gtk);

    var win = try Window.init(.{
        .w = 400,
        .h = 300,

        .label = "Hello",
    });
    win.freePosition();

    var but = try Button.init(.{
        .x = 160,
        .y = 220,
        .w = 80,
        .h = 40,

        .label = "Click me!",
    });

    but.setDownBox(.flat);

    var box = try Box.init(.{
        .x = 10,
        .y = 10,
        .w = 380,
        .h = 180,

        .boxtype = .up,
    });

    box.setLabelFont(.courier);
    box.setLabelSize(18);

    win.end();
    win.show();

    but.setCallbackEx(butCb, box);
    try app.run();
}
```
The messaging api can also be used:
```zig
const zfltk = @import("zfltk");
const app = zfltk.app;
const Window = zfltk.window.Window;
const Button = zfltk.button.Button;
const Box = zfltk.box.Box;
const enums = zfltk.enums;

pub const Message = enum(usize) {
    // Can't begin with Zero!
    first = 1,
    second,
};

pub fn main() !void {
    try app.init();
    app.setScheme(.gtk);

    var win = try Window.init(.{
        .w = 400,
        .h = 300,

        .label = "Hello",
    });

    var but1 = try Button.init(.{
        .x = 100,
        .y = 220,
        .w = 80,
        .h = 40,

        .label = "Button 1",
    });

    var but2 = try Button.init(.{
        .x = 200,
        .y = 220,
        .w = 80,
        .h = 40,

        .label = "Button 2",
    });

    var mybox = try Box.init(.{
        .x = 10,
        .y = 10,
        .w = 380,
        .h = 180,

        .boxtype = .up,
    });

    mybox.setLabelFont(.courier);
    mybox.setLabelSize(18);

    win.end();
    win.show();
    but1.emit(Message, .first);
    but2.emit(Message, .second);

    while (app.wait()) {
        if (app.recv(Message)) |msg| switch (msg) {
            .first => mybox.setLabel("Button 1 Clicked!"),
            .second => mybox.setLabel("Button 2 Clicked!"),
        };
    }
}
```

Using the C Api directly:
```zig
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
    c.Fl_Box_set_label(@ptrCast(data), "Hello World!");
    c.Fl_Button_set_color(@ptrCast(w), c.Fl_Color_Cyan);
}

pub fn main() !void {
    fltkInit();

    _ = c.Fl_set_scheme("gtk+");
    const win = c.Fl_Window_new(100, 100, 400, 300, "Hello");
    const but = c.Fl_Button_new(160, 220, 80, 40, "Click me!");
    const box = c.Fl_Box_new(10, 10, 380, 180, "");
    c.Fl_Box_set_box(box, c.Fl_BoxType_UpBox);
    c.Fl_Box_set_label_size(box, 18);
    c.Fl_Box_set_label_font(box, c.Fl_Font_Courier);
    c.Fl_Window_end(win);
    c.Fl_Window_show(win);
    c.Fl_Button_set_callback(but, butCb, box);
    _ = c.Fl_run();
}
```
You can also mix and match for any missing functionalities in the Zig wrapper (see examples/mixed.zig).

Widgets also provide a `call` method which allows to call any method that wasn't wrapped yet in the bindings:
```zig
    var flex = try Flex.init(.{
        .w = 400,
        .h = 300,
        .orientation = .vertical,
    });

    flex.call("set_margins", .{10, 20, 10, 20});
```

![alt_test](screenshots/image.jpg)
![alt_test](screenshots/editor.jpg)

[video tutorial](https://youtu.be/D2ijlrDStdM)

