vim.lsp.enable('lua_ls')

return {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using
        version = 'LuaJIT',
        path = {
          '?.lua',
          '?/init.lua',
        },
      },
      diagnostics = {
        -- Recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = true,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
