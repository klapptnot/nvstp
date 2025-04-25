return {
  -- required dependencies
  --#region
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "nvim-telescope/telescope.nvim", tag = "0.1.5" },
  --#endregion

  { "folke/trouble.nvim", event = { "BufReadPre", "BufNewFile" } },
  { "RRethy/vim-illuminate", event = { "BufReadPre", "BufNewFile" } },
  { "stevearc/dressing.nvim" },

  require("config.data.cmp"),
  require("config.data.fidget"),
  require("config.data.trouble"),
  require("config.data.autopairs"),
  require("config.data.tabby"),
  require("config.data.treesitter"),
  require("config.data.symbols_outline"),
  require("config.data.gitsigns"),
  require("config.data.mason"),
  require("config.data.hlchunk"),
  require("config.data.null_ls"),
  require("config.data.masonlsp"),
  require("config.data.lspconfig"),

  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
    },
  },
  {
    "LhKipp/nvim-nu",
    ft = "nu",
    init = function()
      require("nu").setup({
        use_lsp_features = true,
        all_cmd_names = [[help commands | get name | str join "\n"]],
      })
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    init = function() require("colorizer").setup({}) end,
  },
  {
    "rcarriga/nvim-notify",
    name = "notify",
    lazy = false,
    init = function()
      if NVSTP.less_complex_things == false then
        -- Just to ignore notification
        require("notify").setup({ background_colour = "#000000" })
        vim.notify = require("notify")
      end
    end,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        transparent_background = true,
      })
    end,
  },
}
