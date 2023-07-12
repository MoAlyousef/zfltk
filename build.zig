const std = @import("std");
const Build = std.Build;
const CompileStep = std.build.CompileStep;

pub const SdkOpts = struct {
    use_wayland: bool = false,
    system_jpeg: bool = false,
    system_png: bool = false,
    system_zlib: bool = false,
    use_zig_cc: bool = false,
};

const Sdk = @This();
builder: *Build,
install_prefix: []const u8,
finalize_cfltk: *std.Build.Step,
opts: SdkOpts,

pub fn init(b: *Build) !*Sdk {
    return init_with_opts(b, .{});
}

pub fn init_with_opts(b: *Build, opts: SdkOpts) !*Sdk {
    var final_opts = opts;
    final_opts.use_wayland = b.option(bool, "zfltk-use-wayland", "build zfltk for wayland") orelse opts.use_wayland;
    final_opts.system_jpeg = b.option(bool, "zfltk-system-libjpeg", "link system libjpeg") orelse opts.system_jpeg;
    final_opts.system_png = b.option(bool, "zfltk-system-libpng", "link system libpng") orelse opts.system_png;
    final_opts.system_zlib = b.option(bool, "zfltk-system-zlib", "link system zlib") orelse opts.system_zlib;
    final_opts.use_zig_cc = b.option(bool, "zfltk-use-zigcc", "use zig cc and zig c++ to build FLTK and cfltk") orelse opts.use_zig_cc;
    const install_prefix = b.install_prefix;
    const finalize_cfltk = b.step("finalize cfltk install", "Installs cfltk");
    try cfltk_build_from_source(b, finalize_cfltk, install_prefix, final_opts);
    b.default_step.dependOn(finalize_cfltk);
    const sdk = b.allocator.create(Sdk) catch @panic("out of memory");
    sdk.* = .{
        .builder = b,
        .install_prefix = install_prefix,
        .finalize_cfltk = finalize_cfltk,
        .opts = final_opts,
    };
    return sdk;
}

pub fn getZfltkModule(sdk: *Sdk, b: *Build) *Build.Module {
    _ = sdk;
    return b.createModule(.{
        .source_file = .{ .path = thisDir() ++ "/src/zfltk.zig" },
    });
}

pub fn link(sdk: *Sdk, exe: *CompileStep) !void {
    exe.step.dependOn(sdk.finalize_cfltk);
    const install_prefix = sdk.install_prefix;
    try cfltk_link(exe, install_prefix, sdk.opts);
}

pub fn build(b: *Build) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardOptimizeOption(.{});
    const sdk = try Sdk.init(b);
    const zfltk_module = sdk.getZfltkModule(b);
    const examples_step = b.step("examples", "build the examples");
    b.default_step.dependOn(examples_step);

    for (examples) |example| {
        const exe = b.addExecutable(.{
            .name = example.output,
            .root_source_file = .{ .path = example.input },
            .optimize = mode,
            .target = target,
        });
        exe.addModule("zfltk", zfltk_module);
        try sdk.link(exe);
        examples_step.dependOn(&exe.step);
        b.installArtifact(exe);

        const run_cmd = b.addRunArtifact(exe);
        const run_step = b.step(b.fmt("run-{s}", .{example.output}), example.description.?);
        run_step.dependOn(&run_cmd.step);
    }
}

// detail

inline fn thisDir() []const u8 {
    return comptime std.fs.path.dirname(@src().file) orelse @panic("error");
}

const Example = struct {
    description: ?[]const u8,
    output: []const u8,
    input: []const u8,

    pub fn init(output: []const u8, input: []const u8, desc: ?[]const u8) Example {
        return Example{
            .description = desc,
            .output = output,
            .input = input,
        };
    }
};

