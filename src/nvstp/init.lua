-- load nvstp components

-- Add help files
vim.cmd("silent! helptags " .. vim.fn.stdpath("config") .. "/doc")

-- stylua: ignore start
require("src.nvstp.term").setup({}) -- Enable terminal plugin

require("src.nvstp.remove")         -- Add the uninstaller command (Sadge)
require("src.nvstp.configure")      -- Add the configure command
require("src.nvstp.themes.accents").hg_load()
require("src.nvstp.themes").load()  -- Add themes command
-- stylua: ignore end
require("src.nvstp.statusline").set({
  ignore = "neo-tree,Outline,toggleterm,terminal",
  bar = {
    "mode",
    "file",
    "git_branch",
    "truncate",
    "lsp_name",
    "lsp_diag",
    "shift_to_end",
    "git_stat",
    "cursor_pos",
    "cwd",
    "file_eol",
    "file_encoding",
    "file_type",
  },
  colors = { -- Catppuccin with diversified colors
    mode = {
      normal = { bg = "#f5c2e7", fg = "#11111b" }, -- Pink
      insert = { bg = "#a6e3a1", fg = "#11111b" }, -- Green
      visual = { bg = "#89dceb", fg = "#11111b" }, -- Teal
      prompt = { bg = "#eba0ac", fg = "#11111b" }, -- Maroon
      replace = { bg = "#f38ba8", fg = "#11111b" }, -- Red
      other = { bg = "#f9e2af", fg = "#11111b" }, -- Yellow
    },
    cwd = { bg = "#b4befe", fg = "#11111b" }, -- Lavender
    file = {
      name = { bg = "#cba6f7", fg = "#11111b" }, -- Mauve
      type = { bg = "#f9e2af", fg = "#11111b" }, -- Yellow
      eol = { bg = "#bac2de", fg = "#11111b" }, -- Subtext0
      enc = { bg = "#fab387", fg = "#11111b" }, -- Peach
    },
    lsp = {
      name = { bg = "#94e2d5", fg = "#11111b" }, -- Sky
      error = { bg = "#f38ba8", fg = "#11111b" }, -- Red
      hint = { bg = "#89b4fa", fg = "#11111b" }, -- Blue
      warn = { bg = "#fab387", fg = "#11111b" }, -- Peach
      info = { bg = "#74c7ec", fg = "#11111b" }, -- Sapphire
    },
    git = {
      branch = { bg = "#b4befe", fg = "#11111b" }, -- Lavender
      changed = { bg = "#f2cdcd", fg = "#11111b" }, -- Flamingo
      added = { bg = "#a6e3a1", fg = "#11111b" }, -- Green
      removed = { bg = "#f38ba8", fg = "#11111b" }, -- Red
    },
    cursor_pos = { bg = "#cdd6f4", fg = "#11111b" }, -- Text
  },
  separators = {
    l = "",
    r = "",
  },
  swap = true,
}, true) -- Enable statusline plugin

-- I was about to use this, but was easy to use my own (is not what I wanted)
-- https://gist.github.com/kawarimidoll/302b03fc6e9300786f54cfafb9150fe3
function MergeHighlight(new, ...)
  -- Check for minimum arguments
  local args = { ... }
  if #args < 2 then
    vim.err("[MergeHighlight] At least 2 arguments are required.")
    vim.err("  * New highlight name")
    vim.err("  * Source highlight names (one or more)")
    return
  end

  local res = {}
  for _, v in ipairs(args) do
    res = vim.tbl_deep_extend("force", res, vim.api.nvim_get_hl(0, { name = v }))
  end

  -- Create the new highlight with merged definitions
  if #res > 0 then vim.api.nvim_set_hl(0, new, res) end
  return res
end
