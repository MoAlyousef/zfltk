const zfltk = @import("zfltk.zig");
const Widget = @import("widget.zig").Widget;
const c = zfltk.c;
const widget = zfltk.widget;
const enums = zfltk.enums;
const std = @import("std");
const app = zfltk.app;

pub const Slider = ValuatorType(.slider);
pub const Dial = ValuatorType(.dial);
pub const Counter = ValuatorType(.counter);
pub const Scrollbar = ValuatorType(.scrollbar);
pub const Adjuster = ValuatorType(.adjuster);
pub const Roller = ValuatorType(.roller);

const ValuatorKind = enum {
    slider,
    dial,
    counter,
    scrollbar,
    adjuster,
    roller,
};

pub const SliderType = enum(i32) {
    /// vertical slider
    vertical = 0,
    /// horizontal slider
    horizontal = 1,
    /// vertical fill slider
    vertical_fill = 2,
    /// horizontal fill slider
    horizontal_fill = 3,
    /// vertical nice slider
    vertical_nice = 4,
    /// horizontal nice slider
    horizontal_nice = 5,
};

pub const ScrollbarType = enum(i32) {
    /// vertical scrollbar
    vertical = 0,
    /// horizontal scrollbar
    horizontal = 1,
    /// vertical fill scrollbar
    vertical_fill = 2,
    /// horizontal fill scrollbar
    horizontal_fill = 3,
    /// vertical nice scrollbar
    vertical_nice = 4,
    /// horizontal nice scrollbar
    horizontal_nice = 5,
};

pub const DialType = enum(i32) {
    /// normal dial
    normal = 0,
    /// line dial
    line = 1,
    /// filled dial
    fill = 2,
};

pub const CounterType = enum(i32) {
    /// normal counter
    normal = 0,
    /// simple counter
    simple = 1,
};

fn ValuatorType(comptime kind: ValuatorKind) type {
    return struct {
        const Self = @This();

        // Namespaced method sets (Zig 0.15.1 no usingnamespace)
        pub const widget_ns = zfltk.widget.methods(Self, RawPtr);
        pub inline fn widget_methods(self: *Self) zfltk.widget.MethodsProxy(Self, RawPtr) { return .{ .self = self }; }
        pub inline fn widget(self: *Self) *Widget { return widget_ns.widget(self); }
        pub inline fn raw(self: *Self) RawPtr { return widget_ns.raw(self); }
        pub inline fn fromRaw(ptr: *anyopaque) *Self { return widget_ns.fromRaw(ptr); }
        pub const valuator_methods = methods(Self, RawPtr);
        pub const RawPtr = switch (kind) {
            .slider => *c.Fl_Slider,
            .dial => *c.Fl_Dial,
            .counter => *c.Fl_Counter,
            .scrollbar => *c.Fl_Scrollbar,
            .adjuster => *c.Fl_Adjuster,
            .roller => *c.Fl_Roller,
        };
        const type_name = @typeName(RawPtr);
        const ptr_name = type_name[(std.mem.indexOf(u8, type_name, "struct_Fl_") orelse 0) + 7 .. type_name.len];

        pub const Options = struct {
            x: i32 = 0,
            y: i32 = 0,
            w: u31 = 0,
            h: u31 = 0,

            label: ?[:0]const u8 = null,

            orientation: Orientation = switch (kind) {
                .slider, .scrollbar => .vertical,

                else => .FILLER,
            },

            style: Style = switch (kind) {
                .slider, .scrollbar, .counter => .normal,

                else => .FILLER,
            },

            pub const Orientation = switch (kind) {
                .slider, .scrollbar => enum(c_int) {
                    vertical = 0,
                    horizontal = 1,
                },

                else => enum(c_int) { FILLER = 0 },
            };

            pub const Style = switch (kind) {
                .slider, .scrollbar => enum(c_int) {
                    normal = 0,
                    fill = 2,
                    nice = 4,
                },

                .counter => enum(c_int) {
                    normal = 0,
                    simple = 1,
                },

                else => enum(c_int) { FILLER = 0 },
            };
        };

        pub inline fn init(opts: Options) !*Self {
            const initFn = @field(c, ptr_name ++ "_new");
            const label = if (opts.label != null) opts.label.?.ptr else null;

            if (initFn(opts.x, opts.y, opts.w, opts.h, label)) |ptr| {
                const self = Self.fromRaw(ptr);

                const orientation = @intFromEnum(opts.orientation);
                const style = @intFromEnum(opts.style);

                c.Fl_Widget_set_type(zfltk.widget.methods(Self, RawPtr).widgetRaw(self), orientation + style);

                return self;
            }

            unreachable;
        }

        pub inline fn deinit(self: *Self) void {
            const deinitFn = @field(c, ptr_name ++ "_delete");

            deinitFn(self.raw());
            app.allocator.destroy(self);
        }
    };
}

fn methods(comptime Self: type, comptime RawPtr: type) type {
    const type_name = @typeName(RawPtr);
    const ptr_name = type_name[(std.mem.indexOf(u8, type_name, "struct_Fl_") orelse 0) + 7 .. type_name.len];
    return struct {
        pub inline fn valuator(self: *Self) *ValuatorType(.slider) {
            return @ptrCast(self);
        }

        pub inline fn setBounds(self: *Self, a: f64, b: f64) void {
            return @field(c, ptr_name ++ "_set_bounds")(self.raw(), a, b);
        }

        pub inline fn minimum(self: *Self) f64 {
            return @field(c, ptr_name ++ "_minimum")(self.raw());
        }

        pub inline fn setMinimum(self: *Self, a: f64) void {
            @field(c, ptr_name ++ "_set_minimum")(self.raw(), a);
        }

        pub inline fn maximum(self: *Self) f64 {
            return @field(c, ptr_name ++ "_maximum")(self.raw());
        }

        pub inline fn setMaximum(self: *Self, a: f64) void {
            @field(c, ptr_name ++ "_set_maximum")(self.raw(), a);
        }

        pub inline fn setRange(self: *Self, a: f64, b: f64) void {
            return @field(c, ptr_name ++ "_set_range")(self.raw(), a, b);
        }

        pub inline fn setStep(self: *Self, a: f64, b: i32) void {
            return @field(c, ptr_name ++ "_set_step")(self.raw(), a, b);
        }

        pub inline fn step(self: *Self) f64 {
            return @field(c, ptr_name ++ "_step")(self.raw());
        }

        pub inline fn setPrecision(self: *Self, digits: i32) void {
            return @field(c, ptr_name ++ "_set_precision")(self.raw(), digits);
        }

        pub inline fn value(self: *Self) f64 {
            return @field(c, ptr_name ++ "_value")(self.raw());
        }

        pub inline fn setValue(self: *Self, arg2: f64) void {
            return @field(c, ptr_name ++ "_set_value")(self.raw(), arg2);
        }

        pub inline fn format(self: *Self, arg2: [*c]const u8) void {
            return @field(c, ptr_name ++ "_format")(self.raw(), arg2);
        }

        pub inline fn round(self: *Self, arg2: f64) f64 {
            return @field(c, ptr_name ++ "_round")(self.raw(), arg2);
        }

        pub inline fn clamp(self: *Self, arg2: f64) f64 {
            return @field(c, ptr_name ++ "_clamp")(self.raw(), arg2);
        }

        pub inline fn increment(self: *Self, arg2: f64, arg3: i32) f64 {
            return @field(c, ptr_name ++ "_increment")(self.raw(), arg2, arg3);
        }
    };
}

test "all" {
    @import("std").testing.refAllDeclsRecursive(@This());
}
