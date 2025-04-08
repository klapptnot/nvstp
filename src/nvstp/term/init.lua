-- terminal plugin

-- All active instances
local main = {}
main.instances = {}
main.opts = {
  send_keys = true, -- Send all pressed keys to terminal window
  no_line_nums = true, -- Turn off line numbers if they are turned on
  layout = {
    floating = {
      s = "rounded", -- Border style
      h = 0.75, -- Height of floating window N/100
      w = 0.75, -- Width of floating window N/100
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
}

local tbl = require("src.warm.table")

-- Main terminal object
function main.setup(opts)
  if not tbl.is_empty(opts) then
    -- Merge options
    main.opts = tbl.deep_merge(main.opts, opts)
  end
  return require("src.nvstp.term.api").init(main.opts)
end

return main
