---@diagnostic disable: param-type-mismatch
---
-- Set lazy as it appears in GitHub
local lazypath = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "lazy.nvim")
-- Clone repo if lazy is not found
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
-- Add prioritized
vim.opt.rtp:prepend(lazypath)

local function createCustomFolder(cusfol)
  -- Create user custom configurations folder
  vim.fn.mkdir(cusfol, "p")
  local ifile = io.open(vim.fs.joinpath(cusfol, "init.lua"), "w")
  if ifile == nil then return end
  ifile:write([[
-- Here is where your customization loads
-- add your own ...
-- globals, mapping, options, plugins
-- folders and put there an init.lua file
-- with the same structure as the default ones
-- do not add any method
-- example:
--
-- local main = {
--   n = {
--     {
--       mapp = "e",
--       exec = function() end,
--       desc = "So domething", -- So domething
--       opts = { expr = false },
--     },
--   },
-- }
-- return main

local function safe_require(module, fallback)
  local success, mod = pcall(require, module)
  if success then return mod end
  return fallback
end

return {
  globals = safe_require("override.globals", {}),
  mapping = safe_require("override.mapping", {}),
  options = safe_require("override.options", {}),
  plugins = safe_require("override.plugins", {}),
}
]])
  ifile:close()
end

local cusfol = vim.fs.joinpath(vim.fn.stdpath("config"), "custom")
if not vim.uv.fs_stat(cusfol) then createCustomFolder(cusfol) end

NVSTP = {}
NVSTP_CACHE = vim.fs.joinpath(vim.fn.stdpath("cache"), "nvstp")
if not vim.uv.fs_stat(NVSTP_CACHE) then vim.fn.mkdir(NVSTP_CACHE, "p") end