const examples = &[_]Example{
    Example.init("simple", "examples/simple.zig", "A simple hello world app"),
    Example.init("capi", "examples/capi.zig", "Using the C-api directly"),
    Example.init("customwidget", "examples/customwidget.zig", "Custom widget example"),
    Example.init("image", "examples/image.zig", "Simple image example"),
    Example.init("input", "examples/input.zig", "Simple input example"),
    Example.init("mixed", "examples/mixed.zig", "Mixing both c and zig apis"),
    Example.init("editor", "examples/editor.zig", "More complex example"),
    Example.init("layout", "examples/layout.zig", "Layout example"),
    Example.init("valuators", "examples/valuators.zig", "valuators example"),
    Example.init("channels", "examples/channels.zig", "Use messages to handle events"),
    Example.init("editormsgs", "examples/editormsgs.zig", "Use messages in the editor example"),
    Example.init("browser", "examples/browser.zig", "Browser example"),
    Example.init("flex", "examples/flex.zig", "Flex example"),
    Example.init("threadawake", "examples/threadawake.zig", "Thread awake example"),
    Example.init("handle", "examples/handle.zig", "Handle example"),
    Example.init("flutterlike", "examples/flutterlike.zig", "Flutter-like example"),
    Example.init("glwin", "examples/glwin.zig", "OpenGL window example"),
};

