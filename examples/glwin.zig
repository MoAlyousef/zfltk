const zfltk = @import("zfltk");
const app = zfltk.app;
const GlutWindow = zfltk.window.GlutWindow;
const Mode = zfltk.enums.Mode;

extern fn glClearColor(r: f32, g: f32, b: f32, a: f32) void;
extern fn glClear(v: i32) void;
const GL_COLOR_BUFFER_BIT = 16384;

fn winDraw(win: *GlutWindow) void {
    win.makeCurrent();
    glClearColor(1.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
}

pub fn main() !void {
    try app.init();
    var win = try GlutWindow.init(.{
        .w = 400,
        .h = 300,

        .label = "Hello OpenGL",
    });
    win.setMode(Mode.opengl3 | Mode.multi_sample);
    win.end();
    win.resizable(win);
    win.show();

    win.setDrawHandler(winDraw);
    try app.run();
}
