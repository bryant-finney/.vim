-- Test script to verify pyright LSP functionality
local success = true
local errors = {}

vim.opt.runtimepath:prepend(vim.fn.expand('~/.vim'))
vim.opt.swapfile = false  -- Disable swap files for tests

print("Testing pyright LSP...")
print(string.rep("=", 50))

-- Load config
print("\n[1/5] Loading config...")
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

-- Verify pyright is configured
print("\n[2/5] Verifying pyright configuration...")
if vim.lsp and vim.lsp.config and vim.lsp.config.pyright then
  print("✓ pyright is configured")

  -- Check that disableOrganizeImports is set
  local pyright_config = vim.lsp.config.pyright
  if pyright_config.settings and
     pyright_config.settings.pyright and
     pyright_config.settings.pyright.disableOrganizeImports == true then
    print("✓ disableOrganizeImports is enabled (using Ruff)")
  else
    success = false
    table.insert(errors, "disableOrganizeImports is not properly configured")
    print("✗ disableOrganizeImports is not properly configured")
  end
else
  success = false
  table.insert(errors, "pyright is not configured")
  print("✗ pyright is not configured")
end

-- Create and open a test file
print("\n[3/5] Creating test file with type error...")
local test_file = vim.fn.expand('~/.vim/tests/fixtures/temp-pyright-test.py')
local f = io.open(test_file, 'w')
f:write([[
def greet(name: str) -> str:
    return f"Hello, {name}"

# Type error: incompatible assignment
result: int = greet("World")
]])
f:close()
print("✓ Created test file")

-- Open the file
print("\n[4/5] Opening file and waiting for LSP...")
vim.cmd('edit ' .. test_file)

-- Wait for LSP attachment
local attached = false
local pyright_client = nil
for i = 1, 50 do
  vim.wait(100)
  local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf(), name = 'pyright' })
  if #clients > 0 then
    attached = true
    pyright_client = clients[1]
    print("✓ pyright attached after " .. (i * 100) .. "ms")
    break
  end
end

if not attached then
  success = false
  table.insert(errors, "pyright did not attach")
  print("✗ pyright did not attach")
end

-- Check for diagnostics
print("\n[5/5] Checking type error detection...")
if attached then
  vim.wait(3000)  -- Wait for diagnostics

  local diagnostics = vim.diagnostic.get(vim.api.nvim_get_current_buf())
  if #diagnostics > 0 then
    print("✓ Received " .. #diagnostics .. " diagnostic(s)")
    -- Check if we got the expected type error
    local found_type_error = false
    for _, diag in ipairs(diagnostics) do
      if diag.message:match("type") or diag.message:match("int") then
        found_type_error = true
        break
      end
    end
    if found_type_error then
      print("✓ Type error correctly detected")
    else
      print("⚠ Diagnostics received but type error not found")
    end
  else
    success = false
    table.insert(errors, "No diagnostics received (type checking may not be working)")
    print("✗ No diagnostics received")
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
