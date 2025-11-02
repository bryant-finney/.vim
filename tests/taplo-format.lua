-- Test script to verify taplo LSP autoformatting on save
local success = true
local errors = {}

-- Set up the runtime path to find the config
vim.opt.runtimepath:prepend(vim.fn.expand('~/.vim'))

print("Testing taplo LSP autoformatting on save...")
print(string.rep("=", 50))

-- Helper function to read file contents
local function read_file(path)
  local file = io.open(path, 'r')
  if not file then
    return nil
  end
  local content = file:read('*all')
  file:close()
  return content
end

-- Helper function to write file contents
local function write_file(path, content)
  local file = io.open(path, 'w')
  if not file then
    return false
  end
  file:write(content)
  file:close()
  return true
end

-- Test 1: Load config and verify taplo is configured
print("\n[1/6] Loading config and verifying taplo LSP configuration...")
local ok, err = pcall(function()
  -- Load the full config (plugins are available since we run without --noplugin)
  dofile(vim.fn.expand('~/.vim/lua/config.lua'))
end)

if not ok then
  success = false
  table.insert(errors, "Failed to load config.lua: " .. tostring(err))
  print("✗ Failed to load config")
else
  print("✓ Config loaded successfully")
end

-- Verify taplo is configured
if vim.lsp and vim.lsp.config and vim.lsp.config.taplo then
  print("✓ Taplo LSP is configured")
else
  success = false
  table.insert(errors, "Taplo LSP is not configured in vim.lsp.config")
  print("✗ Taplo LSP is not configured")
end

-- Test 2: Create a temporary test file
print("\n[2/6] Creating temporary test file...")
local test_dir = vim.fn.expand('~/.vim/tests/fixtures')
local unformatted_path = test_dir .. '/unformatted.toml'
local formatted_path = test_dir .. '/formatted.toml'
-- Create temp file INSIDE the workspace but OUTSIDE fixtures (which is excluded)
-- so .taplo.toml config is applied
local temp_path = vim.fn.expand('~/.vim/tests/temp-test.toml')

local unformatted_content = read_file(unformatted_path)
if not unformatted_content then
  success = false
  table.insert(errors, "Failed to read unformatted.toml fixture")
  print("✗ Failed to read unformatted fixture")
else
  if write_file(temp_path, unformatted_content) then
    print("✓ Created temp file: " .. temp_path)
  else
    success = false
    table.insert(errors, "Failed to write temp file")
    print("✗ Failed to create temp file")
  end
end

-- Test 3: Open the file in a buffer
print("\n[3/6] Opening file in buffer...")
vim.cmd('edit ' .. temp_path)
local bufnr = vim.api.nvim_get_current_buf()
print("✓ Opened buffer " .. bufnr)

-- Test 4: Wait for taplo LSP to attach
print("\n[4/6] Waiting for taplo LSP to attach...")
local max_wait = 50  -- 5 seconds max (50 * 100ms)
local attached = false
for i = 1, max_wait do
  vim.wait(100)  -- Wait 100ms
  local clients = vim.lsp.get_clients({ bufnr = bufnr, name = 'taplo' })
  if #clients > 0 then
    attached = true
    print("✓ Taplo LSP attached after " .. (i * 100) .. "ms")

    -- Check if formatting is supported
    local client = clients[1]
    if client.supports_method('textDocument/formatting') then
      print("✓ Taplo LSP supports textDocument/formatting")
    else
      success = false
      table.insert(errors, "Taplo LSP does not support textDocument/formatting")
      print("✗ Taplo LSP does not support formatting")
    end
    break
  end
end

if not attached then
  success = false
  table.insert(errors, "Taplo LSP did not attach within timeout")
  print("✗ Taplo LSP did not attach (timeout after 5s)")
  print("  This might mean:")
  print("    - Taplo is not installed")
  print("    - LSP is not starting for TOML files")
  print("    - Configuration issue in lua/taplo.lua")
end

-- Test 5: Save the file (should trigger autoformat)
print("\n[5/6] Saving file (should trigger autoformat)...")
if attached then
  -- Wait a bit for LSP to be fully ready
  vim.wait(500)

  -- Save the file
  vim.cmd('write')
  print("✓ File saved")

  -- Wait for formatting to complete
  vim.wait(1000)
else
  print("⚠ Skipping save test (LSP not attached)")
end

-- Test 6: Verify the file was formatted
print("\n[6/6] Verifying file was formatted...")
local expected_content = read_file(formatted_path)
local actual_content = read_file(temp_path)

if not expected_content then
  success = false
  table.insert(errors, "Failed to read formatted.toml fixture")
  print("✗ Failed to read expected formatted fixture")
elseif not actual_content then
  success = false
  table.insert(errors, "Failed to read temp file after save")
  print("✗ Failed to read temp file")
else
  if actual_content == expected_content then
    print("✓ File was formatted correctly!")
  else
    success = false
    table.insert(errors, "File was not formatted as expected")
    print("✗ File was NOT formatted correctly")
    print("\n  Expected length: " .. #expected_content .. " bytes")
    print("  Actual length:   " .. #actual_content .. " bytes")

    -- Show first difference
    for i = 1, math.min(#expected_content, #actual_content) do
      if expected_content:sub(i, i) ~= actual_content:sub(i, i) then
        local context_start = math.max(1, i - 20)
        local context_end = math.min(#actual_content, i + 20)
        print("\n  First difference at byte " .. i .. ":")
        print("  Expected: '" .. expected_content:sub(context_start, context_end):gsub('\n', '\\n') .. "'")
        print("  Actual:   '" .. actual_content:sub(context_start, context_end):gsub('\n', '\\n') .. "'")
        break
      end
    end
  end
end

-- Cleanup
print("\n" .. string.rep("=", 50))
os.remove(temp_path)

-- Print results
if success then
  print("ALL TESTS PASSED ✓")
  print("\nTaplo LSP is correctly autoformatting TOML files on save!")
  os.exit(0)
else
  print("TESTS FAILED ✗")
  print("\nErrors found:")
  for _, error_msg in ipairs(errors) do
    print("  - " .. error_msg)
  end
  print("\nThis indicates that taplo LSP is not formatting files on save.")
  print("Check lua/taplo.lua configuration and ensure:")
  print("  1. Taplo is installed and available")
  print("  2. The on_attach function is being called")
  print("  3. The BufWritePre autocommand is being created")
  os.exit(1)
end
