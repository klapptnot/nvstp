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

require("src.nvstp.vibib").setup().load(true) -- Enable statusline plugin

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
