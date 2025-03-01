return {
  "nanozuki/tabby.nvim",
  event = "VimEnter",
  config = function()
    -- stylua: ignore
    local theme = {
      fill        = { fg = "#202020" },
      head        = { fg = "#202020", bg = "#ffe8b8", style = "italic" },
      cur_tab     = { fg = "#202020", bg = "#ffa98c", style = "bold" },
      cur_win     = { fg = "#202020", bg = "#e188a4", style = "bold" },
      tab         = { fg = "#202020", bg = "#a198b4", style = "italic" },
      win         = { fg = "#202020", bg = "#a198b4", style = "italic" },
      tail        = { fg = "#202020", bg = "#ffe8b8", style = "italic" },
    }
    require("tabby.tabline").set(function(line)
      return {
        {
          { "  " .. vim.fs.basename(vim.fn.getcwd()) .. " ", hl = theme.head },
          line.sep("", theme.head, theme.fill),
        },
        line.tabs().foreach(function(tab)
          local hl = tab.is_current() and theme.cur_tab or theme.tab
          return {
            line.sep(" ", hl, theme.fill),
            tab.is_current() and "" or "󰆣",
            tab.number(),
            tab.name(),
            tab.close_btn(""),
            line.sep("", hl, theme.fill),
            hl = hl,
            margin = " ",
          }
        end),
        line.spacer(),
        line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
          local hl = win.is_current() and theme.cur_win or theme.win
          return {
            line.sep(" ", hl, theme.fill),
            win.is_current() and "" or "",
            win.buf_name(),
            line.sep("", hl, theme.fill),
            hl = hl,
            margin = " ",
          }
        end),
        {
          line.sep(" ", theme.tail, theme.fill),
          { "  ", hl = theme.tail },
        },
        hl = theme.fill,
      }
    end)
  end,
}
