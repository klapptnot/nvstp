-- add your own custom mappings in
-- ~/.config/nvim/custom/mapping/init.lua

local __map__ = require("config.data.mapping")

---@class NvimMappingConfig
local main = {}

---Return a new instance of mapping table
---@param tbl? NvstpKeyMapp[]
---@return NvimMappingConfig
function main:new(tbl)
  ---@type NvstpKeyMapp[]
  self = tbl or __map__
  setmetatable(self, { __index = main })
  return self
end

---Merge mappings table into self
---@param tbl table
---@return NvimMappingConfig
function main:merge(tbl) return self:new(vim.tbl_deep_extend("force", self, tbl)) end

---Make all mappings on `mapps` non-op in the most common modes
---@param mapps string[]
---@return NvimMappingConfig
function main:no_op_key(mapps)
  if mapps == nil then return self end
  local opts = { noremap = false, silent = true }
  for _, mapp in ipairs(mapps) do
    vim.keymap.set("n", mapp, "<NOP>", opts)
    vim.keymap.set("v", mapp, "<NOP>", opts)
    vim.keymap.set("i", mapp, "<NOP>", opts)
    vim.keymap.set("t", mapp, "<NOP>", opts)
    vim.keymap.set("x", mapp, "<NOP>", opts)
    vim.keymap.set("s", mapp, "<NOP>", opts)
    vim.keymap.set("o", mapp, "<NOP>", opts)
    vim.keymap.set("c", mapp, "<NOP>", opts)
    vim.keymap.set("!", mapp, "<NOP>", opts)
    vim.keymap.set("l", mapp, "<NOP>", opts)
  end
  return self
end

---Disable the mouse mappings
---@return NvimMappingConfig
function main:disable_mouse()
  local mouse_events = {
    "<LeftMouse>",
    "<LeftDrag>",
    "<LeftRelease>",
    "<RightMouse>",
    "<RightDrag>",
    "<RightRelease>",
    "<MiddleMouse>",
    "<MiddleDrag>",
    "<MiddleRelease>",
    "<ScrollWheelUp>",
    "<ScrollWheelDown>",
    "<ScrollWheelLeft>",
    "<ScrollWheelRight>",
  }
  self:no_op_key(mouse_events)
  return self
end

---Add one keybinding to the table
---@param id string
---@param props table
---@return NvimMappingConfig
function main:add(id, props)
  if self[id] == nil then self[id] = props end
  return self
end

---Apply all mappings to nvim
function main:apply()
  local rcall = require("warm.spr").rcall
  local fmt = require("warm.str").format

  for _, props in pairs(self) do
    ---@cast props NvstpKeyMapp
    if type(props.exec) == "function" then
      props.opts.callback = props.exec
      props.exec = ""
    end
    props.opts.desc = props.desc -- Just to not nest items
    for _, mode in ipairs(props.mode) do
      local remove = rcall(vim.api.nvim_set_keymap, mode, props.mapp, props.exec, props.opts)
      if not remove() then
        print(fmt("Mapping error for '{}': {}", tostring(props.desc), remove.unwrap(true)))
      end
    end
  end
  return self
end

return main
