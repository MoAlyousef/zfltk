const zfltk = @import("zfltk");
const app = zfltk.app;
const Window = zfltk.window.Window;
const valuator = zfltk.valuator;
const Pack = zfltk.group.Pack;
const enums = zfltk.enums;

pub fn main() !void {
    try app.init();
    app.setScheme(.gtk);

    var win = try Window.init(.{
        .w = 400,
        .h = 300,

        .label = "Valuators",
    });

    var pack = try Pack.init(.{
        .w = 400,
        .h = 300,

        .spacing = 40,
    });

    pack.asGroup().add(.{
        try valuator.Slider.init(.{
            .h = 40,
            .style = .nice,
            .orientation = .horizontal,
            .label = "Slider",
        }),

        try valuator.Scrollbar.init(.{
            .h = 40,
            .style = .nice,
            .orientation = .horizontal,
            .label = "Scrollbar",
        }),

        try valuator.Counter.init(.{
            .h = 40,
            .w = win.asWidget().w(),
            .label = "Counter",
        }),

        try valuator.Adjuster.init(.{
            .h = 40,
            .label = "Adjuster",
        }),
    });

    pack.asGroup().end();
    win.asGroup().end();
    win.asWidget().show();
    try app.run();
}
