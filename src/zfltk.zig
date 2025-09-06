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

const Widget = widget.Widget;

pub const c = @cImport({
    @cInclude("cfltk/cfl.h");
    @cInclude("cfltk/cfl_widget.h");
    @cInclude("cfltk/cfl_box.h");
    @cInclude("cfltk/cfl_button.h");
    @cInclude("cfltk/cfl_window.h");
    @cInclude("cfltk/cfl_browser.h");
    @cInclude("cfltk/cfl_menu.h");
    @cInclude("cfltk/cfl_input.h");
    @cInclude("cfltk/cfl_text.h");
    @cInclude("cfltk/cfl_image.h");
    @cInclude("cfltk/cfl_enums.h");
    @cInclude("cfltk/cfl_dialog.h");
    @cInclude("cfltk/cfl_group.h");
    @cInclude("cfltk/cfl_draw.h");
    @cInclude("cfltk/cfl_table.h");
    @cInclude("cfltk/cfl_valuator.h");
    @cInclude("cfltk/cfl_tree.h");
});

pub fn widgetCast(comptime T: type, wid: anytype) T {
    return @ptrCast(@alignCast(wid));
}

// TODO: improve helper function
// currently can get it sorta working if `comptime T: type` is used as a param
// but I currently can't figure out a way to verify the return value of
// `x.widget()` is equal to type `Widget`. This would make any type with a decl
// of the name `widget` pass the test, which is suboptimal
pub fn isWidget(comptime T: type) bool {
    if (T == *Widget) return true;

    const tfo = @typeInfo(T);
    if (tfo != .pointer) return false;

    const Child = tfo.pointer.child;

    if (!@hasDecl(Child, "widget")) {
        return false;
    }

    return true;
}

test "all" {
    @import("std").testing.refAllDeclsRecursive(@This());
}

test "smoke" {
    @setEvalBranchQuota(100_000);
    // Smoke test: ensure module parses under Zig 0.15.1
    _ = 0;
}
