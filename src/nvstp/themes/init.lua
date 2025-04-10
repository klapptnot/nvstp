local main = {}

local str = require("src.warm.str")
local tbl = require("src.warm.table")
local util = require("src.nvstp.themes.util")
local uts = require("src.warm.uts")
-- Location to *this* file folder
local meloc = uts.fwd()
---@cast meloc string

local NVSTP_THEME_CACHE = vim.fs.joinpath(NVSTP_CACHE, "themes")
local THEME_SPRITES, THEME_NAMES = require("src.nvstp.themes.manifest"):unpack()
local function is_valid_theme(name) return tbl.contains(THEME_SPRITES, name) end
---@diagnostic disable-next-line: undefined-field
local function path_exists(path) return vim.uv.fs_stat(path) ~= nil end

local function generate_theme_script(thf)
  if not path_exists(NVSTP_THEME_CACHE) then
    vim.fn.mkdir(NVSTP_THEME_CACHE, "p")
    if not path_exists(NVSTP_THEME_CACHE) then return nil end
  end

  local template = uts.file_as_str(vim.fs.joinpath(meloc, "template.lua"))
  local palette = util.extractable(dofile(thf))

  if template == nil or palette == nil then return nil end

  return template:gsub("{:{([%w_]+)}:}", function(m)
    local color = palette -- TODO: Use red to mark error
    for k in m:gmatch("%w+") do
      ---@diagnostic disable-next-line: cast-local-type
      color = color:get(k, color)
    end
    return tostring(color)
  end)
end

function main.compile(thf, thc)
  local ths = generate_theme_script(thf)
  if ths == nil then return false end
  local fun, _ = load("return function () " .. ths .. " end")
  if fun == nil then return false end

  local st, _ = pcall(uts.str_to_file, string.dump(fun(), true), thc)
  return st
end

function main.load()
  vim.api.nvim_create_user_command("NvstpColor", function(opts)
    if opts.fargs[1] == "--list" then
      for i, v in ipairs(THEME_SPRITES) do
        print(str.format("{:2}  {:<25} as {}", i, THEME_NAMES[i], v))
      end
      return
    end
    local theme = opts.fargs[1]

    if not is_valid_theme(theme) then return end

    local reload = false
    if opts.fargs[2] == "--reload" then reload = true end
    main.apply(theme, reload)
  end, {
    desc = "Set a theme from Nvstp",
    nargs = "+",
    complete = function(arglead, _, _) -- cmdline, curpos
      local cmp = THEME_SPRITES
      if arglead == "" or str.starts_with(arglead, " ") then return cmp end
      cmp = tbl.filter(cmp, function(_, v) return str.starts_with(v, arglead) end, false)
      if #tbl.get_keys(cmp) == 0 then return { "--list" } end
      return cmp
    end,
  })
end

function main.apply(name, reload)
  assert(is_valid_theme(name), str.format("Theme '{}' is not defined", name))
  local thf = vim.fs.joinpath(meloc, "sprites", name .. ".lua")
  assert(path_exists(thf), str.format("Theme '{}' does not exist", name))

  local thc = vim.fs.joinpath(NVSTP_THEME_CACHE, name .. ".lua")

  if not path_exists(thc) or reload then
    assert(
      main.compile(thf, thc),
      str.format(
        "Theme '{}' could not be compiled, use `rawgen` to (try to) open it in a buffer",
        name
      )
    )
  end

  local fun, _ = loadfile(thc, "b")
  if fun == nil then return end

  fun()
end

function main.rawgen(name)
  assert(is_valid_theme(name), str.format("Theme '{}' is not defined", name))
  local thf = vim.fs.joinpath(meloc, "sprites", name .. ".lua")
  assert(path_exists(thf), str.format("Theme '{}' does not exist", name))
  local ths = generate_theme_script(thf)
  assert(ths ~= nil, str.format("Unable to generate script for {}", name))

  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_set_option_value("filetype", "lua", { buf = buf })
  vim.api.nvim_buf_set_name(buf, name .. ".lua")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, str.split(ths, "\n"))
  vim.api.nvim_win_set_buf(0, buf)
end

return main
