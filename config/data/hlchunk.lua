return {
  "shellRaining/hlchunk.nvim",
  event = { "UIEnter", "BufReadPre", "BufNewFile" },
  config = function()
    require("hlchunk").setup({
      exclude_filetypes = {
        terminal = true,
      },
      indent = {
        chars = { "│" },
        style = {},
        enable = true,
      },
      chunk = {
        use_treesitter = true,
        style = {
          "#b0bfff",
          "#f0bfff",
        },
        chars = {
          horizontal_line = "─",
          vertical_line = "│",
          left_top = "╭",
          left_bottom = "╰",
          right_arrow = "➜",
        },
        enable = true,
        duration = 0,
        delay = 0,
      },
      blank = {
        chars = { "." },
        style = {
          "#606090",
        },
        enable = true,
      },
      line_num = {
        enable = false,
      },
    })
  end,
}
