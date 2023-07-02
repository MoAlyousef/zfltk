const zfltk = @import("zfltk.zig");
const app = zfltk.app;
const std = @import("std");
const enums = zfltk.enums;
const Color = enums.Color;
const Group = zfltk.Group;
const Image = zfltk.Image;
const c = zfltk.c;

pub const Widget = struct {
    pub usingnamespace methods(Widget, *c.Fl_Widget);

    pub fn OptionsImpl(comptime ctx: type) type {
        _ = ctx;
        return struct {
            x: u31 = 0,
            y: u31 = 0,
            w: u31 = 0,
            h: u31 = 0,

            label: ?[:0]const u8 = null,
        };
    }

    pub const Options = OptionsImpl(Widget);

    pub inline fn init(opts: Options) !*Widget {
        const _label = if (opts.label != null) opts.label.?.ptr else null;

        if (c.Fl_Widget_new(opts.x, opts.y, opts.w, opts.h, _label)) |ptr| {
            return Widget.fromRaw(ptr);
        }

        unreachable;
    }

    pub inline fn deinit(self: *Widget) void {
        c.Fl_Widget_delete(self.raw());
    }
};

/// Methods to be used in everything derived from `Widget`
pub fn methods(comptime Self: type, comptime RawPtr: type) type {
    return struct {
        const handle_func = switch (RawPtr) {
            *c.Fl_Box => c.Fl_Box_handle,
            *c.Fl_Button => c.Fl_Button_handle,
            *c.Fl_Radio_Button => c.Fl_Radio_Button_handle,
            *c.Fl_Check_Button => c.Fl_Check_Button_handle,
            *c.Fl_Light_Button => c.Fl_Light_Button_handle,
            *c.Fl_Return_Button => c.Fl_Return_Button_handle,
            *c.Fl_Repeat_Button => c.Fl_Repeat_Button_handle,
            *c.Fl_Browser => c.Fl_Browser_handle,
            *c.Fl_Select_Browser => c.Fl_Select_Browser_handle,
            *c.Fl_Hold_Browser => c.Fl_Hold_Browser_handle,
            *c.Fl_Multi_Browser => c.Fl_Multi_Browser_handle,
            *c.Fl_Menu_Bar => c.Fl_Menu_Bar_handle,
            *c.Fl_Choice => c.Fl_Choice_handle,
            *c.Fl_Sys_Menu_Bar => c.Fl_Sys_Menu_Bar_handle,
            *c.Fl_Group => c.Fl_Group_handle,
            *c.Fl_Scroll => c.Fl_Scroll,
            *c.Fl_Flex => c.Fl_Flex_handle,
            *c.Fl_Tabs => c.Fl_Tabs_handle,
            *c.Fl_Pack => c.Fl_Pack_handle,
            *c.Fl_Input => c.Fl_Input_handle,
            *c.Fl_Secret_Input => c.Fl_Secret_Input_handle,
            *c.Fl_Int_Input => c.Fl_Int_Input_handle,
            *c.Fl_Float_Input => c.Fl_Float_Input_handle,
            *c.Fl_Multiline_Input => c.Fl_Multiline_Input_handle,
            *c.Fl_Output => c.Fl_Output_handle,
            *c.Fl_Multiline_Output => c.Fl_Multiline_Output_handle,
            *c.Fl_Table => c.Fl_Table_handle,
            *c.Fl_Table_Row => c.Fl_Table_Row_handle,
            *c.Fl_Tree => c.Fl_Tree_handle,
            *c.Fl_Text_Display => c.Fl_Text_Display_handle,
            *c.Fl_Text_Editor => c.Fl_Text_Editor_handle,
            *c.Fl_Window => c.Fl_Window_handle,
            *c.Fl_Double_Window => c.Fl_Double_Window_handle,
            *c.Fl_Slider => c.Fl_Slider_handle,
            *c.Fl_Dial => c.Fl_Dial_handle,
            *c.Fl_Counter => c.Fl_Counter_handle,
            *c.Fl_Scrollbar => c.Fl_Scrollbar_handle,
            *c.Fl_Adjuster => c.Fl_Adjuster_handle,
            *c.Fl_Roller => c.Fl_Roller_handle,
            else => c.Fl_Box_handle,
        };

        const draw_func = switch (RawPtr) {
            *c.Fl_Box => c.Fl_Box_draw,
            *c.Fl_Button => c.Fl_Button_draw,
            *c.Fl_Radio_Button => c.Fl_Radio_Button_draw,
            *c.Fl_Check_Button => c.Fl_Check_Button_draw,
            *c.Fl_Light_Button => c.Fl_Light_Button_draw,
            *c.Fl_Return_Button => c.Fl_Return_Button_draw,
            *c.Fl_Repeat_Button => c.Fl_Repeat_Button_draw,
            *c.Fl_Browser => c.Fl_Browser_draw,
            *c.Fl_Select_Browser => c.Fl_Select_Browser_draw,
            *c.Fl_Hold_Browser => c.Fl_Hold_Browser_draw,
            *c.Fl_Multi_Browser => c.Fl_Multi_Browser_draw,
            *c.Fl_Menu_Bar => c.Fl_Menu_Bar_draw,
            *c.Fl_Choice => c.Fl_Choice_draw,
            *c.Fl_Sys_Menu_Bar => c.Fl_Sys_Menu_Bar_draw,
            *c.Fl_Group => c.Fl_Group_draw,
            *c.Fl_Scroll => c.Fl_Scroll,
            *c.Fl_Flex => c.Fl_Flex_draw,
            *c.Fl_Tabs => c.Fl_Tabs_draw,
            *c.Fl_Pack => c.Fl_Pack_draw,
            *c.Fl_Input => c.Fl_Input_draw,
            *c.Fl_Secret_Input => c.Fl_Secret_Input_draw,
            *c.Fl_Int_Input => c.Fl_Int_Input_draw,
            *c.Fl_Float_Input => c.Fl_Float_Input_draw,
            *c.Fl_Multiline_Input => c.Fl_Multiline_Input_draw,
            *c.Fl_Output => c.Fl_Output_draw,
            *c.Fl_Multiline_Output => c.Fl_Multiline_Output_draw,
            *c.Fl_Table => c.Fl_Table_draw,
            *c.Fl_Table_Row => c.Fl_Table_Row_draw,
            *c.Fl_Tree => c.Fl_Tree_draw,
            *c.Fl_Text_Display => c.Fl_Text_Display_draw,
            *c.Fl_Text_Editor => c.Fl_Text_Editor_draw,
            *c.Fl_Window => c.Fl_Window_draw,
            *c.Fl_Double_Window => c.Fl_Double_Window_draw,
            *c.Fl_Slider => c.Fl_Slider_draw,
            *c.Fl_Dial => c.Fl_Dial_draw,
            *c.Fl_Counter => c.Fl_Counter_draw,
            *c.Fl_Scrollbar => c.Fl_Scrollbar_draw,
            *c.Fl_Adjuster => c.Fl_Adjuster_draw,
            *c.Fl_Roller => c.Fl_Roller_draw,
            else => c.Fl_Box_draw,
        };

        pub inline fn widget(self: *Self) *Widget {
            return @ptrCast(self);
        }

        pub inline fn fromWidget(wid: *Widget) *Self {
            return @ptrCast(wid);
        }

        pub inline fn raw(self: *Self) RawPtr {
            return @ptrCast(@alignCast(self));
        }

        pub inline fn fromRaw(ptr: *anyopaque) *Self {
            return @ptrCast(ptr);
        }

        /// Sets a function to be called upon `activation` of a widget such as
        /// pushing a button
        pub inline fn setCallback(self: *Self, f: *const fn (*Self) void) void {
            c.Fl_Widget_set_callback(
                self.widget().raw(),
                &zfltk_cb_handler,
                @ptrFromInt(@intFromPtr(f)),
            );
        }

        /// Like `setCallback` but allows passing data
        pub fn setCallbackEx(self: *Self, f: *const fn (*Self, data: ?*anyopaque) void, data: ?*anyopaque) void {
            if (data) |d| {
                // TODO: Make this an ArrayList or something more efficient
                var container = app.allocator.alloc(usize, 2) catch unreachable;

                container[0] = @intFromPtr(f);
                container[1] = @intFromPtr(d);

                c.Fl_Widget_set_callback(
                    self.widget().raw(),
                    zfltk_cb_handler_ex,
                    @ptrCast(container.ptr),
                );
            } else {
                c.Fl_Widget_set_callback(
                    self.widget().raw(),
                    zfltk_cb_handler,
                    @ptrFromInt(@intFromPtr(f)),
                );
            }
        }

        pub inline fn emit(self: *Self, comptime T: type, msg: T) void {
            self.widget().setCallbackEx(shim, @ptrFromInt(@intFromEnum(msg)));
        }

        pub inline fn show(self: *Self) void {
            c.Fl_Widget_show(self.widget().raw());
        }

        pub inline fn hide(self: *Self) void {
            c.Fl_Widget_hide(self.widget().raw());
        }

        pub inline fn resize(self: *Self, _x: i32, _y: i32, _w: u31, _h: u31) void {
            c.Fl_Widget_resize(self.widget().raw(), _x, _y, _w, _h);
        }

        pub inline fn redraw(self: *Self) void {
            c.Fl_Widget_redraw(self.widget().raw());
        }

        pub inline fn x(self: *Self) i32 {
            return @intCast(c.Fl_Widget_x(self.widget().raw()));
        }

        pub inline fn y(self: *Self) i32 {
            return @intCast(c.Fl_Widget_y(self.widget().raw()));
        }

        pub inline fn w(self: *Self) u31 {
            return @intCast(c.Fl_Widget_width(self.widget().raw()));
        }

        pub inline fn h(self: *Self) u31 {
            return @intCast(c.Fl_Widget_height(self.widget().raw()));
        }

        pub inline fn label(self: *Self) [:0]const u8 {
            return std.mem.span(c.Fl_Widget_label(self.widget().raw()));
        }

        pub inline fn setLabel(self: *Self, _label: [:0]const u8) void {
            c.Fl_Widget_set_label(self.widget().raw(), _label.ptr);
        }

        pub inline fn kind(self: *Self, comptime T: type) T {
            return @enumFromInt(c.Fl_Widget_set_type(self.widget().raw()));
        }

        pub inline fn setKind(self: *Self, comptime T: type, t: T) void {
            c.Fl_Widget_set_type(self.widget().raw(), @intFromEnum(t));
        }

        pub inline fn color(self: *Self) Color {
            return Color.fromRgbi(c.Fl_Widget_color(self.widget().raw()));
        }

        pub inline fn setColor(self: *Self, col: Color) void {
            c.Fl_Widget_set_color(self.widget().raw(), col.toRgbi());
        }

        pub inline fn labelColor(self: *Self) Color {
            return Color.fromRgbi(c.Fl_Widget_label_color(self.widget().raw()));
        }

        pub inline fn setLabelColor(self: *Self, col: Color) void {
            c.Fl_Widget_set_label_color(self.widget().raw(), col.toRgbi());
        }

        pub inline fn labelFont(self: *Self) enums.Font {
            return @enumFromInt(c.Fl_Widget_label_font(self.widget().raw()));
        }

        pub inline fn setLabelFont(self: *Self, font: enums.Font) void {
            c.Fl_Widget_set_label_font(self.widget().raw(), @intFromEnum(font));
        }

        pub inline fn labelSize(self: *Self) u31 {
            return @intCast(c.Fl_Widget_label_size(self.widget().raw()));
        }

        pub inline fn setLabelSize(self: *Self, size: u31) void {
            c.Fl_Widget_set_label_size(self.widget().raw(), size);
        }

        // TODO: make alignment and trigger enums
        pub inline fn labelAlign(self: *Self) i32 {
            return @intCast(c.Fl_Widget_align(self.widget().raw()));
        }

        pub inline fn setLabelAlign(self: *Self, alignment: i32) void {
            c.Fl_Widget_set_align(self.widget().raw(), @intCast(alignment));
        }

        pub inline fn trigger(self: *Self) i32 {
            return c.Fl_Widget_trigger(self.widget().raw());
        }

        pub inline fn setTrigger(self: *Self, cb_trigger: i32) void {
            c.Fl_Widget_set_trigger(self.widget().raw(), @intCast(cb_trigger));
        }

        pub inline fn box(self: *Self) enums.BoxType {
            return @enumFromInt(c.Fl_Widget_box(self.widget().raw()));
        }

        pub inline fn setBox(self: *Self, boxtype: enums.BoxType) void {
            c.Fl_Widget_set_box(self.widget().raw(), @intFromEnum(boxtype));
        }

        pub inline fn setImage(self: *Self, img: Image) void {
            c.Fl_Widget_set_image(self.widget().raw(), img.inner);
        }

        pub inline fn removeImage(self: *Self) void {
            c.Fl_Widget_set_image(self.widget().raw(), null);
        }

        pub inline fn setDeimage(self: *Self, img: Image) void {
            c.Fl_Widget_set_deimage(self.widget().raw(), img.inner);
        }

        pub inline fn removeDeimage(self: *Self) void {
            c.Fl_Widget_set_deimage(self.widget().raw(), null);
        }

        // TODO: fix, this causes pointer issues
        pub inline fn parent(self: *Self) *Group(.normal) {
            return Group(.normal).fromRaw(c.Fl_Widget_parent(self.widget().raw()).?);
        }

        pub inline fn selectionColor(self: *Self) enums.Color {
            return enums.Color.fromRgbi(c.Fl_Widget_selection_color(self.widget().raw()));
        }

        pub inline fn setSelectionColor(self: *Self, col: enums.Color) void {
            c.Fl_Widget_set_selection_color(self.widget().raw(), @intCast(col.toRgbi()));
        }

        pub inline fn doCallback(self: *Self) void {
            c.Fl_Widget_do_callback(self.widget().raw());
        }

        pub inline fn clearVisibleFocus(self: *Self) void {
            c.Fl_Widget_clear_visible_focus(self.widget().raw());
        }

        pub inline fn setVisibleFocus(self: *Self, v: bool) void {
            c.Fl_Widget_visible_focus(self.widget().raw(), @intFromBool(v));
        }

        pub inline fn setLabelKind(self: *Self, typ: enums.LabelType) void {
            c.Fl_Widget_set_label_type(self.widget().raw(), @intFromEnum(typ));
        }

        pub inline fn tooltip(self: *Self) [:0]const u8 {
            return std.mem.span(c.Fl_Widget_tooltip(self.widget().raw()));
        }

        pub inline fn setTooltip(self: *Self, _label: [:0]const u8) void {
            c.Fl_Widget_set_tooltip(self.widget().raw(), _label.ptr);
        }

        pub inline fn takeFocus(self: *Self) void {
            c.Fl_set_focus(self.widget().raw());
        }

        pub inline fn setEventHandler(self: *Self, f: *const fn (*Self, enums.Event) bool) void {
            handle_func(
                self.raw(),
                zfltk_event_handler,
                @ptrFromInt(@intFromPtr(f)),
            );
        }

        pub inline fn setEventHandlerEx(self: *Self, f: *const fn (*Self, enums.Event, ?*anyopaque) bool, data: ?*anyopaque) void {
            if (data) |d| {
                var container = app.allocator.alloc(usize, 2) catch unreachable;

                container[0] = @intFromPtr(f);
                container[1] = @intFromPtr(d);

                handle_func(
                    self.raw(),
                    zfltk_event_handler_ex,
                    @ptrCast(container.ptr),
                );
            } else {
                handle_func(
                    self.raw(),
                    zfltk_event_handler,
                    @ptrFromInt(@intFromPtr(f)),
                );
            }
        }

        
        pub inline fn setDrawHandler(self: *Self, f: *const fn (*Self) void) void {
            draw_func(
                self.raw(),
                zfltk_draw_handler,
                @ptrFromInt(@intFromPtr(f)),
            );
        }

        pub inline fn setDrawHandlerEx(self: *Self, f: *const fn (*Self, ?*anyopaque) void, data: ?*anyopaque) void {
            if (data) |d| {
                var allocator = std.heap.c_allocator;
                var container = allocator.alloc(usize, 2) catch unreachable;

                container[0] = @intFromPtr(&f);
                container[1] = @intFromPtr(d);

                draw_func(
                    self.raw(),
                    zfltk_draw_handler_ex,
                    @ptrCast(container.ptr),
                );
            } else {
                draw_func(
                    self.raw(),
                    zfltk_draw_handler,
                    @ptrFromInt(@intFromPtr(f)),
                );
            }
        }
    };
}

