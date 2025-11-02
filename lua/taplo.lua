vim.lsp.enable('taplo')
return {
  cmd = { 'taplo', 'lsp', 'stdio' },
  filetypes = { 'toml' },
  root_markers = { '.taplo.toml', 'taplo.toml', '.git' },

  -- Configure taplo to autoformat TOML files on save
  on_attach = function(client, bufnr)
    if client.supports_method('textDocument/formatting') then
      -- Create an autocommand group for taplo formatting
      local augroup = vim.api.nvim_create_augroup('TaploFormat', { clear = true })

      -- Format on save for TOML files
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- Format synchronously before write
          vim.lsp.buf.format({
            bufnr = bufnr,
            timeout_ms = 3000,
            filter = function(format_client)
              return format_client.name == 'taplo'
            end,
          })
        end,
      })
    end
  end,
}
