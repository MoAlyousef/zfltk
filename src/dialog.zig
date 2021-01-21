const c = @cImport({
    @cInclude("cfl_dialog.h");
});

pub const NativeFileDialogType = enum(i32) {
    /// Browse files
    BrowseFile = 0,
    /// Browse dir
    BrowseDir,
    /// Browse multiple files
    BrowseMultiFile,
    /// Browse multiple dirs
    BrowseMultiDir,
    /// Browse save file
    BrowseSaveFile,
    /// Browse save directory
    BrowseSaveDir,
};

pub const NativeFileDialogOptions = enum(i32) {
    /// No options
    NoOptions = 0,
    /// Confirm on save as
    SaveAsConfirm = 1,
    /// New folder option
    NewFolder = 2,
    /// Enable preview
    Preview = 4,
    /// Use extension filter
    UseFilterExt = 8,
};

pub const NativeFileDialog = struct {
    inner: ?*c.Fl_Native_File_Chooser,
    pub fn new(typ: NativeFileDialogType) NativeFileDialog {
        return NativeFileDialog{
            .inner = c.Fl_Native_File_Chooser_new(@enumToInt(typ)),
        };
    }

    pub fn setOptions(self: *NativeFileDialog, opt: NativeFileDialogOptions) void {
        c.Fl_Native_File_Chooser_set_option(self.inner, @enumToInt(opt));
    }

    pub fn show(self: *NativeFileDialog) void {
        _ = c.Fl_Native_File_Chooser_show(self.inner);
    }

    pub fn filename(self: *const NativeFileDialog) [*c]const u8 {
        return c.Fl_Native_File_Chooser_filenames(self.inner, 0);
    }

    pub fn filenameAt(self: *const NativeFileDialog, idx: u32) [*c]const u8 {
        return c.Fl_Native_File_Chooser_filenames(self.inner, idx);
    }

    pub fn count(self: *const NativeFileDialog) u32 {
        return c.Fl_Native_File_Chooser_count(self.inner);
    }

    pub fn setDirectory(self: *NativeFileDialog, dir: [*c]const u8) void {
        c.Fl_Native_File_Chooser_set_directory(self.inner, dir);
    }

    pub fn directory(self: *const NativeFileDialog) [*c][]const u8 {
        return c.Fl_Native_File_Chooser_directory(self.inner);
    }

    /// Sets the filter for the dialog, can be:
    /// A single wildcard (eg. "*.txt")
    /// Multiple wildcards (eg. "*.{cxx,h,H}")
    /// A descriptive name followed by a "\t" and a wildcard (eg. "Text Files\t*.txt")
    /// A list of separate wildcards with a "\n" between each (eg. "*.{cxx,H}\n*.txt")
    /// A list of descriptive names and wildcards (eg. "C++ Files\t*.{cxx,H}\nTxt Files\t*.txt")
    pub fn setFilter(self: *NativeFileDialog, f: [*c]const u8) void {
        c.Fl_Native_File_Chooser_set_filter(self.inner, f);
    }

    /// Sets the preset filter for the dialog
    pub fn setPresetFile(self: *NativeFileDialog, f: [*c]const u8) void {
        c.Fl_Native_File_Chooser_set_preset_file(self.inner, f);
    }
};

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
    c.Fl_choice(x, y, txt, b0, b1, b2);
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
