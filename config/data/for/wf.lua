return {
  "Cassin01/wf.nvim",
  version = "*",
  config = function()
    require("wf").setup()
    local which_key = require("wf.builtin.which_key")
    local mark = require("wf.builtin.mark")

    -- Mark
    vim.api.nvim_set_keymap("n", "'", "", {
      -- mark(opts?: table) -> function
      -- opts?: option,
      callback = mark(),
      nowait = true,
      noremap = true,
      silent = true,
      desc = "[wf] Jump to mark",
    })

    -- Which Key
    vim.api.nvim_set_keymap("n", "<leader>", "", {
      -- mark(opts?: table) -> function
      -- opts?: option,
      callback = which_key({ text_insert_in_advance = "<Space>" }),
      nowait = true,
      noremap = true,
      silent = true,
      desc = "[wf] Run mapping",
    })
  end,
}
