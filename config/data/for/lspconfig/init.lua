local main = { "neovim/nvim-lspconfig", event = { "BufReadPre", "BufNewFile", "BufWinEnter" } }
local fns = {
  on_attach = function(client, bufnr)
    local mapps = require("config.data.for.lspconfig.mapping")
    for _, prop in ipairs(mapps) do
      if client.supports_method(prop.meth) then
        prop.opts.desc = prop.desc -- Just to not nest items
        if type(prop.exec) == "function" then
          prop.opts.callback = prop.exec
          prop.exec = ""
        end
        for _, mode in ipairs(prop.mode) do
          ---@diagnostic disable-next-line: param-type-mismatch
          vim.api.nvim_buf_set_keymap(bufnr, mode, prop.mapp, prop.exec, prop.opts)
        end
      end
    end
    -- Now we have our buffer-scope keymaps
    if client.server_capabilities["documentSymbolProvider"] then
      require("nvim-navic").attach(client, bufnr)
    end
  end,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
}
fns.basic_opts = {
  hints = {
    enable = true,
  },
  on_attach = fns.on_attach,
  capabilities = fns.capabilities,
}
main.opts = {
  inlay_hints = (function()
    if vim.lsp.inlay_hint == nil then return nil end
    return { enabled = true }
  end)(),
}
main.config = function()
  local lspconfig = require("lspconfig")
  -- Set it to have a better behavior when editing the config
  lspconfig.lua_ls.setup({
    on_attach = fns.on_attach,
    capabilities = fns.capabilities,
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
  lspconfig.rust_analyzer.setup(fns.basic_opts)
  lspconfig.clangd.setup(fns.basic_opts)
  lspconfig.ts_ls.setup(fns.basic_opts)
  lspconfig.pylyzer.setup(fns.basic_opts)
  lspconfig.jsonls.setup({
    hints = {
      enable = true,
    },
    on_attach = fns.on_attach,
    capabilities = fns.capabilities,
    settings = {
      schemas = require("config.data.for.lspconfig.jsonsch"),
    },
  })
  lspconfig.html.setup(fns.basic_opts)
  lspconfig.bashls.setup(fns.basic_opts)
end
return main
