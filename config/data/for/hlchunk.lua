local excluded = {
  terminal = true,
}

-- Do not change `exclude_filetypes` to `exclude_filetype`
-- even if you saw it in their docs, it's wrong, I looked in their code
-- the correct name because it was not working
return {
  "shellRaining/hlchunk.nvim",
  event = { "UIEnter", "BufReadPre", "BufNewFile" },
  config = function()
    require("hlchunk").setup({
      indent = {
        exclude_filetypes = excluded,
        chars = {
          "│",
          -- "¦",
          -- "┆",
          -- "┊",
        },
        style = {
          "#652da8", -- "#9642fc", -- "#8005ff",
          -- More lines not needed as they are the same
          -- "#fa5aa4",
          -- "#fa946e",
          -- "#ffff00",
          -- "#2be491",
          -- "#6bf5ff",
          -- "#33a5ff",
        },
        enable = true,
      },
      chunk = {
        exclude_filetypes = excluded,
        style = "#8b00ff", -- Whas in GitHub, but I like violet a lot
        enable = true,
      },
      blank = {
        exclude_filetypes = excluded,
        chars = {
          " ",
          -- "․",
          -- "⁚",
          -- "⁖",
          -- "⁘",
          -- "⁙",
        },
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
