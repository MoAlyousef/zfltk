const c = @cImport({
    @cInclude("cfl.h");
    @cInclude("cfl_image.h");
});

const Scheme = enum {
    Base,
    Gtk,
    Plastic,
    Gleam,
};

// fltk initizialization of optional functionalities
pub fn init() !void {
    c.Fl_init_all(); // inits all styles, if needed
    c.Fl_register_images(); // register image types supported by fltk, if needed
    const ret = c.Fl_lock(); // enable multithreading, if needed
    if (ret != 0) {
        unreachable;
    }
}

pub fn run() !void {
    const ret = c.Fl_run();
    if (ret != 0) {
        unreachable;
    }
}

pub fn setScheme(scheme: Scheme) void {
    var temp = switch (scheme) {
        .Base => "base",
        .Gtk => "gtk+",
        .Plastic => "plastic",
        .Gleam => "gleam",
    };
    c.Fl_set_scheme(temp);
}
