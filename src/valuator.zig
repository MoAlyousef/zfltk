const zfltk = @import("zfltk.zig");
const Widget = zfltk.Widget;
const c = zfltk.c;

pub const ValuatorKind = enum {
    slider,
    dial,
    counter,
    scrollbar,
    adjuster,
    roller,
};

pub const SliderType = enum(i32) {
    /// Vertical slider
    Vertical = 0,
    /// Horizontal slider
    Horizontal = 1,
    /// Vertical fill slider
    VerticalFill = 2,
    /// Horizontal fill slider
    HorizontalFill = 3,
    /// Vertical nice slider
    VerticalNice = 4,
    /// Horizontal nice slider
    HorizontalNice = 5,
};

pub const ScrollbarType = enum(i32) {
    /// Vertical scrollbar
    Vertical = 0,
    /// Horizontal scrollbar
    Horizontal = 1,
    /// Vertical fill scrollbar
    VerticalFill = 2,
    /// Horizontal fill scrollbar
    HorizontalFill = 3,
    /// Vertical nice scrollbar
    VerticalNice = 4,
    /// Horizontal nice scrollbar
    HorizontalNice = 5,
};

pub const DialType = enum(i32) {
    /// Normal dial
    Normal = 0,
    /// Line dial
    Line = 1,
    /// Filled dial
    Fill = 2,
};

pub const CounterType = enum(i32) {
    /// Normal counter
    Normal = 0,
    /// Simple counter
    Simple = 1,
};

pub fn Valuator(comptime kind: ValuatorKind) type {
    return struct {
        const Self = @This();

        pub usingnamespace zfltk.widget.methods(Self, RawPtr);
        pub usingnamespace methods(Self);

        pub const RawPtr = switch (kind) {
            .slider => *c.Fl_Slider,
            .dial => *c.Fl_Dial,
            .counter => *c.Fl_Counter,
            .scrollbar => *c.Fl_Scrollbar,
            .adjuster => *c.Fl_Adjuster,
            .roller => *c.Fl_Roller,
        };

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
            const initFn = switch (kind) {
                .slider => c.Fl_Slider_new,
                .dial => c.Fl_Dial_new,
                .counter => c.Fl_Counter_new,
                .scrollbar => c.Fl_Scrollbar_new,
                .adjuster => c.Fl_Adjuster_new,
                .roller => c.Fl_Roller_new,
            };

            const label = if (opts.label != null) opts.label.?.ptr else null;

            if (initFn(opts.x, opts.y, opts.w, opts.h, label)) |ptr| {
                var self = Self.fromRaw(ptr);

                const orientation = @intFromEnum(opts.orientation);
                const style = @intFromEnum(opts.style);

                c.Fl_Widget_set_type(self.widget().raw(), orientation + style);

                return self;
            }

            unreachable;
        }
    };
}

pub fn methods(comptime Self: type) type {
    return struct {
        pub inline fn valuator(self: *Self) *Valuator(.slider) {
            return @ptrCast(self);
        }

        pub fn handle(self: *Self, cb: fn (w: Widget.RawPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
            c.Fl_Slider_handle(self.inner, @ptrCast(cb), data);
        }

        pub fn draw(self: *Self, cb: fn (w: Widget.RawPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
            c.Fl_Slider_handle(self.inner, @ptrCast(cb), data);
        }

        pub inline fn setBounds(self: *Self, a: f64, b: f64) void {
            return c.Fl_Slider_set_bounds(self.valuator().raw(), a, b);
        }

        pub inline fn minimum(self: *Self) f64 {
            return c.Fl_Slider_minimum(self.valuator().raw());
        }

        pub inline fn setMinimum(self: *Self, a: f64) void {
            c.Fl_Slider_set_minimum(self.valuator().raw(), a);
        }

        pub inline fn maximum(self: *Self) f64 {
            return c.Fl_Slider_maximum(self.valuator().raw());
        }

        pub inline fn setMaximum(self: *Self, a: f64) void {
            c.Fl_Slider_set_maximum(self.valuator().raw(), a);
        }

        pub inline fn setRange(self: *Self, a: f64, b: f64) void {
            return c.Fl_Slider_set_range(self.valuator().raw(), a, b);
        }

        pub inline fn setStep(self: *Self, a: f64, b: i32) void {
            return c.Fl_Slider_set_step(self.valuator().raw(), a, b);
        }

        pub inline fn step(self: *Self) f64 {
            return c.Fl_Slider_step(self.valuator().raw());
        }

        pub inline fn setPrecision(self: *Self, digits: i32) void {
            return c.Fl_Slider_set_precision(self.valuator().raw(), digits);
        }

        pub inline fn value(self: *Self) f64 {
            return c.Fl_Slider_value(self.valuator().raw());
        }

        pub inline fn setValue(self: *Self, arg2: f64) void {
            return c.Fl_Slider_set_value(self.valuator().raw(), arg2);
        }

        pub inline fn format(self: *Self, arg2: [*c]const u8) void {
            return c.Fl_Slider_format(self.valuator().raw(), arg2);
        }

        pub inline fn round(self: *Self, arg2: f64) f64 {
            return c.Fl_Slider_round(self.valuator().raw(), arg2);
        }

        pub inline fn clamp(self: *Self, arg2: f64) f64 {
            return c.Fl_Slider_clamp(self.valuator().raw(), arg2);
        }

        pub inline fn increment(self: *Self, arg2: f64, arg3: i32) f64 {
            return c.Fl_Slider_increment(self.valuator().raw(), arg2, arg3);
        }
    };
}

test "all" {
    @import("std").testing.refAllDecls(@This());
}
