-- nvim statusline 'vibib'

local main = {}

local color = require("warm.color")
local str = require("warm.str")
local uts = require("warm.uts")

local NVSTP_VIBIB_CACHE = vim.fs.joinpath(NVSTP_CACHE, "vibib.lua")

NVSTP = {
  vibib = {
    funcs = {},
  },
}

-- Function to generate a random string
local function random_string(length)
  -- if not length or length <= 0 then length = 16 end
  local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" --"0123456789"
  math.randomseed(os.time())

  local result = ""
  for _ = 1, length do
    local random_index = math.random(#charset)
    local character = string.sub(charset, random_index, random_index)
    result = result .. character
  end

  return result
end

-- local unicode_icons = {
--   [1] = "▬", -- Horizontal bar
--   [2] = "●", -- Filled circle
--   [3] = "▲", -- Triangle
--   [4] = "◆", -- Diamond
--   [5] = "◐", -- Circle with a dot in the center
--   [6] = "◓", -- Circle with a small circle inside
--   [7] = "◌", -- Empty circle
--   [8] = "□", -- Square
--   [9] = "◠", -- Semicircle (upper)
--   [10] = "◡", -- Semicircle (lower)
--   [11] = "⌒", -- Wide tilde
--   [12] = "≈", -- Approximately equal to
--   [13] = "∆", -- Delta symbol
--   [14] = "◇", -- Diamond shape
--   [15] = "█", -- Full block
--   [16] = "▌", -- Left half block
--   [17] = "▐", -- Right half block
--   [18] = "▉", -- Upper one-eighth block
--   [19] = "▊", -- Lower one-eighth block
--   [20] = "◤", -- Upper left corner block
--   [21] = "◥", -- Upper right corner block
--   [22] = "◣", -- Lower right corner block
--   [23] = "◢", -- Lower left corner block
--   [24] = "▭", -- Rectangle with horizontal line in the middle
--   [25] = "", -- Left half rhombus
--   [26] = "", -- Right half rhombus
--   [27] = "", -- Left-down diagonal half block
--   [28] = "", -- Right-up diagonal half block
--   [29] = "", -- Left-up diagonal half block
--   [30] = "", -- Right-down diagonal half block
--   [31] = "", -- Left half circle
--   [32] = "", -- Right half circle
-- }

local HEADER = [[
local str = require("warm.str")

return function ()
  local modi = str.fallback(vim.api.nvim_get_mode().mode, "sp")
  local sbuf = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 1000)
  local igit = vim.b[sbuf].gitsigns_head or vim.b[sbuf].gitsigns_git_status
  local name = vim.api.nvim_buf_get_name(sbuf)
  local skip = vim.api.nvim_get_current_win() ~= vim.g.statusline_winid
  local bfft = str.fallback(vim.bo[sbuf].filetype, "unknown")

  if skip then
    return string.format("  INACTIVE> %s%%=%s", (str.boolean(name) and vim.fs.basename(name)) or "Empty", bfft)
  end
  local not_terminal = bfft ~= "terminal"

  -- left/right separator icon
  local lis, ris = "{<lis>}", "{<ris>}"

  -- to make colors match, keep track of foreground color
  local lfgc = "#ffffff"

  local bar = {{}}
]]
local FOOTER = '\n  return table.concat(bar, "")\nend\n'

---@enum
-- stylua: ignore
main.blocks = {
  MODE          = "mode",
  FILE          = "file",
  FILE_TYPE     = "file_type",
  FILE_EOL      = "file_eol",
  FILE_ENCODING = "file_encoding",
  LSP_INFO      = "lsp_info",
  GIT_INFO      = "git_info",
  CURSOR_POS    = "cursor_pos",
  CWD           = "cwd",
}

