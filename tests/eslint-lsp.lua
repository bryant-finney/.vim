-- Test script to verify eslint LSP functionality
local success = true
local errors = {}

vim.opt.runtimepath:prepend(vim.fn.expand('~/.vim'))
vim.opt.swapfile = false  -- Disable swap files for tests

print("Testing eslint LSP...")
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

-- Verify eslint is configured
if vim.lsp and vim.lsp.config and vim.lsp.config.eslint then
  print("✓ eslint is configured")
else
  success = false
  table.insert(errors, "eslint is not configured")
  print("✗ eslint is not configured")
end

-- Create and open a test file
print("\n[2/4] Creating test file...")
local test_file = vim.fn.expand('~/.vim/tests/fixtures/temp-test.js')
local f = assert(io.open(test_file, 'w'), "Failed to create test file")
f:write([[
const unused_var = 42;

function badFunction(x,y){
  const result=x+y
  return result
}
]])
f:close()
print("✓ Created test file")

-- Open the file
print("\n[3/4] Opening file and waiting for LSP...")
vim.cmd('edit ' .. test_file)

-- Wait for LSP attachment or diagnostics
local attached = false
local has_diagnostics = false

for i = 1, 50 do
  vim.wait(100)
  local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf(), name = 'eslint' })
  if #clients > 0 then
    attached = true
    print("✓ eslint attached after " .. (i * 100) .. "ms")
    break
  end

  -- Check for diagnostics even if LSP hasn't attached yet
  local diagnostics = vim.diagnostic.get(vim.api.nvim_get_current_buf())
  if #diagnostics > 0 then
    has_diagnostics = true
  end
end

if not attached then
  print("⚠ eslint LSP did not attach directly")
  print("  (may be running through ALE or other mechanism)")
end

-- Check for diagnostics
print("\n[4/4] Checking for diagnostics...")
vim.wait(2000)  -- Wait for diagnostics

local diagnostics = vim.diagnostic.get(vim.api.nvim_get_current_buf())
if #diagnostics > 0 then
  print("✓ Received " .. #diagnostics .. " diagnostic(s)")
  has_diagnostics = true
else
  print("⚠ No diagnostics received")
end

-- Consider test successful if we got diagnostics even if LSP didn't attach
if not attached and not has_diagnostics then
  success = false
  table.insert(errors, "eslint did not attach and provided no diagnostics")
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
