pub const app = @import("app.zig");
pub const image = @import("image.zig");
pub const widget = @import("widget.zig");
pub const group = @import("group.zig");
pub const window = @import("window.zig");
pub const button = @import("button.zig");
pub const box = @import("box.zig");
pub const enums = @import("enums.zig");
pub const input = @import("input.zig");
pub const output = @import("output.zig");
pub const menu = @import("menu.zig");

pub fn widgetCast(comptime T: type, wid: anytype) T {
    var t = T{ .inner = null };
    return T{
        .inner = @ptrCast(@TypeOf(t.inner), wid.inner),
    };
}
