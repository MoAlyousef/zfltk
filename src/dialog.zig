// TODO: update to new API

const zfltk = @import("zfltk.zig");
const c = zfltk.c;
const std = @import("std");

pub const FileDialogKind = enum(c_int) {
    file = 0,
    dir,
    multi_file,
    multi_dir,
    save_file,
    save_dir,
};

// TODO: refactor to contain all dialog types
pub fn FileDialog(comptime kind: FileDialogKind) type {
    // _ = kind;
    return struct {
        const Self = @This();

        pub const Options = struct {
            save_as_confirm: bool = false,
            new_folder: bool = false,
            preview: bool = false,
            use_filter_extension: bool = false,

            filter: ?[:0]const u8 = null,
        };

        pub inline fn init(opts: Options) !*Self {
            // Convert bools to OR'd int
            const save_as_confirm = @as(c_int, @intFromBool(opts.save_as_confirm));
            const new_folder = @as(c_int, @intFromBool(opts.new_folder)) << 1;
            const preview = @as(c_int, @intFromBool(opts.preview)) << 2;
            const use_filter_extension = @as(c_int, @intFromBool(opts.use_filter_extension)) << 3;

            const flags = save_as_confirm | new_folder | preview | use_filter_extension;

            if (c.Fl_Native_File_Chooser_new(flags)) |ptr| {
                const self = Self.fromRaw(ptr);

                if (opts.filter) |filter| {
                    self.setFilter(filter);
                }

                self.setType(kind);

                return Self.fromRaw(ptr);
            }

            unreachable;
        }

        pub inline fn dialog(self: *Self) *Self {
            return self;
        }

        pub fn setType(self: *Self, opt: FileDialogKind) void {
            c.Fl_Native_File_Chooser_set_type(self.raw(), @intFromEnum(opt));
        }

        pub fn filename(self: *Self) [:0]const u8 {
            if (self.count() > 0) {
                return std.mem.span(c.Fl_Native_File_Chooser_filenames(self.raw(), 0));
            } else {
                return "";
            }
        }

        pub fn filenameAt(self: *Self, idx: u32) [*c]const u8 {
            return c.Fl_Native_File_Chooser_filenames(self.raw(), idx);
        }

        pub fn count(self: *Self) u32 {
            return @intCast(c.Fl_Native_File_Chooser_count(self.raw()));
        }

        pub fn setDirectory(self: *Self, dir: [:0]const u8) void {
            c.Fl_Native_File_Chooser_set_directory(self.raw(), dir.ptr);
        }

        pub fn directory(self: *Self) [*c][]const u8 {
            return c.Fl_Native_File_Chooser_directory(self.raw());
        }

        /// Sets the filter for the dialog, can be:
        /// A single wildcard (eg. "*.txt")
        /// Multiple wildcards (eg. "*.{cxx,h,H}")
        /// A descriptive name followed by a "\t" and a wildcard (eg. "Text Files\t*.txt")
        /// A list of separate wildcards with a "\n" between each (eg. "*.{cxx,H}\n*.txt")
        /// A list of descriptive names and wildcards (eg. "C++ Files\t*.{cxx,H}\nTxt Files\t*.txt")
        pub inline fn setFilter(self: *Self, f: [:0]const u8) void {
            c.Fl_Native_File_Chooser_set_filter(self.dialog().raw(), f.ptr);
        }

        /// Sets the preset filter for the dialog
        pub inline fn setPresetFile(self: *Self, f: [:0]const u8) void {
            c.Fl_Native_File_Chooser_set_preset_file(self.raw(), f.ptr);
        }

        pub inline fn show(self: *Self) void {
            _ = c.Fl_Native_File_Chooser_show(self.raw());
        }

        pub inline fn fromRaw(ptr: *anyopaque) *Self {
            return @ptrCast(ptr);
        }

        pub inline fn raw(self: *Self) *c.Fl_Native_File_Chooser {
            return @ptrCast(@alignCast(self));
        }
    };
}

/// Displays an message box
pub fn message(x: i32, y: i32, msg: [*c]const u8) void {
    c.Fl_message(x, y, msg);
}

/// Displays an alert box
pub fn alert(x: i32, y: i32, txt: [*c]const u8) void {
    c.Fl_alert(x, y, txt);
}

/// Displays a choice box with upto three choices
/// An empty choice will not be shown
pub fn choice(x: i32, y: i32, txt: [*c]const u8, b0: [*c]const u8, b1: [*c]const u8, b2: [*c]const u8) u32 {
    return @intCast(c.Fl_choice(x, y, txt, b0, b1, b2));
}

/// Displays an input box, which returns the inputted string.
/// Can be used for gui io
pub fn input(x: i32, y: i32, txt: [*c]const u8, deflt: [*c]const u8) [*c]const u8 {
    return c.Fl_input(x, y, txt, deflt);
}

/// Shows an input box, but with hidden string
pub fn password(x: i32, y: i32, txt: [*c]const u8, deflt: [*c]const u8) [*c]const u8 {
    return c.Fl_password(x, y, txt, deflt);
}

test "all" {
    @import("std").testing.refAllDeclsRecursive(@This());
}
