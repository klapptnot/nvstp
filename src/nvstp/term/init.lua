-- terminal plugin

-- All active instances
local main = {}
main.instances = {}
main.opts = {
  insert_mode = true, -- Enter to terminal with insert mode on
  ask_to_quit = false, -- Ask to quit before closing window, or close directly
  layout = {
    floating = {
      s = "rounded", -- Border style
      h = 0.7, -- Height of floating window N/100
      w = 0.7, -- Width of floating window N/100
    },
    horizontal = {
      p = "rightbelow", -- Position of horizontal window
      h = 0.4, -- Height of horizontal window N/100
    },
    vertical = {
      p = "rightbelow", -- Position of vertical window
      w = 0.4, -- Width of vertical window N/100
    },
  },
  send_keys = true, -- Send all pressed keys to terminal window
}

local tbl = require("warm.table")

-- Main terminal object
function main.setup(opts)
  if not tbl.is_empty(opts) then
    -- Merge options
    main.opts = tbl.deep_merge(main.opts, opts)
  end
  return require("src.nvstp.term.api").init(main.opts)
end

return main
