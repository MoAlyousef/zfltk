const zfltk = @import("zfltk.zig");
const app = zfltk.app;
const Widget = zfltk.widget.Widget;
const enums = zfltk.enums;
const Event = enums.Event;
const Color = enums.Color;
const Font = enums.Font;
const std = @import("std");
const widget = zfltk.widget;
const c = zfltk.c;

pub const Input = InputType(.normal);
pub const MultilineInput = InputType(.multiline);
pub const IntInput = InputType(.int);
pub const FloatInput = InputType(.float);
pub const Secret = InputType(.secret);

const InputKind = enum {
    normal,
    multiline,
    int,
    float,
    secret,
};

fn InputType(comptime kind: InputKind) type {
    return struct {
        const Self = @This();

        pub usingnamespace zfltk.widget.methods(Self, RawPtr);

        const InputRawPtr = *c.Fl_Input;

        pub const RawPtr = switch (kind) {
            .normal => *c.Fl_Input,
            .multiline => *c.Fl_Multiline_Input,
            .int => *c.Fl_Int_Input,
            .float => *c.Fl_Float_Input,
            .secret => *c.Fl_Secret_Input,
        };

        pub fn init(opts: Widget.Options) !*Self {
            const initFn = switch (kind) {
                .normal => c.Fl_Input_new,
                .multiline => c.Fl_Multiline_Input_new,
                .int => c.Fl_Int_Input_new,
                .float => c.Fl_Float_Input_new,
                .secret => c.Fl_Secret_Input_new,
            };

            const label = if (opts.label != null) opts.label.?.ptr else null;

            if (initFn(opts.x, opts.y, opts.w, opts.h, label)) |ptr| {
                return Self.fromRaw(ptr);
            }

            unreachable;
        }

        pub inline fn deinit(self: *Self) void {
            const deinitFn = switch (kind) {
                .normal => c.Fl_Input_delete,
                .multiline => c.Fl_Multiline_Input_delete,
                .int => c.Fl_Int_Input_delete,
                .float => c.Fl_Float_Input_delete,
                .secret => c.Fl_Secret_Input_delete,
            };

            deinitFn(self.raw());
            app.allocator.destroy(self);
        }

        pub inline fn input(self: *Self) *InputType(.normal) {
            return @ptrCast(self);
        }

        pub fn value(self: *Self) [:0]const u8 {
            return std.mem.span(c.Fl_Input_value(self.input().raw()));
        }

        pub fn insert(self: *Input, val: [*c]const u8, idx: u16) !void {
            _ = c.Fl_Input_insert(self.input().raw(), val, idx);
        }

        // TODO: handle errors
        pub fn setValue(self: *Input, val: [*c]const u8) !void {
            _ = c.Fl_Input_set_value(self.input().raw(), val);
        }

        pub fn position(self: *Input) u16 {
            return @intCast(c.Fl_Input_position(self.input().raw()));
        }

        pub fn setPosition(self: *Input, sz: u16) !void {
            _ = c.Fl_Input_set_position(self.input().raw(), sz);
        }

        pub fn setTextFont(self: *Input, font: Font) void {
            c.Fl_Input_set_text_font(self.input().raw(), @intFromEnum(font));
        }

        pub fn setTextColor(self: *Input, col: Color) void {
            c.Fl_Input_set_text_color(self.input().raw(), col.input().raw()());
        }

        pub fn setTextSize(self: *Input, sz: i32) void {
            c.Fl_Input_set_text_size(self.input().raw(), sz);
        }
    };
}

test "all" {
    @import("std").testing.refAllDeclsRecursive(@This());
}
