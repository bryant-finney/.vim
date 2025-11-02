-- Test script to verify Neovim configuration
local success = true
local errors = {}

-- Set up the runtime path to find the config
vim.opt.runtimepath:prepend(vim.fn.expand('~/.vim'))

-- Test 1: Load config without errors
print("Testing config.lua syntax and basic loading...")
local ok, err = pcall(function()
  -- Mock the require calls for plugins that may not be installed in CI
  package.loaded['telescope'] = {
    setup = function() end,
    load_extension = function() end,
  }
  package.loaded['telescope.themes'] = {
    get_dropdown = function() return {} end,
  }
  package.loaded['CopilotChat'] = {
    setup = function() end,
  }
  package.loaded['nvim-treesitter.configs'] = {
    setup = function() end,
  }
  package.loaded['octo'] = {
    setup = function() end,
  }

  dofile(vim.fn.expand('~/.vim/lua/config.lua'))
end)

if not ok then
  success = false
  table.insert(errors, "Failed to load config.lua: " .. tostring(err))
else
  print("✓ config.lua loaded successfully")
end

-- Test 2: Verify LSP configurations are set using vim.lsp.config
if vim.lsp and vim.lsp.config then
  local lsp_configs = {'eslint', 'pyright', 'ruff', 'lua_ls', 'taplo'}
  for _, name in ipairs(lsp_configs) do
    if vim.lsp.config[name] ~= nil then
      print("✓ LSP config for " .. name .. " is defined")
    else
      success = false
      table.insert(errors, "LSP config for " .. name .. " is not defined")
    end
  end
else
  print("⚠ vim.lsp.config not available (Neovim version may be < 0.11)")
  print("  Skipping LSP config checks...")
end

-- Print results
print("\n" .. string.rep("=", 50))
if success then
  print("ALL TESTS PASSED ✓")
  os.exit(0)
else
  print("TESTS FAILED ✗")
  for _, error_msg in ipairs(errors) do
    print("  - " .. error_msg)
  end
  os.exit(1)
end
