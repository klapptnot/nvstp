local fns_capabilities =
  vim.lsp.protocol.resolve_capabilities(vim.lsp.protocol.make_client_capabilities())

local fns_on_attach = function(client, bufnr)
  local mapps = require("config.data.lspconfig.mapping")

  for _, prop in ipairs(mapps) do
    if client:supports_method(prop.meth) then
      prop.opts.desc = prop.desc -- Just to not nest items
      prop.opts.callback = prop.exec

      for _, mode in ipairs(prop.mode) do
        vim.api.nvim_buf_set_keymap(bufnr, mode, prop.mapp, "", prop.opts)
      end
    end
  end

  if client.server_capabilities["documentSymbolProvider"] then
    require("nvim-navic").attach(client, bufnr)
  end
end

local basic_opts = {
  hints = {
    enable = true,
  },
  on_attach = fns_on_attach,
  capabilities = fns_capabilities,
}

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile", "BufWinEnter" },
  opts = {
    inlay_hints = { enabled = true },
  },
  config = function()
    local lspconfig = require("lspconfig")
    lspconfig.rust_analyzer.setup(basic_opts)
    lspconfig.clangd.setup(basic_opts)
    lspconfig.pyright.setup(basic_opts)
    lspconfig.ts_ls.setup(basic_opts)
    lspconfig.bashls.setup(basic_opts)
    lspconfig.html.setup(basic_opts)
    lspconfig.lua_ls.setup({
      on_attach = fns_on_attach,
      capabilities = fns_capabilities,
      settings = {
        Lua = {
          hints = {
            enable = true,
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
              [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
            },
            maxPreload = 100000,
            preloadFileSize = 10000,
          },
        },
      },
    })
    lspconfig.jsonls.setup({
      hints = {
        enable = true,
      },
      on_attach = fns_on_attach,
      capabilities = fns_capabilities,
      settings = {
        schemas = require("config.data.lspconfig.jsonsch"),
      },
    })
  end,
}
