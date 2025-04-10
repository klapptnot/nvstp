-- nvim initialization

do -- Add config folder to package.path
  local nvcfg = vim.fn.stdpath("config")
  ---@cast nvcfg string
  if string.find(package.path, nvcfg, 1, true) then return end
  local p = {
    s = package.config:sub(1, 1), -- Path separator
    d = package.config:sub(3, 3), -- package.path separator
    p = package.config:sub(5, 5), -- name placeholder
  }
  -- stylua: ignore
  package.path = package.path
      -- ";{}/?/init.lua"
      .. p.d .. nvcfg .. p.s .. p.p .. p.s .. "init.lua"
      -- ";{}/?.lua"
      .. p.d .. nvcfg .. p.s .. p.p .. ".lua"
end

LESS_COMPLEX_THINGS = true

-- Space is <leader> key
vim.g.mapleader = " "

-- Initialize things that needs to be downloaded, like lazy
require("src.bootstrap") -- This creates the `custom` folder and init.lua

---@type NvstpConfig
local config = require("config")
---@type table<string, table<any, any>>
local custom = require("custom")

config.plugins():merge(custom.plugins):apply()
config.globals():merge(custom.globals):apply()
config.options():merge(custom.options):apply()

config
  .mapping()
  :no_op_key({ "<C-z>" }) -- disable backgrounding when <C-z> is pressed
  :merge(custom.mapping)
  :apply()

-- Run tweaks on nvim & lua behavior
require("src.nvstp.tweaks").apply({ "lua_functions", "reset_cursor", "detect_indent" })

-- Load nvstp files
require("src.nvstp")

-- Never forget to be high-spirited!
vim.cmd.colorscheme("catppuccin")
