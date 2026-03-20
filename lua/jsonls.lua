vim.lsp.enable('jsonls')

return {
  settings = {
    json = {
      schemas = {
        {
          fileMatch = {"package.json"},
          url = "https://json.schemastore.org/package.json"
        },
        {
          fileMatch = {"tsconfig.json", "tsconfig.*.json"},
          url = "https://json.schemastore.org/tsconfig.json"
        },
        {
          fileMatch = {".eslintrc", ".eslintrc.json"},
          url = "https://json.schemastore.org/eslintrc.json"
        },
        {
          fileMatch = {"composer.json"},
          url = "https://json.schemastore.org/composer.json"
        },
      },
      validate = { enable = true },
    },
  },
}