const c = @cImport({
    @cInclude("cfltk/cfl_valuator.h");
});
const widget = @import("widget.zig");

pub const Valuator = struct {
    inner: ?*c.Fl_Slider,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) Valuator {
        const ptr = c.Fl_Slider_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return Valuator{
            .inner = ptr,
        };
    }

    pub fn raw(self: *const Valuator) ?*c.Fl_Slider {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Slider) Valuator {
        return Valuator{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) Valuator {
        return Valuator{
            .inner = @ptrCast(?*c.Fl_Slider, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*anyopaque) Valuator {
        return Valuator{
            .inner = @ptrCast(?*c.Fl_Slider, ptr),
        };
    }

    pub fn toVoidPtr(self: *const Valuator) ?*anyopaque {
        return @ptrCast(?*anyopaque, self.inner);
    }

    pub fn asWidget(self: *const Valuator) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn handle(self: *const Valuator, cb: fn (w: widget.WidgetPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
        c.Fl_Slider_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *const Valuator, cb: fn (w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Slider_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }

    /// Set bounds of a valuator
    pub fn setBounds(self: *const Valuator, a: f64, b: f64) void {
        return c.Fl_Slider_set_bounds(self.inner, a, b);
    }
    /// Get the minimum bound of a valuator
    pub fn minimum(self: *const Valuator) f64 {
        return c.Fl_Slider_minimum(self.inner);
    }
    /// Set the minimum bound of a valuator
    pub fn setMinimum(self: *const Valuator, a: f64) void {
        return c.Fl_Slider_set_minimum(self.inner, a);
    }
    /// Get the maximum bound of a valuator
    pub fn maximum(self: *const Valuator) f64 {
        return c.Fl_Slider_maximum(self.inner);
    }
    /// Set the maximum bound of a valuator
    pub fn setMaximum(self: *const Valuator, a: f64) void {
        return c.Fl_Slider_set_maximum(self.inner, a);
    }
    /// Set the range of a valuator
    pub fn setRange(self: *const Valuator, a: f64, b: f64) void {
        return c.Fl_Slider_set_range(self.inner, a, b);
    }
    /// Set change step of a valuator
    pub fn setStep(self: *const Valuator, a: f64, b: i32) void {
        return c.Fl_Slider_set_step(self.inner, a, b);
    }
    /// Get change step of a valuator
    pub fn step(self: *const Valuator) f64 {
        return c.Fl_Slider_step(self.inner);
    }
    /// Set the precision of a valuator
    pub fn setPrecision(self: *const Valuator, digits: i32) void {
        return c.Fl_Slider_set_precision(self.inner, digits);
    }
    /// Get the value of a valuator
    pub fn value(self: *const Valuator) f64 {
        return c.Fl_Slider_value(self.inner);
    }
    /// Set the value of a valuator
    pub fn setValue(self: *const Valuator, arg2: f64) void {
        return c.Fl_Slider_set_value(self.inner, arg2);
    }
    /// Set the format of a valuator
    pub fn format(self: *const Valuator, arg2: [*c]const u8) void {
        return c.Fl_Slider_format(self.inner, arg2);
    }
    /// Round the valuator
    pub fn round(self: *const Valuator, arg2: f64) f64 {
        return c.Fl_Slider_round(self.inner, arg2);
    }
    /// Clamp the valuator
    pub fn clamp(self: *const Valuator, arg2: f64) f64 {
        return c.Fl_Slider_clamp(self.inner, arg2);
    }
    /// Increment the valuator
    pub fn increment(self: *const Valuator, arg2: f64, arg3: i32) f64 {
        return c.Fl_Slider_increment(self.inner, arg2, arg3);
    }
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

pub const Slider = struct {
    inner: ?*c.Fl_Slider,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) Slider {
        const ptr = c.Fl_Slider_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return Slider{
            .inner = ptr,
        };
    }

    pub fn raw(self: *const Slider) ?*c.Fl_Slider {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Slider) Slider {
        return Slider{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) Slider {
        return Slider{
            .inner = @ptrCast(?*c.Fl_Slider, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*anyopaque) Slider {
        return Slider{
            .inner = @ptrCast(?*c.Fl_Slider, ptr),
        };
    }

    pub fn toVoidPtr(self: *const Slider) ?*anyopaque {
        return @ptrCast(?*anyopaque, self.inner);
    }

    pub fn asWidget(self: *const Slider) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asValuator(self: *const Slider) Valuator {
        return Valuator{
            .inner = @ptrCast(?*c.Fl_Slider, self.inner),
        };
    }

    pub fn handle(self: *const Slider, cb: fn (w: widget.WidgetPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
        c.Fl_Slider_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *const Slider, cb: fn (w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Slider_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }
};

pub const DialType = enum(i32) {
    /// Normal dial
    Normal = 0,
    /// Line dial
    Line = 1,
    /// Filled dial
    Fill = 2,
};

pub const Dial = struct {
    inner: ?*c.Fl_Dial,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) Dial {
        const ptr = c.Fl_Dial_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return Dial{
            .inner = ptr,
        };
    }

    pub fn raw(self: *const Dial) ?*c.Fl_Dial {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Dial) Dial {
        return Dial{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) Dial {
        return Dial{
            .inner = @ptrCast(?*c.Fl_Dial, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*anyopaque) Dial {
        return Dial{
            .inner = @ptrCast(?*c.Fl_Dial, ptr),
        };
    }

    pub fn toVoidPtr(self: *const Dial) ?*anyopaque {
        return @ptrCast(?*anyopaque, self.inner);
    }

    pub fn asWidget(self: *const Dial) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asValuator(self: *const Dial) Valuator {
        return Valuator{
            .inner = @ptrCast(?*c.Fl_Dial, self.inner),
        };
    }

    pub fn handle(self: *const Dial, cb: fn (w: widget.WidgetPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
        c.Fl_Dial_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *const Dial, cb: fn (w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Dial_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }
};

pub const CounterType = enum(i32) {
    /// Normal counter
    Normal = 0,
    /// Simple counter
    Simple = 1,
};

pub const Counter = struct {
    inner: ?*c.Fl_Counter,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) Counter {
        const ptr = c.Fl_Counter_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return Counter{
            .inner = ptr,
        };
    }

    pub fn raw(self: *const Counter) ?*c.Fl_Counter {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Counter) Counter {
        return Counter{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) Counter {
        return Counter{
            .inner = @ptrCast(?*c.Fl_Counter, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*anyopaque) Counter {
        return Counter{
            .inner = @ptrCast(?*c.Fl_Counter, ptr),
        };
    }

    pub fn toVoidPtr(self: *const Counter) ?*anyopaque {
        return @ptrCast(?*anyopaque, self.inner);
    }

    pub fn asWidget(self: *const Counter) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asValuator(self: *const Counter) Valuator {
        return Valuator{
            .inner = @ptrCast(?*c.Fl_Counter, self.inner),
        };
    }

    pub fn handle(self: *const Counter, cb: fn (w: widget.WidgetPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
        c.Fl_Counter_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *const Counter, cb: fn (w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Counter_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }
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

pub const Scrollbar = struct {
    inner: ?*c.Fl_Scrollbar,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) Scrollbar {
        const ptr = c.Fl_Scrollbar_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return Scrollbar{
            .inner = ptr,
        };
    }

    pub fn raw(self: *const Scrollbar) ?*c.Fl_Scrollbar {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Scrollbar) Scrollbar {
        return Scrollbar{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) Scrollbar {
        return Scrollbar{
            .inner = @ptrCast(?*c.Fl_Scrollbar, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*anyopaque) Scrollbar {
        return Scrollbar{
            .inner = @ptrCast(?*c.Fl_Scrollbar, ptr),
        };
    }

    pub fn toVoidPtr(self: *const Scrollbar) ?*anyopaque {
        return @ptrCast(?*anyopaque, self.inner);
    }

    pub fn asWidget(self: *const Scrollbar) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asValuator(self: *const Scrollbar) Valuator {
        return Valuator{
            .inner = @ptrCast(?*c.Fl_Scrollbar, self.inner),
        };
    }

    pub fn handle(self: *const Scrollbar, cb: fn (w: widget.WidgetPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
        c.Fl_Scrollbar_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *const Scrollbar, cb: fn (w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Scrollbar_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }
};

pub const Adjuster = struct {
    inner: ?*c.Fl_Adjuster,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) Adjuster {
        const ptr = c.Fl_Adjuster_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return Adjuster{
            .inner = ptr,
        };
    }

    pub fn raw(self: *const Adjuster) ?*c.Fl_Adjuster {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Adjuster) Adjuster {
        return Adjuster{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) Adjuster {
        return Adjuster{
            .inner = @ptrCast(?*c.Fl_Adjuster, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*anyopaque) Adjuster {
        return Adjuster{
            .inner = @ptrCast(?*c.Fl_Adjuster, ptr),
        };
    }

    pub fn toVoidPtr(self: *const Adjuster) ?*anyopaque {
        return @ptrCast(?*anyopaque, self.inner);
    }

    pub fn asWidget(self: *const Adjuster) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asValuator(self: *const Adjuster) Valuator {
        return Valuator{
            .inner = @ptrCast(?*c.Fl_Adjuster, self.inner),
        };
    }

    pub fn handle(self: *const Adjuster, cb: fn (w: widget.WidgetPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
        c.Fl_Adjuster_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *const Adjuster, cb: fn (w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Adjuster_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }
};

pub const Roller = struct {
    inner: ?*c.Fl_Roller,
    pub fn new(x: i32, y: i32, w: i32, h: i32, title: [*c]const u8) Roller {
        const ptr = c.Fl_Roller_new(x, y, w, h, title);
        if (ptr == null) unreachable;
        return Roller{
            .inner = ptr,
        };
    }

    pub fn raw(self: *const Roller) ?*c.Fl_Roller {
        return self.inner;
    }

    pub fn fromRaw(ptr: ?*c.Fl_Roller) Roller {
        return Roller{
            .inner = ptr,
        };
    }

    pub fn fromWidgetPtr(w: widget.WidgetPtr) Roller {
        return Roller{
            .inner = @ptrCast(?*c.Fl_Roller, w),
        };
    }

    pub fn fromVoidPtr(ptr: ?*anyopaque) Roller {
        return Roller{
            .inner = @ptrCast(?*c.Fl_Roller, ptr),
        };
    }

    pub fn toVoidPtr(self: *const Roller) ?*anyopaque {
        return @ptrCast(?*anyopaque, self.inner);
    }

    pub fn asWidget(self: *const Roller) widget.Widget {
        return widget.Widget{
            .inner = @ptrCast(widget.WidgetPtr, self.inner),
        };
    }

    pub fn asValuator(self: *const Roller) Valuator {
        return Valuator{
            .inner = @ptrCast(?*c.Fl_Roller, self.inner),
        };
    }

    pub fn handle(self: *const Roller, cb: fn (w: widget.WidgetPtr, ev: i32, data: ?*anyopaque) callconv(.C) i32, data: ?*anyopaque) void {
        c.Fl_Roller_handle(self.inner, @ptrCast(c.custom_handler_callback, cb), data);
    }

    pub fn draw(self: *const Roller, cb: fn (w: widget.WidgetPtr, data: ?*anyopaque) callconv(.C) void, data: ?*anyopaque) void {
        c.Fl_Roller_handle(self.inner, @ptrCast(c.custom_draw_callback, cb), data);
    }
};

test "all" {
    @import("std").testing.refAllDecls(@This());
}
