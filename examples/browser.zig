const zfltk = @import("zfltk");
const app = zfltk.app;
const Window = zfltk.Window;
const Browser = zfltk.Browser;

pub fn main() !void {
    try app.init();
    var win = try Window.init(.{
        .w = 900,
        .h = 300,
        .label = "Browser demo",
    });

    // Available browsers are: normal, select, hold, multi and file
    var browser = try Browser(.multi).init(.{
        .x = 10,
        .y = 10,
        .w = 900 - 20,
        .h = 300 - 20,
    });

    browser.setColumnWidths(
        &[_:0]i32{ 50, 50, 50, 70, 70, 50, 50, 70, 70, 50 },
    );

    browser.setColumnChar('\t');
    browser.add("USER\tPID\t%CPU\t%MEM\tVSZ\tRSS\tTTY\tSTAT\tSTART\tTIME\tCOMMAND");
    browser.add("root\t2888\t0.0\t0.0\t1352\t0\ttty3\tSW\tAug15\t0:00\t@b@f/sbin/mingetty tty3");
    browser.add("erco\t2889\t0.0\t13.0\t221352\t0\ttty3\tR\tAug15\t1:34\t@b@f/usr/local/bin/render a35 0004");
    browser.add("uucp\t2892\t0.0\t0.0\t1352\t0\tttyS0\tSW\tAug15\t0:00\t@b@f/sbin/agetty -h 19200 ttyS0 vt100");
    browser.add("root\t13115\t0.0\t0.0\t1352\t0\ttty2\tSW\tAug30\t0:00\t@b@f/sbin/mingetty tty2");
    browser.add("root\t13464\t0.0\t0.0\t1352\t0\ttty1\tSW\tAug30\t0:00\t@b@f/sbin/mingetty tty1 --noclear");

    win.group().end();
    win.group().resizable(browser);
    win.widget().show();

    try app.run();
}
