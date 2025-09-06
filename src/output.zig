const zfltk = @import("zfltk.zig");
const app = zfltk.app;
const Widget = zfltk.Widget;
const enums = zfltk.enums;
const Event = enums.Event;
const Color = enums.Color;
const Font = enums.Font;
const std = @import("std");
const c = zfltk.c;
const widget = zfltk.widget;

const OutputKind = enum {
    normal,
    multiline,
};

pub const Output = OutputType(.normal);
pub const MultilineOutput = OutputType(.multiline);

fn OutputType(comptime kind: OutputKind) type {
    return struct {
        const Self = @This();

        // Namespaced widget methods (Zig 0.15.1 no usingnamespace)
        pub const widget_ns = zfltk.widget.methods(Self, RawPtr);
        pub inline fn widget(self: *Self) *Widget { return widget_ns.widget(self); }
        pub inline fn raw(self: *Self) RawPtr { return widget_ns.raw(self); }
        pub inline fn fromRaw(ptr: *anyopaque) *Self { return widget_ns.fromRaw(ptr); }

        const OutputRawPtr = *c.Fl_Output;

        pub const RawPtr = switch (kind) {
            .normal => *c.Fl_Output,
            .multiline => *c.Fl_Multiline_Output,
        };

        pub fn init(opts: Widget.Options) !*Self {
            const initFn = switch (kind) {
                .normal => c.Fl_Output_new,
                .multiline => c.Fl_Multiline_Output_new,
            };

            const label = if (opts.label != null) opts.label.?.ptr else null;

            if (initFn(opts.x, opts.y, opts.w, opts.h, label)) |ptr| {
                return Self.fromRaw(ptr);
            }

            unreachable;
        }

        pub inline fn deinit(self: *Self) void {
            const deinitFn = switch (kind) {
                .normal => c.Fl_Output_delete,
                .multiline => c.Fl_Multiline_Output_delete,
            };

            deinitFn(self.raw());
            app.allocator.destroy(self);
        }

        pub inline fn input(self: *Self) *OutputType(.normal) {
            return @ptrCast(self);
        }

        pub fn value(self: *Self) [:0]const u8 {
            return std.mem.span(c.Fl_Output_value(self.input().raw()));
        }

        pub fn insert(self: *Output, val: [*c]const u8, idx: u16) !void {
            _ = c.Fl_Output_insert(self.input().raw(), val, idx);
        }

        // TODO: handle errors
        pub fn setValue(self: *Output, val: [*c]const u8) !void {
            _ = c.Fl_Output_set_value(self.input().raw(), val);
        }

        pub fn position(self: *Output) u16 {
            return @intCast(c.Fl_Output_position(self.input().raw()));
        }

        pub fn setPosition(self: *Output, sz: u16) !void {
            _ = c.Fl_Output_set_position(self.input().raw(), sz);
        }

        pub fn setTextFont(self: *Output, font: Font) void {
            c.Fl_Output_set_text_font(self.input().raw(), @intFromEnum(font));
        }

        pub fn setTextColor(self: *Output, col: Color) void {
            c.Fl_Output_set_text_color(self.input().raw(), col.toRgbi());
        }

        pub fn setTextSize(self: *Output, sz: i32) void {
            c.Fl_Output_set_text_size(self.input().raw(), sz);
        }
    };
}

test "all" {
    @import("std").testing.refAllDeclsRecursive(@This());
}
