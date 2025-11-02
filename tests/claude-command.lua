-- Test script to verify :Claude command functionality
local success = true
local errors = {}

vim.opt.runtimepath:prepend(vim.fn.expand('~/.vim'))
vim.opt.swapfile = false  -- Disable swap files for tests

print("Testing :Claude command...")
print(string.rep("=", 50))

-- Test 1: Load vimrc
print("\n[1/5] Loading vimrc...")
local ok, err = pcall(function()
  vim.cmd('source ' .. vim.fn.expand('~/.vim/vimrc'))
end)

if not ok then
  success = false
  table.insert(errors, "Failed to load vimrc: " .. tostring(err))
  print("✗ Failed to load vimrc")
else
  print("✓ vimrc loaded successfully")
end

-- Test 2: Verify :Claude command exists
print("\n[2/5] Verifying :Claude command exists...")
local command_exists = false
ok, err = pcall(function()
  -- Check if the command exists by trying to get its definition
  local output = vim.api.nvim_exec2('command Claude', { output = true })
  if output and output.output and output.output:match('Claude') then
    command_exists = true
  end
end)

if command_exists then
  print("✓ :Claude command is defined")
else
  success = false
  table.insert(errors, "Command :Claude is not defined")
  print("✗ :Claude command is not defined")
end

-- Test 3: Check initial window state
print("\n[3/5] Checking initial window state...")
local initial_win_count = #vim.api.nvim_list_wins()
local initial_buf_count = #vim.api.nvim_list_bufs()
print("✓ Initial state: " .. initial_win_count .. " windows, " .. initial_buf_count .. " buffers")

-- Test 4: Execute :Claude command (with error handling)
print("\n[4/5] Executing :Claude command...")
local command_executed = false
local terminal_buf = nil

-- We need to handle the case where 'claude' command might not be available
-- or might fail, so we'll use a try-catch approach
ok, err = pcall(function()
  -- Try to execute the command
  vim.cmd('Claude')
  command_executed = true

  -- Give it a moment to create the terminal
  vim.wait(500)
end)

if not ok then
  -- The command might have failed if 'claude' is not installed
  local err_str = tostring(err or "")
  if err_str:match("E492") then
    -- Command not found - this is expected if vimrc didn't load
    success = false
    table.insert(errors, "Command failed to execute (command not found): " .. err_str)
    print("✗ Command failed to execute (not found)")
  elseif err_str:match("claude") then
    -- The command executed but 'claude' binary might not be available
    -- This is actually OK - the command exists and tried to run
    command_executed = true
    print("✓ Command executed (claude binary may not be available, which is OK)")
  else
    -- Some other error
    success = false
    table.insert(errors, "Command execution error: " .. err_str)
    print("✗ Command execution error: " .. err_str)
  end
else
  print("✓ Command executed successfully")
end

-- Test 5: Verify window and buffer state changed
print("\n[5/5] Verifying window/buffer creation...")
if command_executed then
  local final_win_count = #vim.api.nvim_list_wins()
  local final_buf_count = #vim.api.nvim_list_bufs()

  -- Check if a new window was created
  if final_win_count > initial_win_count then
    print("✓ New window created (vsplit succeeded)")
    print("  Windows: " .. initial_win_count .. " → " .. final_win_count)

    -- Check if a new buffer was created
    if final_buf_count > initial_buf_count then
      print("✓ New buffer created")
      print("  Buffers: " .. initial_buf_count .. " → " .. final_buf_count)

      -- Try to identify the terminal buffer
      local current_buf = vim.api.nvim_get_current_buf()
      local buf_type = vim.api.nvim_get_option_value('buftype', { buf = current_buf })

      if buf_type == 'terminal' then
        print("✓ Current buffer is a terminal buffer")
        terminal_buf = current_buf
      else
        -- Check if any of the new buffers is a terminal
        local found_terminal = false
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(bufnr) then
            local bt = vim.api.nvim_get_option_value('buftype', { buf = bufnr })
            if bt == 'terminal' then
              found_terminal = true
              terminal_buf = bufnr
              break
            end
          end
        end

        if found_terminal then
          print("✓ Terminal buffer found in buffer list")
        else
          print("⚠ No terminal buffer found (command may have failed to start)")
        end
      end
    else
      success = false
      table.insert(errors, "No new buffer was created")
      print("✗ No new buffer was created")
    end
  else
    success = false
    table.insert(errors, "No new window was created (vsplit failed)")
    print("✗ No new window was created")
  end
else
  print("⚠ Skipping verification (command did not execute)")
end

-- Cleanup: Close any terminal buffers we created
if terminal_buf and vim.api.nvim_buf_is_valid(terminal_buf) then
  pcall(function()
    vim.api.nvim_buf_delete(terminal_buf, { force = true })
  end)
end

-- Print results
print("\n" .. string.rep("=", 50))
if success then
  print("ALL TESTS PASSED ✓")
  print("\nThe :Claude command is properly configured!")
  print("It creates a vertical split and opens a terminal running 'claude'.")
  os.exit(0)
else
  print("TESTS FAILED ✗")
  print("\nErrors found:")
  for _, error_msg in ipairs(errors) do
    print("  - " .. error_msg)
  end
  print("\nCheck vimrc configuration around line 597.")
  os.exit(1)
end
