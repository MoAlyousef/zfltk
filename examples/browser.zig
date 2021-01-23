const zfltk = @import("zfltk");
const app = zfltk.app;
const window = zfltk.window;
const browser = zfltk.browser;

pub fn main() !void {
    try app.init();
    var win = window.Window.new(200, 200, 900, 300, "");
    var mybrowser = browser.MultiBrowser.new(10, 10, 900 - 20, 300 - 20, "");
    const widths = [_:0]i32{50, 50, 50, 70, 70, 40, 40, 70, 70, 50};
    var b = mybrowser.asBrowser();
    b.setColumnWidths(&widths);
    b.setColumnChar('\t');
    b.add("USER\tPID\t%CPU\t%MEM\tVSZ\tRSS\tTTY\tSTAT\tSTART\tTIME\tCOMMAND");
    b.add("root\t2888\t0.0\t0.0\t1352\t0\ttty3\tSW\tAug15\t0:00\t@b@f/sbin/mingetty tty3");
    b.add("erco\t2889\t0.0\t13.0\t221352\t0\ttty3\tR\tAug15\t1:34\t@b@f/usr/local/bin/render a35 0004");
    b.add("uucp\t2892\t0.0\t0.0\t1352\t0\tttyS0\tSW\tAug15\t0:00\t@b@f/sbin/agetty -h 19200 ttyS0 vt100");
    b.add("root\t13115\t0.0\t0.0\t1352\t0\ttty2\tSW\tAug30\t0:00\t@b@f/sbin/mingetty tty2");
    b.add(
        "root\t13464\t0.0\t0.0\t1352\t0\ttty1\tSW\tAug30\t0:00\t@b@f/sbin/mingetty tty1 --noclear",
    );
    win.asGroup().end();
    win.asWidget().show();
    try app.run();
}