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
pub const text = @import("text.zig");
pub const dialog = @import("dialog.zig");
pub const valuator = @import("valuator.zig");
pub const browser = @import("browser.zig");
pub const table = @import("table.zig");
pub const tree = @import("tree.zig");
pub const draw = @import("draw.zig");

pub fn widgetCast(comptime T: type, wid: anytype) T {
    var t = T{ .inner = null };
    return T{
        .inner = @ptrCast(@TypeOf(t.inner), wid.inner),
    };
}

test "all" {
    @import("std").testing.refAllDecls(@This());
}
