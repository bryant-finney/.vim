-- Test script to verify lua_ls LSP functionality
local success = true
local errors = {}

vim.opt.runtimepath:prepend(vim.fn.expand('~/.vim'))
vim.opt.swapfile = false  -- Disable swap files for tests

print("Testing lua_ls LSP...")
print(string.rep("=", 50))

-- Load config
print("\n[1/4] Loading config...")
local ok, err = pcall(function()
  dofile(vim.fn.expand('~/.vim/lua/config.lua'))
end)

if not ok then
  success = false
  table.insert(errors, "Failed to load config: " .. tostring(err))
  print("✗ Failed to load config")
else
  print("✓ Config loaded")
end

-- Verify lua_ls is configured
if vim.lsp and vim.lsp.config and vim.lsp.config.lua_ls then
  print("✓ lua_ls is configured")
else
  success = false
  table.insert(errors, "lua_ls is not configured")
  print("✗ lua_ls is not configured")
end

-- Create and open a test file
print("\n[2/4] Creating test file...")
local test_file = vim.fn.expand('~/.vim/tests/fixtures/temp-test.lua')
local f = io.open(test_file, 'w')
f:write([[
local function test()
  local x = undefined_variable
  print(x)
end
]])
f:close()
print("✓ Created test file")

-- Open the file
print("\n[3/4] Opening file and waiting for LSP...")
vim.cmd('edit ' .. test_file)

-- Wait for LSP attachment
local attached = false
for i = 1, 50 do
  vim.wait(100)
  local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf(), name = 'lua_ls' })
  if #clients > 0 then
    attached = true
    print("✓ lua_ls attached after " .. (i * 100) .. "ms")
    break
  end
end

if not attached then
  success = false
  table.insert(errors, "lua_ls did not attach")
  print("✗ lua_ls did not attach")
end

-- Check for diagnostics
print("\n[4/4] Checking for diagnostics...")
if attached then
  vim.wait(2000)  -- Wait for diagnostics

  local diagnostics = vim.diagnostic.get(vim.api.nvim_get_current_buf())
  if #diagnostics > 0 then
    print("✓ Received " .. #diagnostics .. " diagnostic(s)")
  else
    print("⚠ No diagnostics received (may be expected)")
  end
end

-- Cleanup
os.remove(test_file)

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
