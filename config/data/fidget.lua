return {
  "j-hui/fidget.nvim",
  tag = "v1.6.1", -- Make sure to update this to something recent!
  opts = {
    progress = {
      display = {
        render_limit = 16, -- How many LSP messages to show at once
        done_ttl = 2, -- How long a message should persist after completion
        done_icon = "✔", -- Icon shown when all LSP progress tasks are complete
        done_style = "Constant", -- Highlight group for completed LSP tasks
        progress_ttl = math.huge, -- How long a message should persist when in progress
        -- Icon shown when LSP progress tasks are in progress
        progress_icon = { "dots" },
        -- Highlight group for in-progress LSP tasks
        progress_style = "WarningMsg",
        group_style = "Title", -- Highlight group for group name (LSP server name)
        icon_style = "Question", -- Highlight group for group icons
        priority = 30, -- Ordering priority for LSP notification group
        skip_history = true, -- Whether progress notifications should be omitted from history
        -- How to format a progress message
        -- format_message = require("fidget.progress.display").default_format_message,
        -- How to format a progress annotation
        format_annote = function(msg) return msg.title end,
        -- How to format a progress notification group's name
        format_group_name = function(group) return tostring(group) end,
        overrides = { -- Override options from the default notification config
          rust_analyzer = { name = "rust-analyzer" },
          lua_ls = { name = "lua-ls" },
        },
      },
    },
    notification = {
      -- Options related to the notification window and buffer
      window = {
        normal_hl = "Comment", -- Base highlight group in the notification window
        winblend = 0, -- Background color opacity in the notification window
        border = "none", -- Border around the notification window
        zindex = 45, -- Stacking priority of the notification window
        max_width = 0, -- Maximum width of the notification window
        max_height = 0, -- Maximum height of the notification window
        x_padding = 1, -- Padding from right edge of window boundary
        y_padding = 0, -- Padding from bottom edge of window boundary
        align = "bottom", -- How to align the notification window
        relative = "editor", -- What the notification window position is relative to
      },
    },
  },
}
