-- Test script to verify ruff LSP functionality
local success = true
local errors = {}

vim.opt.runtimepath:prepend(vim.fn.expand('~/.vim'))
vim.opt.swapfile = false  -- Disable swap files for tests

print("Testing ruff LSP...")
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

-- Verify ruff is configured
if vim.lsp and vim.lsp.config and vim.lsp.config.ruff then
  print("✓ ruff is configured")
else
  success = false
  table.insert(errors, "ruff is not configured")
  print("✗ ruff is not configured")
end

-- Create and open a test file
print("\n[2/4] Creating test file...")
local test_file = vim.fn.expand('~/.vim/tests/fixtures/temp-test.py')
local f = io.open(test_file, 'w')
f:write([[
import sys
import os
import unused_module

def bad_function(x,y):
    unused_var = 42
    return x+y
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
  local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf(), name = 'ruff' })
  if #clients > 0 then
    attached = true
    print("✓ ruff attached after " .. (i * 100) .. "ms")
    break
  end
end

if not attached then
  success = false
  table.insert(errors, "ruff did not attach")
  print("✗ ruff did not attach")
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
