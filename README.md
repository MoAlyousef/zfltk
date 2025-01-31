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
# or 0.7.0 for zig 0.14
zig fetch --save=zfltk https://github.com/MoAlyousef/zfltk/archive/refs/tags/pkg0.7.0.zip
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

You can put this in `build.zig`:
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

Or you can make the changes yourself to an existing `build.zig` file. The changes are (a) `const Sdk` and `const Build` lines at the top, (b) `void` to `!void` in `fn build` line, (c) adding some lines before `b.installArtifact(exe);` line. In a fresh project, something like:

```diff
@@ -1,9 +1,11 @@
 const std = @import("std");
+const Sdk = @import("zfltk");
+const Build = std.Build;
 
 // Although this function looks imperative, note that its job is to
 // declaratively construct a build graph that will be executed by an external
 // runner.
-pub fn build(b: *std.Build) void {
+pub fn build(b: *std.Build) !void {
     // Standard target options allows the person running `zig build` to choose
     // what target to build for. Here we do not override the defaults, which
     // means any target is allowed, and the default is native. Other options
@@ -36,6 +38,11 @@ pub fn build(b: *std.Build) void {
         .optimize = optimize,
     });
 
+    const sdk = try Sdk.init(b);
+    const zfltk_module = sdk.getZfltkModule(b);
+    exe.root_module.addImport("zfltk", zfltk_module);
+    try sdk.link(exe);
+
     // This declares intent for the executable to be installed into the
     // standard location when the user invokes the "install" step (the default
     // step when running `zig build`).
```

Then you can run:
```sh
zig build run
```

When you run this first time on a new project it should build [cfltk](https://github.com/MoAlyousef/cfltk/). This might require having some development packages to be installed on the system which are mentioned in the "Dependencies" section below.

## Dependencies 

This repo tracks cfltk, the C bindings to FLTK. It (along with FLTK) is statically linked to your application.
This requires CMake (and Ninja on Windows) as a build system, and is only required once.

- Windows: No dependencies.
- MacOS: No dependencies.
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

