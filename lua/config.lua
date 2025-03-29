require('lspconfig').eslint.setup {}

require('lspconfig').pyright.setup {
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
  },
}

require('lspconfig').ruff.setup {}

require('lspconfig').lua_ls.setup {
-- TODO: opening lua scripts still complained about the workspace folder
--  settings = {
--    Lua = {
--      workspace = nil
--    }
--  }
}

require('CopilotChat').setup {

}
