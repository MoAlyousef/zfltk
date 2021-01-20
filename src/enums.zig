const c = @cImport({
    @cInclude("cfl_enums.h");
});

pub const Color = enum(u32) {
    ForeGround = 0,
    BackGround2 = 7,
    Inactive = 8,
    Selection = 15,
    Gray0 = 32,
    Dark3 = 39,
    Dark2 = 45,
    Dark1 = 47,
    BackGround = 49,
    Light1 = 50,
    Light2 = 52,
    Light3 = 54,
    Black = 56,
    Red = 88,
    Green = 63,
    Yellow = 95,
    Blue = 216,
    Magenta = 248,
    Cyan = 223,
    DarkRed = 72,
    DarkGreen = 60,
    DarkYellow = 76,
    DarkBlue = 136,
    DarkMagenta = 152,
    DarkCyan = 140,
    White = 255,
};

pub const Align = struct {
    pub const Center = 0;
    pub const Top = 1;
    pub const Bottom = 2;
    pub const Left = 4;
    pub const Right = 8;
    pub const Inside = 16;
    pub const TextOverImage = 20;
    pub const Clip = 40;
    pub const Wrap = 80;
    pub const ImageNextToText = 100;
    pub const TextNextToImage = 120;
    pub const ImageBackdrop = 200;
    pub const TopLeft = 1 | 4;
    pub const TopRight = 1 | 8;
    pub const BottomLeft = 2 | 4;
    pub const BottomRight = 2 | 8;
    pub const LeftTop = 7;
    pub const RightTop = 11;
    pub const LeftBottom = 13;
    pub const RightBottom = 14;
    pub const PositionMask = 15;
    pub const ImageMask = 320;
};

pub const LabelType = enum {
    Normal = 0,
    None,
    Shadow,
    Engraved,
    Embossed,
    Multi,
    Icon,
    Image,
    FreeType,
};

pub const BoxType = enum(i32) {
    NoBox = 0,
    FlatBox,
    UpBox,
    DownBox,
    UpFrame,
    DownFrame,
    ThinUpBox,
    ThinDownBox,
    ThinUpFrame,
    ThinDownFrame,
    EngraveBox,
    EmbossedBox,
    EngravedFrame,
    EmbossedFrame,
    BorderBox,
    ShadowBox,
    BorderFrame,
    ShadowFrame,
    RoundedBox,
    RShadowBox,
    RoundedFrame,
    RFlatBox,
    RoundUpBox,
    RoundDownBox,
    DiamondUpBox,
    DiamondDownBox,
    OvalBox,
    OShadowBox,
    OvalFrame,
    OFlatFrame,
    PlasticUpBox,
    PlasticDownBox,
    PlasticUpFrame,
    PlasticDownFrame,
    PlasticThinUpBox,
    PlasticThinDownBox,
    PlasticRoundUpBox,
    PlasticRoundDownBox,
    GtkUpBox,
    GtkDownBox,
    GtkUpFrame,
    GtkDownFrame,
    GtkThinUpBox,
    GtkThinDownBox,
    GtkThinUpFrame,
    GtkThinDownFrame,
    GtkRoundUpFrame,
    GtkRoundDownFrame,
    GleamUpBox,
    GleamDownBox,
    GleamUpFrame,
    GleamDownFrame,
    GleamThinUpBox,
    GleamThinDownBox,
    GleamRoundUpBox,
    GleamRoundDownBox,
    FreeBoxType,
};

pub const Event = enum(i32) {
    NoEvent = 0,
    Push,
    Released,
    Enter,
    Leave,
    Drag,
    Focus,
    Unfocus,
    KeyDown,
    KeyUp,
    Close,
    Move,
    Shortcut,
    Deactivate,
    Activate,
    Hide,
    Show,
    Paste,
    SelectionClear,
    MouseWheel,
    DndEnter,
    DndDrag,
    DndLeave,
    DndRelease,
    ScreenConfigChanged,
    Fullscreen,
    ZoomGesture,
    ZoomEvent,
};

pub const Font = enum(i32) {
    Helvetica = 0,
    HelveticaBold = 1,
    HelveticaItalic = 2,
    HelveticaBoldItalic = 3,
    Courier = 4,
    CourierBold = 5,
    CourierItalic = 6,
    CourierBoldItalic = 7,
    Times = 8,
    TimesBold = 9,
    TimesItalic = 10,
    TimesBoldItalic = 11,
    Symbol = 12,
    Screen = 13,
    ScreenBold = 14,
    Zapfdingbats = 15,
};

pub const Key = struct {
    pub const None = 0;
    pub const Button = 0xfee8;
    pub const BackSpace = 0xff08;
    pub const Tab = 0xff09;
    pub const IsoKey = 0xff0c;
    pub const Enter = 0xff0d;
    pub const Pause = 0xff13;
    pub const ScrollLock = 0xff14;
    pub const Escape = 0xff1b;
    pub const Kana = 0xff2e;
    pub const Eisu = 0xff2f;
    pub const Yen = 0xff30;
    pub const JISUnderscore = 0xff31;
    pub const Home = 0xff50;
    pub const Left = 0xff51;
    pub const Up = 0xff52;
    pub const Right = 0xff53;
    pub const Down = 0xff54;
    pub const PageUp = 0xff55;
    pub const PageDown = 0xff56;
    pub const End = 0xff57;
    pub const Print = 0xff61;
    pub const Insert = 0xff63;
    pub const Menu = 0xff67;
    pub const Help = 0xff68;
    pub const NumLock = 0xff7f;
    pub const KP = 0xff80;
    pub const KPEnter = 0xff8d;
    pub const KPLast = 0xffbd;
    pub const FLast = 0xffe0;
    pub const ShiftL = 0xffe1;
    pub const ShiftR = 0xffe2;
    pub const ControlL = 0xffe3;
    pub const ControlR = 0xffe4;
    pub const CapsLock = 0xffe5;
    pub const MetaL = 0xffe7;
    pub const MetaR = 0xffe8;
    pub const AltL = 0xffe9;
    pub const AltR = 0xffea;
    pub const Delete = 0xffff;
};

pub const Shortcu = struct {
    pub const None = 0;
    pub const Shift = 0x00010000;
    pub const CapsLock = 0x00020000;
    pub const Ctrl = 0x00040000;
    pub const Alt = 0x00080000;
};

pub const CallbackTrigger = struct {
    pub const Never = 0;
    pub const Changed = 1;
    pub const NotChanged = 2;
    pub const Release = 4;
    pub const ReleaseAlways = 6;
    pub const EnterKey = 8;
    pub const EnterKeyAlways = 10;
    pub const EnterKeyChanged = 11;
};

pub const Cursor = enum(i32) {
    Default = 0,
    Arrow = 35,
    Cross = 66,
    Wait = 76,
    Insert = 77,
    Hand = 31,
    Help = 47,
    Move = 27,
    NS = 78,
    WE = 79,
    NWSE = 80,
    NESW = 81,
    N = 70,
    NE = 69,
    E = 49,
    SE = 8,
    S = 9,
    SW = 7,
    W = 36,
    NW = 68,
    None = 255,
};

pub const TextCursor = enum(u8) {
    Normal,
    Caret,
    Dim,
    Block,
    Heavy,
    Simple,
};
