# zfltk
A Zig wrapper for the FLTK gui library.

## Building the package from source
```sh
git clone https://github.com/MoAlyousef/zfltk
cd zfltk
zig build
```

To build the examples, pass `-Dzfltk-build-examples=true` to your `zig build` command.

## Usage
zfltk supports the zig package manager. To create a new project:

```sh
mkdir myproject
cd myproject
zig init
```

This should create `build.zig`, `build.zig.zon` and other files.

You can add zfltk as a dependency to your project with one of these:

```sh
## specific release
# 0.6.0 for zig 0.13
zig fetch --save=zfltk https://github.com/MoAlyousef/zfltk/archive/refs/tags/pkg0.6.0.zip
## or main branch
zig fetch --save=zfltk https://github.com/MoAlyousef/zfltk/archive/refs/heads/main.zip
```

This might add something like this in your `build.zig.zon`:
```zig
.{
    ...
    .dependencies = .{
        .zfltk = .{
            .url = "https://github.com/MoAlyousef/zfltk/archive/refs/tags/pkg0.7.0.zip",
            .hash = "...",
        },
    },
    ...
}
```

You can add the following to your build.zig:
```zig
    const zfltk_dep = b.dependency("zfltk", .{
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("zfltk", zfltk_dep.module("zfltk"));
```

Then you can run:
```sh
zig build run
```

## Dependencies 
zfltk requires a system install of cfltk (which along with fltk will be statically linked to your executable). CMake and a C++ compiler.
You can install cfltk using:
```sh
git clone https://github.com/MoAlyousef/cfltk -b fltk1.4 --recurse-submodules --depth=1
cd cfltk
./scripts/bootstrap_posix.sh # optionally specify a -DCMAKE_INSTALL_PREFX=/some/path
```
This might require super user privileges if no install prefix is provided since it might install to /usr/local.
If you install cfltk into a non-standard search path you would need to supply your executable with an include path and library path:
```zig
    exe.addLibraryPath("/some/path/include");
    exe.addIncludePath("/some/path/lib");
```
Alternatively you can supply the zig executable with a search prefix:
```bash
zig build --search-prefix /some/path
```
cfltk dependencies:
- Windows: With mingw, no dependencies.
- MacOS: MacOS SDK.
- Linux: X11 and OpenGL development headers need to be installed for development. The libraries themselves are available on linux distros with a graphical user interface.

For Debian-based GUI distributions, that means running:
```sh
sudo apt-get install libx11-dev libxext-dev libxft-dev libxinerama-dev libxcursor-dev libxrender-dev libxfixes-dev libpango1.0-dev libpng-dev libgl1-mesa-dev libglu1-mesa-dev
```
For RHEL-based GUI distributions, that means running:
```sh
sudo yum groupinstall "X Software Development" && yum install pango-devel libXinerama-devel libpng-devel libstdc++-static
```
For Arch-based GUI distributions, that means running:
```sh
sudo pacman -S libx11 libxext libxft libxinerama libxcursor libxrender libxfixes libpng pango cairo libgl mesa --needed
```
For Alpine linux:
```sh
apk add pango-dev fontconfig-dev libxinerama-dev libxfixes-dev libxcursor-dev libpng-dev mesa-gl
```
For nixos:
```sh
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
    @cInclude("cfltk/cfl.h"); // Fl_init_all, Fl_run
    @cInclude("cfltk/cfl_enums.h"); // Fl_Color_*
    @cInclude("cfltk/cfl_image.h"); // Fl_register_images
    @cInclude("cfltk/cfl_button.h"); // Fl_Button
    @cInclude("cfltk/cfl_box.h"); // Fl_Box
    @cInclude("cfltk/cfl_window.h"); // Fl_Window
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

