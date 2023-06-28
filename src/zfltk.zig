const std = @import("std");

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

pub const Image = image.Image;
pub const Widget = widget.Widget;
pub const Group = group.Group;
pub const Window = window.Window;
pub const Button = button.Button;
pub const Box = box.Box;
pub const Browser = browser.Browser;
pub const Menu = menu.Menu;
pub const MenuBar = menu.MenuBar;
pub const Input = input.Input;
pub const TextDisplay = text.TextDisplay;
pub const TextBuffer = text.TextBuffer;
pub const FileDialog = dialog.FileDialog;
pub const Valuator = valuator.Valuator;

pub const c = @cImport({
    @cInclude("cfl.h");
    @cInclude("cfl_widget.h");
    @cInclude("cfl_box.h");
    @cInclude("cfl_button.h");
    @cInclude("cfl_window.h");
    @cInclude("cfl_browser.h");
    @cInclude("cfl_input.h");
    @cInclude("cfl_text.h");
    @cInclude("cfl_image.h");
    @cInclude("cfl_enums.h");
    @cInclude("cfl_dialog.h");
    @cInclude("cfl_group.h");
    @cInclude("cfl_draw.h");
    @cInclude("cfl_valuator.h");
});

pub fn widgetCast(comptime T: type, wid: anytype) T {
    return T{
        .inner = @ptrCast(wid.inner),
    };
}

// TODO: improve helper function
// currently can get it sorta working if `comptime T: type` is used as a param
// but I currently can't figure out a way to verify the return value of
// `x.widget()` is equal to type `Widget`. This would make any type with a decl
// of the name `widget` pass the test, which is suboptimal
pub fn isWidget(comptime T: type) bool {
    if (T == *Widget) return true;

    const tfo = @typeInfo(T);
    if (tfo != .Pointer) return false;

    const Child = tfo.Pointer.child;

    if (!@hasDecl(Child, "widget")) {
        return false;
    }

    return true;
}

test "all" {
    @import("std").testing.refAllDecls(@This());
}