fn shim(_: *Widget, data: ?*anyopaque) void {
    c.Fl_awake_msg(data);
}

// Small wrapper utilizing FLTK's `data` argument to use non-callconv(.C)
// functions as callbacks safely
pub fn zfltk_cb_handler(wid: ?*c.Fl_Widget, data: ?*anyopaque) callconv(.C) void {
    // Fetch function pointer from the data. This is added to the data
    // pointer on `setCallback`.
    const cb: *const fn (*Widget) void = @ptrCast(data);

    if (wid) |ptr| {
        cb(Widget.fromRaw(ptr));
    } else {
        unreachable;
    }
}

pub fn zfltk_cb_handler_ex(wid: ?*c.Fl_Widget, data: ?*anyopaque) callconv(.C) void {
    const container: *[2]usize = @ptrCast(@alignCast(data));
    const cb: *const fn (*Widget, ?*anyopaque) void = @ptrFromInt(container[0]);

    if (wid) |ptr| {
        cb(Widget.fromRaw(ptr), @ptrFromInt(container[1]));
    } else {
        unreachable;
    }
}

pub fn zfltk_event_handler(wid: ?*c.Fl_Widget, event: c_int, data: ?*anyopaque) callconv(.C) c_int {
    const cb: *const fn (*Widget, enums.Event, ?*anyopaque) bool = @ptrCast(
        data,
    );

    return @intFromBool(cb(
        Widget.fromRaw(wid.?),
        @enumFromInt(event),
        null,
    ));
}

