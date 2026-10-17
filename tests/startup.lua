-- Test script to verify Neovim starts without errors (using real plugins, not mocks)
local success = true
local errors = {}

-- Set up the runtime path to find the config
vim.opt.runtimepath:prepend(vim.fn.expand('~/.vim'))

print("Testing Neovim startup...")
print(string.rep("=", 50))

-- Test 1: init.vim -> vimrc -> lua/config.lua ran before this script; any error lands in v:errmsg
print("\n[1/2] Checking for errors raised during startup...")
if vim.v.errmsg == "" then
  print("✓ No errors raised during startup")
else
  success = false
  table.insert(errors, "Startup raised an error: " .. vim.v.errmsg)
  print("✗ Startup raised an error")
end

-- Test 2: Load config.lua against the installed plugins so their setup() validation runs
print("\n[2/2] Loading config.lua with installed plugins...")
local ok, err = pcall(function()
  dofile(vim.fn.expand('~/.vim/lua/config.lua'))
end)

if ok then
  print("✓ config.lua loaded successfully")
else
  success = false
  table.insert(errors, "Failed to load config.lua: " .. tostring(err))
  print("✗ Failed to load config.lua")
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