fn cfltk_build_from_source(b: *Build, finalize_cfltk: *Build.Step, install_prefix: []const u8, opts: SdkOpts) !void {
    const zig_exe = b.zig_exe;
    var zig_cc_buf: [250]u8 = undefined;
    var zig_cpp_buf: [250]u8 = undefined;
    const use_zig_cc = switch (opts.use_zig_cc) {
        false => "",
        true => try std.fmt.bufPrint(zig_cc_buf[0..], "-DCMAKE_C_COMPILER={s};cc", .{zig_exe}),
    };
    const use_zig_cpp = switch (opts.use_zig_cc) {
        false => "",
        true => try std.fmt.bufPrint(zig_cpp_buf[0..], "-DCMAKE_CXX_COMPILER={s};c++", .{zig_exe}),
    };
    const target = b.host.target;
    var buf: [1024]u8 = undefined;
    var sdk_lib_dir = try std.fmt.bufPrint(buf[0..], "{s}/cfltk/lib", .{install_prefix});
    _ = std.fs.cwd().openDir(sdk_lib_dir, .{}) catch |err| {
        std.debug.print("Warning: {!}. The cfltk library will be rebuilt from source!\n", .{err});
        var bin_buf: [250]u8 = undefined;
        var src_buf: [250]u8 = undefined;
        var inst_buf: [250]u8 = undefined;
        var cmake_bin_path = try std.fmt.bufPrint(bin_buf[0..], "{s}/cfltk/bin", .{install_prefix});
        var cmake_src_path = try std.fmt.bufPrint(src_buf[0..], "{s}/cfltk", .{install_prefix});
        var cmake_inst_path = try std.fmt.bufPrint(inst_buf[0..], "-DCMAKE_INSTALL_PREFIX={s}/cfltk/lib", .{install_prefix});
        var zfltk_config: *std.Build.Step.Run = undefined;
        const which_png = switch (opts.system_png) {
            false => "-DOPTION_USE_SYSTEM_LIBPNG=OFF",
            true => "-DOPTION_USE_SYSTEM_LIBPNG=ON",
        };
        const which_jpeg = switch (opts.system_jpeg) {
            false => "-DOPTION_USE_SYSTEM_LIBJPEG=OFF",
            true => "-DOPTION_USE_SYSTEM_LIBJPEG=ON",
        };
        const which_zlib = switch (opts.system_zlib) {
            false => "-DOPTION_USE_SYSTEM_ZLIB=OFF",
            true => "-DOPTION_USE_SYSTEM_ZLIB=ON",
        };
        if (target.os.tag == .windows) {
            zfltk_config = b.addSystemCommand(&[_][]const u8{
                "cmake",
                "-B",
                cmake_bin_path,
                "-S",
                cmake_src_path,
                "-GNinja",
                "-DCMAKE_BUILD_TYPE=Release",
                use_zig_cc,
                use_zig_cpp,
                cmake_inst_path,
                "-DFLTK_BUILD_TEST=OFF",
                which_png,
                which_jpeg,
                which_zlib,
                "-DOPTION_USE_GL=ON",
                "-DCFLTK_USE_OPENGL=ON",
                "-DFLTK_BUILD_FLUID=OFF",
                "-DFLTK_BUILD_FLTK_OPTIONS=OFF",
            });
        } else if (target.isDarwin()) {
            zfltk_config = b.addSystemCommand(&[_][]const u8{
                "cmake",
                "-B",
                cmake_bin_path,
                "-S",
                cmake_src_path,
                "-DCMAKE_BUILD_TYPE=Release",
                use_zig_cc,
                use_zig_cpp,
                cmake_inst_path,
                "-DFLTK_BUILD_TEST=OFF",
                which_png,
                which_jpeg,
                which_zlib,
                "-DOPTION_USE_GL=ON",
                "-DCFLTK_USE_OPENGL=ON",
                "-DFLTK_BUILD_FLUID=OFF",
                "-DFLTK_BUILD_FLTK_OPTIONS=OFF",
            });
        } else {
            if (opts.use_wayland) {
                zfltk_config = b.addSystemCommand(&[_][]const u8{
                    "cmake",
                    "-B",
                    cmake_bin_path,
                    "-S",
                    cmake_src_path,
                    "-DCMAKE_BUILD_TYPE=Release",
                    use_zig_cc,
                    use_zig_cpp,
                    cmake_inst_path,
                    "-DFLTK_BUILD_TEST=OFF",
                    which_png,
                    which_jpeg,
                    which_zlib,
                    "-DOPTION_USE_GL=ON",
                    "-DCFLTK_USE_OPENGL=ON",
                    "-DOPTION_USE_WAYLAND=ON",
                    "-DFLTK_BUILD_FLUID=OFF",
                    "-DFLTK_BUILD_FLTK_OPTIONS=OFF",
                    "-DOPTION_ALLOW_GTK_PLUGIN=OFF",
                });
            } else {
                zfltk_config = b.addSystemCommand(&[_][]const u8{
                    "cmake",
                    "-B",
                    cmake_bin_path,
                    "-S",
                    cmake_src_path,
                    "-DCMAKE_BUILD_TYPE=Release",
                    use_zig_cc,
                    use_zig_cpp,
                    cmake_inst_path,
                    "-DFLTK_BUILD_TEST=OFF",
                    which_png,
                    which_jpeg,
                    which_zlib,
                    "-DOPTION_USE_PANGO=ON", // enable if rtl/cjk font support is needed
                    "-DOPTION_USE_GL=ON",
                    "-DCFLTK_USE_OPENGL=ON",
                    "-DOPTION_USE_WAYLAND=OFF",
                    "-DOPTION_USE_CAIRO=ON",
                    "-DFLTK_BUILD_FLUID=OFF",
                    "-DFLTK_BUILD_FLTK_OPTIONS=OFF",
                });
            }
        }
        _ = std.fs.cwd().openDir(cmake_src_path, .{}) catch |git_err| {
            std.debug.print("Warning: {!}. The cfltk library will be grabbed!\n", .{git_err});
            const cfltk_fetch = b.addSystemCommand(&[_][]const u8{ "git", "clone", "https://github.com/MoAlyousef/cfltk", cmake_src_path, "--depth=1", "--recurse-submodules" });
            zfltk_config.step.dependOn(&cfltk_fetch.step);
        };
        const zfltk_build = b.addSystemCommand(&[_][]const u8{
            "cmake",
            "--build",
            cmake_bin_path,
            "--config",
            "Release",
            "--parallel",
        });
        zfltk_build.step.dependOn(&zfltk_config.step);

        // This only needs to run once!
        const zfltk_install = b.addSystemCommand(&[_][]const u8{
            "cmake",
            "--install",
            cmake_bin_path,
        });
        zfltk_install.step.dependOn(&zfltk_build.step);
        finalize_cfltk.dependOn(&zfltk_install.step);
    };
}