local blocks = {
  mode = [[
  do
    -- This table was initialy copied from
    -- nvchad statusline
    -- to get the posible modes
    local vim_modes = {
      ["n"]        = { "NORMAL",       "Vibib_mode_normal" },
      ["no"]       = { "NORMAL (no)",  "Vibib_mode_normal" },
      ["nov"]      = { "NORMAL (nov)", "Vibib_mode_normal" },
      ["noV"]      = { "NORMAL (noV)", "Vibib_mode_normal" },
      ["noCTRL-V"] = { "NORMAL",       "Vibib_mode_normal" },
      ["niI"]   = { "NORMAL i",        "Vibib_mode_normal" },
      ["niR"]   = { "NORMAL r",        "Vibib_mode_normal" },
      ["niV"]   = { "NORMAL v",        "Vibib_mode_normal" },

      ["nt"]    = { "NTERMINAL",       "Vibib_mode_normal" },
      ["ntT"]   = { "NTERMINAL (ntT)", "Vibib_mode_normal" },

      ["v"]   = { "VISUAL",          "Vibib_mode_visual" },
      ["vs"]  = { "V-CHAR (Ctrl O)", "Vibib_mode_visual" },
      ["V"]   = { "V-LINE",          "Vibib_mode_visual" },
      ["Vs"]  = { "V-LINE",          "Vibib_mode_visual" },
      [""]   = { "V-BLOCK",         "Vibib_mode_visual" },

      ["i"]   = { "INSERT",              "Vibib_mode_insert" },
      ["ic"]  = { "INSERT (completion)", "Vibib_mode_insert" },
      ["ix"]  = { "INSERT completion",   "Vibib_mode_insert" },

      ["t"]   = { "TERMINAL", "Vibib_mode_prompt" },

      ["R"]   = { "REPLACE",           "Vibib_mode_replace" },
      ["Rc"]  = { "REPLACE (Rc)",      "Vibib_mode_replace" },
      ["Rx"]  = { "REPLACEa (Rx)",     "Vibib_mode_replace" },
      ["Rv"]  = { "V-REPLACE",         "Vibib_mode_replace" },
      ["Rvc"] = { "V-REPLACE (Rvc)",   "Vibib_mode_replace" },
      ["Rvx"] = { "V-REPLACE (Rvx)",   "Vibib_mode_replace" },

      ["s"]   = { "SELECT",     "Vibib_mode_visual" },
      ["S"]   = { "S-LINE",     "Vibib_mode_visual" },
      [""]   = { "S-BLOCK",    "Vibib_mode_visual" },

      ["c"]   = { "COMMAND",    "Vibib_mode_prompt" },
      ["cv"]  = { "COMMAND",    "Vibib_mode_prompt" },
      ["ce"]  = { "COMMAND",    "Vibib_mode_prompt" },
      ["r"]   = { "PROMPT",     "Vibib_mode_prompt" },
      ["rm"]  = { "MORE",       "Vibib_mode_prompt" },
      ["r?"]  = { "CONFIRM",    "Vibib_mode_prompt" },
      ["x"]   = { "CONFIRM",    "Vibib_mode_prompt" },
      ["!"]   = { "SHELL",      "Vibib_mode_prompt" },

      ["sp"]  = { "NVSTP",     "Vibib_mode_other" },
    }

    if str.has("neo-tree,Outline", bfft) then
      return vim_modes[modi][1] .. " in " .. bfft
    end

    local mode, color = table.unpack(vim_modes[modi])
    bar[#bar + 1] = string.format("%%#%s#  %s ", color, mode)
  end]],

  file = [[
  do
    local icon = "󰈚 " -- Default icon
    local file = (str.boolean(name) and vim.fs.basename(name)) or "Empty"

    -- Get the right icon for the file
    if file ~= "Empty" then
      -- Safe load, require exits if SOMEONE removed dependencies
      local loaded, devicons = pcall(require, "nvim-web-devicons")
      if loaded then icon = devicons.get_icon(file) or icon end
    end

    if not_terminal then
      bar[#bar + 1] =
        string.format("%%#Vibib_file# %s %s (buf: %%n)%%{getbufvar(bufnr('%%'),'&mod')?' ⬬':''} %%#StatusLine#", icon, file)
    else
      bar[#bar + 1] =
        string.format("%%#Vibib_file# %s %s (buf: %%n) %%#StatusLine#", icon, file)
    end
  end]],

  file_type = [[  if not_terminal then bar[#bar + 1] = "%#Vibib_file_type# " .. bfft .. " " end]],

  file_eol = [[
  if not_terminal then do
    local eol = vim.bo[sbuf].fileformat
    if eol == "unix" then
      bar[#bar + 1] = "%#Vibib_file_eol# LF "
    else
      bar[#bar + 1] = "%#Vibib_file_eol# CRLF "
    end
  end end]],

  file_encoding = [[
  do
    local enc = vim.bo[sbuf].fileencoding
    if enc ~= "" then
      bar[#bar + 1] = "%#Vibib_file_encoding# " .. enc .. " "
    end
  end]],

  cursor_pos = [[  bar[#bar + 1] = "%#Vibib_cursor_pos# (%p%%) %c:%l/%L => [%b][0x%B] "]],

  git_info = [[
  if not_terminal then do
    if igit then
      local gst = vim.b[sbuf].gitsigns_status_dict
      gst = {
        gst.added,
        gst.changed,
        gst.removed,
      }
      local mod = { "", "", "" }
      if gst[1] and gst[1] > 0 then mod[1] = "%#Vibib_git_info_addedF#  " .. gst[1] end
      if gst[2] and gst[2] > 0 then mod[2] = "%#Vibib_git_info_changedF#  " .. gst[2] end
      if gst[3] and gst[3] > 0 then mod[3] = "%#Vibib_git_info_removedF#  " .. gst[3] end
      bar[#bar + 1] = string.format(
        "%s %%#Vibib_git_info_branch#  %s ",
        table.concat(mod, ""),
        vim.b[sbuf].gitsigns_status_dict.head
      )
    end
  end end]],

  lsp_info = [[
  if not_terminal then do
    if rawget(vim, "lsp") ~= nil then
      for _, lsp in ipairs(vim.lsp.get_clients({bufnr=sbuf})) do
        if lsp.name ~= "null-ls" and lsp.attached_buffers[sbuf] ~= nil then
          bar[#bar + 1] = "%#Vibib_lsp_info_name#   " .. lsp.name .. " "
          break
        end
      end
      local stat = {
        #vim.diagnostic.get(sbuf, { severity = vim.diagnostic.severity.INFO }),
        #vim.diagnostic.get(sbuf, { severity = vim.diagnostic.severity.HINT }),
        #vim.diagnostic.get(sbuf, { severity = vim.diagnostic.severity.WARN }),
        #vim.diagnostic.get(sbuf, { severity = vim.diagnostic.severity.ERROR }),
      }
      local stats = { "", "", "", "" } --        
      if stat[1] and stat[1] > 0 then stats[1] = "%#Vibib_lsp_info_infoF#  " .. stat[1] end
      if stat[2] and stat[2] > 0 then stats[2] = "%#Vibib_lsp_info_hintF#  " .. stat[2] end
      if stat[3] and stat[3] > 0 then stats[3] = "%#Vibib_lsp_info_warnF#  " .. stat[3] end
      if stat[4] and stat[4] > 0 then stats[4] = "%#Vibib_lsp_info_errorF#  " .. stat[4] end
      bar[#bar + 1] = table.concat(stats, "") .. " "
    end
  end end]],

  cwd = [[
  if not_terminal then bar[#bar + 1] = "%#Vibib_cwd# 󰉖 "
    .. str.fallback(vim.fs.basename(vim.fn.getcwd()), "")
    .. " " end]],
}

function main.add_vim_expr(expr)
  local form = '\n  bar[#bar + 1] = "{}"\n'
  return str.format(form, expr)
end

-- Embed lua functions in statusline via vim functions
function main.add_lua_fn(fn)
  local rndm = random_string(16)
  NVSTP.vibib.funcs[rndm] = fn
  local cmd = [[
  function! __VIBIB_LUAFN_WRAPPER_{1}(...)
    lua NVSTP.vibib.funcs.{1}()
  endfunction
  ]]
  vim.api.nvim_command(str.format(cmd, rndm))
  local form = '\n  bar[#bar] = "%@__VIBIB_LUAFN_WRAPPER_{}@" .. bar[#bar]\n'
  return str.format(form, rndm)
end

function main.load(enable)
  local fun, _ = loadfile(NVSTP_VIBIB_CACHE, "b")
  assert(fun ~= nil, "Could not load statusline file")

  VibibStln = fun()

  main.__enabled = false
  if enable == true then
    vim.opt.statusline = "%!v:lua.VibibStln()"
    main.__enabled = true
  end
  vim.api.nvim_create_user_command("VibibToggle", function()
    if main.__enabled then
      vim.opt.statusline = ""
      main.__enabled = false
    else
      vim.opt.statusline = "%!v:lua.VibibStln()"
      main.__enabled = true
    end
  end, {})
end

-- stylua: ignore
local default = {
  items = {
    left = { main.blocks.MODE, main.blocks.FILE, main.blocks.LSP_INFO },
    right = {
      main.blocks.GIT_INFO,
      main.blocks.CURSOR_POS,
      main.blocks.FILE_TYPE,
      main.blocks.FILE_ENCODING,
      main.blocks.FILE_EOL,
      main.blocks.CWD,
      main.add_lua_fn(function(_)
        require("src.nvstp.api").simple_input_popup({
          title = "Change work directory",
          title_hi = "AccHiMauveF",
          border_hi = "AccHiMauveF",
          width = 50,
          height = 1,
          callback = function (text)
            if #text == 0 then return end
            local _, err = pcall(vim.fn.chdir, text)
            if err ~= nil then vim.api.nvim_echo({ { err, "ErrorMsg" } }, true, {}) end
          end
        })
      end),
    },
  },
  colors = {
    blocks = {
      mode          = {
        normal  = "#fdc5f5",     -- Yogurt
        insert  = "#6cffb8",     -- Mint green
        visual  = "#6ce8ff",     -- Cyan
        prompt  = "#801de6",     -- Purple
        replace = "#fd65c5",     -- Pink
        other   = "#b8966c",     -- Ocre
      },
      cwd           = "#bd93f9", -- Mauve
      file          = "#e188a4", -- Dusty rose
      file_type     = "#ffe8b8", -- Beige
      lsp_info      = {
        name  = "#fdc5c5",       -- Skin
        error = "#ff6e6e",       -- Red
        hint  = "#6c8cff",       -- Blue
        warn  = "#ffb86c",       -- Orange
        info  = "#a020f0",       -- Candy Purple
      },
      git_info      = {
        branch  = "#674533",     -- Dark brown
        changed = "#4b4592",     -- Indigo
        added   = "#6ff660",     -- Green
        removed = "#ff6e6e",     -- Red
      },
      cursor_pos    = "#fff5f5", -- Solar white
      file_eol      = "#f5f5ff", -- White
      file_encoding = "#ffa98c", -- Peach
    },
    bg = "none",
  },
  separators = {
    lis = "",
    ris = "",
  },
}

local aeettrs = '\n  bar[#bar + 1] = "%#StatusLine#%="\n'

local function generate_hi(t, f)
  for n, c in pairs(t) do
    if color.brightness(c, 0.35) then
      vim.api.nvim_set_hl(0, f .. n, { bg = c, fg = "#101010", bold = true })
      vim.api.nvim_set_hl(0, f .. n .. "F", { fg = c, bold = true })
    else
      vim.api.nvim_set_hl(0, f .. n, { bg = c, fg = "#fafaff", bold = true })
      vim.api.nvim_set_hl(0, f .. n .. "F", { fg = c, bold = true })
    end
  end
end

function main.setup(opts)
  if opts ~= nil then
    opts = vim.tbl_deep_extend("force", opts, default)
  else
    opts = default
  end
  vim.api.nvim_command("hi StatusLine guibg=" .. opts.colors.bg)

  for i, bname in ipairs(opts.items.left) do
    local color = opts.colors.blocks[bname]
    if color ~= nil then
      if type(color) == "table" then
        generate_hi(color, "Vibib_" .. bname .. "_")
      else
        generate_hi({ [bname] = color }, "Vibib_")
      end
    end
    local itb = blocks[bname]
    if itb ~= nil then opts.items.left[i] = itb end
  end
  for i, bname in ipairs(opts.items.right) do
    local color = opts.colors.blocks[bname]
    if color ~= nil then
      if type(color) == "table" then
        generate_hi(color, "Vibib_" .. bname .. "_")
      else
        generate_hi({ [bname] = color }, "Vibib_")
      end
    end
    local itb = blocks[bname]
    if itb ~= nil then opts.items.right[i] = itb end
  end

  local fcont = str.format(HEADER, opts.separators)
    .. table.concat(opts.items.left, "\n")
    .. aeettrs -- Align everything else to the right side.
    .. table.concat(opts.items.right, "\n")
    .. FOOTER
  uts.str_to_file(fcont, NVSTP_VIBIB_CACHE)
  return main
end

return main
