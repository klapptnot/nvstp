return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local nvim_autopairs = require("nvim-autopairs")
    local nvim_autopairs_cmp = require("nvim-autopairs.completion.cmp")
    ---@diagnostic disable-next-line: different-requires
    local cmp = require("cmp")

    nvim_autopairs.setup({
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      disable_in_macro = true, -- disable when recording or executing a macro
      disable_in_visualblock = false, -- disable when insert after visual block mode
      disable_in_replace_mode = true,
      ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
      enable_moveright = true,
      enable_afterquote = true, -- add bracket pairs after quote
      enable_check_bracket_line = true, --- check bracket in same line
      enable_bracket_in_quote = true,
      enable_abbr = false, -- trigger abbreviation
      break_undo = true, -- switch for basic rule break undo sequence
      map_bs = true, -- map the <BS> key
      map_c_h = false, -- Map the <C-h> key to delete a pair
      map_c_w = false, -- map <c-w> to delete a pair if possible
      check_ts = true,
      map_cr = true, --  map <CR> on insert mode
      map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
      auto_select = false, -- auto select first item
      map_char = {
        -- modifies the function or method delimiter by filetypes
        all = "(",
        tex = "{",
      },
    })

    -- If you want insert `(` after select function or method item
    ---@diagnostic disable-next-line: undefined-field
    cmp.event:on("confirm_done", nvim_autopairs_cmp.on_confirm_done())
  end,
}