fn cfltk_link(exe: *CompileStep, install_prefix: []const u8, opts: SdkOpts) !void {
    var buf: [1024]u8 = undefined;
    const target = exe.target;
    var inc_dir = try std.fmt.bufPrint(buf[0..], "{s}/cfltk/include", .{install_prefix});
    exe.addIncludePath(inc_dir);
    var lib_dir = try std.fmt.bufPrint(buf[0..], "{s}/cfltk/lib/lib", .{install_prefix});
    exe.addLibraryPath(lib_dir);
    exe.linkSystemLibrary("cfltk");
    exe.linkSystemLibrary("fltk");
    exe.linkSystemLibrary("fltk_images");
    if (opts.system_png) {
        exe.linkSystemLibrary("png");
    } else {
        exe.linkSystemLibrary("fltk_png");
    }
    if (opts.system_jpeg) {
        exe.linkSystemLibrary("jpeg");
    } else {
        exe.linkSystemLibrary("fltk_jpeg");
    }
    if (opts.system_zlib) {
        exe.linkSystemLibrary("z");
    } else {
        exe.linkSystemLibrary("fltk_z");
    }
    exe.linkSystemLibrary("fltk_gl");
    exe.linkLibC();
    exe.linkLibCpp();
    if (target.isWindows()) {
        exe.linkSystemLibrary("ws2_32");
        exe.linkSystemLibrary("comctl32");
        exe.linkSystemLibrary("gdi32");
        exe.linkSystemLibrary("oleaut32");
        exe.linkSystemLibrary("ole32");
        exe.linkSystemLibrary("uuid");
        exe.linkSystemLibrary("shell32");
        exe.linkSystemLibrary("advapi32");
        exe.linkSystemLibrary("comdlg32");
        exe.linkSystemLibrary("winspool");
        exe.linkSystemLibrary("user32");
        exe.linkSystemLibrary("kernel32");
        exe.linkSystemLibrary("odbc32");
        exe.linkSystemLibrary("gdiplus");
        exe.linkSystemLibrary("opengl32");
        exe.linkSystemLibrary("glu32");
    } else if (target.isDarwin()) {
        exe.linkFramework("Carbon");
        exe.linkFramework("Cocoa");
        exe.linkFramework("ApplicationServices");
        exe.linkFramework("OpenGL");
    } else {
        if (opts.use_wayland) {
            exe.linkSystemLibrary("wayland-client");
            exe.linkSystemLibrary("wayland-cursor");
            exe.linkSystemLibrary("xkbcommon");
            exe.linkSystemLibrary("dbus-1");
            exe.linkSystemLibrary("EGL");
            exe.linkSystemLibrary("wayland-egl");
        }
        exe.linkSystemLibrary("GL");
        exe.linkSystemLibrary("GLU");
        exe.linkSystemLibrary("pthread");
        exe.linkSystemLibrary("X11");
        exe.linkSystemLibrary("Xext");
        exe.linkSystemLibrary("Xinerama");
        exe.linkSystemLibrary("Xcursor");
        exe.linkSystemLibrary("Xrender");
        exe.linkSystemLibrary("Xfixes");
        exe.linkSystemLibrary("Xft");
        exe.linkSystemLibrary("fontconfig");
        exe.linkSystemLibrary("pango-1.0");
        exe.linkSystemLibrary("pangoxft-1.0");
        exe.linkSystemLibrary("gobject-2.0");
        exe.linkSystemLibrary("cairo");
        exe.linkSystemLibrary("pangocairo-1.0");
    }
}