pub fn zfltk_event_handler_ex(wid: ?*c.Fl_Widget, ev: c_int, data: ?*anyopaque) callconv(.C) c_int {
    const container: *[2]usize = @ptrCast(@alignCast(data));

    const cb: *const fn (*Widget, enums.Event, ?*anyopaque) bool = @ptrFromInt(
        container[0],
    );

    return @intFromBool(cb(
        Widget.fromRaw(wid.?),
        @enumFromInt(ev),
        @ptrFromInt(container[1]),
    ));
}

pub fn zfltk_draw_handler(wid: ?*c.Fl_Widget, data: ?*anyopaque) callconv(.C) void {
    const cb: *const fn (*Widget, ?*anyopaque) void = @ptrCast(
        data,
    );

    cb(
        Widget.fromRaw(wid.?),
        null,
    );
}

pub fn zfltk_draw_handler_ex(wid: ?*c.Fl_Widget, data: ?*anyopaque) callconv(.C) void {
    const container: *[2]usize = @ptrCast(@alignCast(data));

    const cb: *const fn (*Widget, ?*anyopaque) void = @ptrFromInt(
        container[0],
    );

    cb(
        Widget.fromRaw(wid.?),
        @ptrFromInt(container[1]),
    );
}

test "all" {
    @import("std").testing.refAllDeclsRecursive(@This());
}
