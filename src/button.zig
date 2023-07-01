const zfltk = @import("zfltk.zig");
const app = zfltk.app;
const widget = @import("widget.zig");
const Widget = widget.Widget;
const enums = @import("enums.zig");
const Event = enums.Event;
const std = @import("std");
const c = zfltk.c;

pub const ButtonKind = enum {
    normal,
    radio,
    check,
    round,
    repeat,
    light,
    enter,
};

pub fn Button(comptime kind: ButtonKind) type {
    return struct {
        const Self = @This();

        pub usingnamespace zfltk.widget.methods(Self, RawPtr);
        pub usingnamespace methods(Self);

        const RawPtr = switch (kind) {
            .normal => *c.Fl_Button,
            .radio => *c.Fl_Radio_Button,
            .check => *c.Fl_Check_Button,
            .round => *c.Fl_Round_Button,
            .repeat => *c.Fl_Repeat_Button,
            .light => *c.Fl_Light_Button,
            .enter => *c.Fl_Return_Button,
        };

        pub inline fn init(opts: Widget.Options) !*Self {
            const init_func = switch (kind) {
                .normal => c.Fl_Button_new,
                .radio => c.Fl_Radio_Button_new,
                .check => c.Fl_Check_Button_new,
                .round => c.Fl_Round_Button_new,
                .repeat => c.Fl_Repeat_Button_new,
                .light => c.Fl_Light_Button_new,
                .enter => c.Fl_Return_Button_new,
            };

            const label = if (opts.label != null) opts.label.?.ptr else null;

            if (init_func(opts.x, opts.y, opts.w, opts.h, label)) |ptr| {
                return Self.fromRaw(ptr);
            }

            unreachable;
        }

        pub inline fn deinit(self: *Self) void {
            const deinit_func = switch (kind) {
                .normal => c.Fl_Button_delete,
                .radio => c.Fl_Radio_Button_delete,
                .check => c.Fl_Check_Button_delete,
                .round => c.Fl_Round_Button_delete,
                .repeat => c.Fl_Repeat_Button_delete,
                .light => c.Fl_Light_Button_delete,
                .enter => c.Fl_Return_Button_delete,
            };

            deinit_func(self.raw());
            app.allocator.destroy(self);
        }

        pub inline fn fromDynWidgetPtr(w: *c.Fl_Widget) ?Self {
            if (c.Fl_Button_from_dyn_ptr(@ptrCast(w))) |v| {
                return .{ .inner = v };
            }

            return null;
        }
    };
}

pub fn methods(comptime Self: type) type {
    return struct {
        pub inline fn button(self: *Self) *Button(.normal) {
            return @ptrCast(self);
        }

        pub inline fn setEventHandler(self: *Self, comptime f: fn (*Self, Event) bool) void {
            c.Fl_Button_handle(
                self.button().raw(),
                &widget.zfltk_event_handler,
                @ptrFromInt(@intFromPtr(&f)),
            );
        }

        pub inline fn setEventHandlerEx(self: *Self, comptime f: fn (*Self, Event, ?*anyopaque) bool, data: ?*anyopaque) void {
            var allocator = std.heap.c_allocator;
            var container = allocator.alloc(usize, 2) catch unreachable;

            container[0] = @intFromPtr(&f);
            container[1] = @intFromPtr(data);

            c.Fl_Button_handle(
                self.button().raw(),
                &widget.zfltk_event_handler_ex,
                @ptrCast(container.ptr),
            );
        }

        pub inline fn setDrawHandler(self: *Self, comptime f: fn (*Self) void) void {
            c.Fl_Button_draw(
                self.button().raw(),
                &widget.zfltk_draw_handler,
                @ptrFromInt(@intFromPtr(&f)),
            );
        }

        pub inline fn setDrawHandlerEx(self: *Self, comptime f: fn (*Self, ?*anyopaque) void, data: ?*anyopaque) void {
            var allocator = std.heap.c_allocator;
            var container = allocator.alloc(usize, 2) catch unreachable;

            container[0] = @intFromPtr(&f);
            container[1] = @intFromPtr(data);

            c.Fl_Button_draw(
                self.button().raw(),
                &widget.zfltk_event_handler_ex,
                @ptrCast(container.ptr),
            );
        }

        pub fn shortcut(self: *Self) i32 {
            return c.Fl_Button_shortcut(self.button().raw());
        }

        pub fn setShortcut(self: *Self, shrtct: i32) void {
            c.Fl_Button_set_shortcut(self.button().raw(), shrtct);
        }

        pub fn clear(self: *Self) void {
            c.Fl_Button_clear(self.button().raw());
        }

        pub fn value(self: *Self) bool {
            return c.Fl_Button_value(self.button().raw()) != 0;
        }

        pub fn setValue(self: *Self, flag: bool) void {
            c.Fl_Button_set_value(self.button().raw(), @intFromBool(flag));
        }

        pub fn setDownBox(self: *Self, f: enums.BoxType) void {
            c.Fl_Button_set_down_box(self.button().raw(), @intFromEnum(f));
        }

        pub fn downBox(self: *Self) enums.BoxType {
            return @enumFromInt(c.Fl_Button_down_box(self.button().raw()));
        }
    };
}

test "all" {
    @import("std").testing.refAllDeclsRecursive(@This());
}
