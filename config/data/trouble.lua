return {
  "folke/trouble.nvim",
  opts = {
    auto_close = false, -- auto close when there are no items
    auto_open = false, -- auto open when there are items
    auto_preview = false, -- automatically open preview when on an item
    auto_refresh = true, -- auto refresh when open
    auto_jump = false, -- auto jump to the item when there's only one
  }, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "[Trouble] Diagnostics",
    },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "[Trouble] Buffer Diagnostics",
    },
    {
      "<leader>cs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "[Trouble] Symbols",
    },
    {
      "<leader>cl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "[Trouble] LSP Definitions",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "[Trouble] Location List",
    },
    {
      "<leader>xQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "[Trouble] Quickfix List",
    },
  },
}
