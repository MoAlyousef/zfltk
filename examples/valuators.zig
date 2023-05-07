const zfltk = @import("zfltk");
const app = zfltk.app;
const Widget = zfltk.Widget;
const Window = zfltk.Window;
const valuator = zfltk.valuator;
const Group = zfltk.Group;
const enums = zfltk.enums;
const Valuator = zfltk.Valuator;

pub fn main() !void {
    try app.init();
    app.setScheme(.gtk);

    var win = try Window.init(.{
        .w = 400,
        .h = 300,

        .label = "Valuators",
    });

    var pack = try Group(.pack).init(.{
        .w = 400,
        .h = 300,

        .spacing = 40,
    });

    pack.add(.{
        try Valuator(.slider).init(.{
            .h = 40,
            .style = .nice,
            .orientation = .horizontal,
            .label = "Slider",
        }),

        try Valuator(.scrollbar).init(.{
            .h = 40,
            .style = .nice,
            .orientation = .horizontal,
            .label = "Scrollbar",
        }),

        try Valuator(.counter).init(.{
            .h = 40,
            .w = win.w(),
            .label = "Counter",
        }),

        try Valuator(.adjuster).init(.{
            .h = 40,
            .label = "Adjuster",
        }),
    });

    pack.end();
    win.end();
    win.show();
    try app.run();
}
