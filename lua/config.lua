require('lspconfig').pyright.setup {
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
  },
}

require('lspconfig').ruff.setup {}
