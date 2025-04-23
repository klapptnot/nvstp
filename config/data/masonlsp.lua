return {
  "williamboman/mason-lspconfig.nvim",
  event = { "BufReadPre", "BufNewFile", "BufWinEnter" },
  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = {
        -- "lua_ls",
      },
    })
  end,
}
