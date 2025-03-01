-- stylua: ignore
local main = {
  head = {
    name = "Wisteria Way",
    desc =
    [[A calming blend of blues and purples reminiscent of twilight strolls through Wisteria vine tunnels. Lush green grass adds a touch of groundedness.]],
    auth = "nvstp",
    from = "nvstp",
    page = "None",
    lice = "MIT",
    date = os.date("%Y-%m-%d %H:%M:%S"),
  },
  theme = {
    name = "twilight_weaver",
    mode = "both",
    desc = [[]]
  },
  ansi = {
    Black       = "Black",       -- "#202020",
    Red         = "Red",         -- "#f56060",
    Green       = "Green",       -- "#60f560",
    Yellow      = "Yellow",      -- "#f5f560",
    Blue        = "Blue",        -- "#6060f5",
    Purple      = "Purple",      -- "#a580ff",
    Cyan        = "Cyan",        -- "#25f0ff",
    LightGray   = "LightGray",   -- "#606060",
    DarkGray    = "DarkGray",    -- "#303030",
    LightRed    = "LightRed",    -- "#ff5555",
    LightGreen  = "LightGreen",  -- "#55ff55",
    LightYellow = "LightYellow", -- "#ffff55",
    LightBlue   = "LightBlue",   -- "#5555ff",
    LightPurple = "LightPurple", -- "#ab80ff",
    LightCyan   = "LightCyan",   -- "#55ffff",
    White       = "White",       -- "#fbfbfb",
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
    [0] = "#c0a0ff",
    [1] = "#b18af6",
    [2] = "#a275ed",
    [3] = "#945fe5",
    [4] = "#854adc",
    [5] = "#7734d4",
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
}

return main
