-- stylua: ignore
local main = {
  head = {
    name = "Wolf Howl at Dawn",
    desc =
    [[A warm palette with oranges, yellows, and browns capturing the feeling of a sunrise, accented by cool blues and purples representing the night fading away. The loyal wolf stands guard.]],
    auth = "Nvstp",
    from = "Nvstp",
    page = "None",
    lice = "MIT",
    date = os.date("%Y-%m-%d %H:%M:%S"),
  },
  theme = {
    name = "loyal_sunrise",
    mode = "dark",
    desc = [[]]
  },
  ansi = {
    Black       = "Black",
    Red         = "Red",
    Green       = "Green",
    Yellow      = "Yellow",
    Blue        = "Blue",
    Purple      = "Purple",
    Cyan        = "Cyan",
    LightGray   = "LightGray",
    DarkGray    = "DarkGray",
    LightRed    = "LightRed",
    LightGreen  = "LightGreen",
    LightYellow = "LightYellow",
    LightBlue   = "LightBlue",
    LightPurple = "LightPurple",
    LightCyan   = "LightCyan",
    White       = "White",
  },
  main = {
    [0] = "#7a96be",
    [1] = "#6b82a8",
    [2] = "#5c6f93",
    [3] = "#4e5b7e",
    [4] = "#3f4868",
    [5] = "#313453",
    [6] = "#22213e",
    [7] = "#140e29",
  },
  accent = {
    [0] = "#f060af",
    [1] = "#ffba26",
    [2] = "#fff52d",
    [3] = "#a1faa5",
    [4] = "#75fddc",
    [5] = "#6734b4",
    [6] = "#681fcb",
    [7] = "#5a0ac3",
  },
  state = {
    error   = "#ff7c8f",
    warning = "#f9ae7e",
    hint    = "#f9fe7e",
    ok      = "#a5fba7",
    info    = "#a9deff",
  },
  syntax = {
    string  = "#a1faa5",
    escape  = "#7af8fa",
    number  = "#fb8080",
    float   = "#ffb5fd",
    boolean = "#fffcaf",
    keyword = "#8b26fb",
    type    = "#8c6cff",
    char    = "#80fa80",
    prop    = "#ffa98c",
    oper    = "#fdc5f5",
    direc   = "#6b82a8",
    comment = "#202060",
    punct   = "#fa80ff",
    attr    = "#4b4592",
    func    = {
      builtin = "#f2f0a0",
      macro = "#f26082",
      method = "#8280ff",
      self    = "#7b00f7",
    },
    var = {
      const = "#fba0f2",
      param = "#fb3080",
      builtin = "#f29090",
      self = "#fba0f2",
    }
  }
}

return main
