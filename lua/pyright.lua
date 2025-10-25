vim.lsp.enable('pyright')

return {
  settings = {
    pyright = {
      -- Use Ruff's import organizer
      disableOrganizeImports = true,
    },
  },
}
