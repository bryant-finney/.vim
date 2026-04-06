-- Test script to run :checkhealth and generate HEALTH.md snapshot
local success = true
local errors = {}

vim.opt.runtimepath:prepend(vim.fn.expand('~/.vim'))
vim.opt.swapfile = false

print('Running checkhealth snapshot test...')
print(string.rep('=', 50))

-- Helper function to write file contents
local function write_file(path, content)
  local file, err = io.open(path, 'w')
  if not file then
    return false, err
  end
  file:write(content)
  file:close()
  return true
end

-- Status icons for markdown output
local STATUS_ICONS = { ok = '✅', warn = '⚠️', err = '❌' }

--------------------------------------------------------------------------------
-- [1/4] Load config
--------------------------------------------------------------------------------
print('\n[1/4] Loading config...')
local ok, err = pcall(function()
  dofile(vim.fn.expand('~/.vim/lua/config.lua'))
end)

if not ok then
  print('⚠ Config load had issues: ' .. tostring(err))
  print('  Continuing with checkhealth anyway...')
else
  print('✓ Config loaded successfully')
end

--------------------------------------------------------------------------------
-- [2/4] Run checkhealth and capture output
--------------------------------------------------------------------------------
print('\n[2/4] Running :checkhealth...')
local lines = {}
ok, err = pcall(function()
  vim.cmd('checkhealth')
  lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
end)

if not ok or #lines == 0 then
  success = false
  table.insert(errors, 'Failed to run checkhealth: ' .. tostring(err))
  print('✗ checkhealth failed')
else
  print('✓ checkhealth completed (' .. #lines .. ' lines captured)')
end

--------------------------------------------------------------------------------
-- [3/4] Parse output and generate markdown
--------------------------------------------------------------------------------
print('\n[3/4] Parsing checkhealth output...')

-- Data structures
local sections = {}
local current_section = nil
local current_subsection = nil
local current_item = nil
local in_advice = false

-- Detect treesitter parser/feature matrix lines: "  - parser_name  ✓ . ✓ . ✓"
local function is_parser_matrix_line(line)
  return line:match('^  %- %S+%s+[✓%.%s]+$') ~= nil
end

-- Ensure a default subsection exists for items outside any named subsection
local function ensure_subsection(section)
  if not current_subsection then
    current_subsection = { name = nil, items = {}, raw_lines = {} }
    table.insert(section.subsections, current_subsection)
  end
end

local i = 1
while i <= #lines do
  local line = lines[i]

  -- Section separator: ====...====
  if line:match('^==========') then
    -- Next non-empty line is the section header
    if i + 1 <= #lines then
      i = i + 1
      local header = lines[i]
      local name = header:match('^(.-):%s')
      if name then
        name = vim.trim(name)
        current_section = {
          name = name,
          counts = { ok = 0, warn = 0, err = 0 },
          subsections = {},
          parser_matrix_count = 0,
        }
        table.insert(sections, current_section)
        current_subsection = nil
        current_item = nil
        in_advice = false
      end
    end

  -- Subsection header: starts at column 0, at least 3 chars before " ~", ends with " ~"
  elseif line:match('^%S..+ ~$') and current_section then
    local sub_name = vim.trim(line:match('^(.+) ~$'))
    -- Strip decorative "=====" borders from subsection names
    sub_name = sub_name:gsub('^=+%s*', ''):gsub('%s*=+$', '')
    current_subsection = { name = sub_name, items = {}, raw_lines = {} }
    table.insert(current_section.subsections, current_subsection)
    current_item = nil
    in_advice = false

  -- Parser/Features matrix line (nvim-treesitter verbose output)
  elseif is_parser_matrix_line(line) and current_section then
    current_section.parser_matrix_count = current_section.parser_matrix_count + 1
    current_item = nil

  -- ADVICE block header
  elseif line:match('^%s+%- ADVICE:') and current_item then
    in_advice = true

  -- Advice item line
  elseif in_advice and line:match('^%s+%- .') and current_item then
    local advice_text = vim.trim(line:match('^%s+%- (.+)'))
    if not current_item.advice then
      current_item.advice = {}
    end
    table.insert(current_item.advice, advice_text)

  -- Status item: OK
  elseif line:match('^%- ✅') and current_section then
    local text = line:match('^%- ✅ OK (.+)') or line:match('^%- ✅ (.+)') or ''
    current_item = { status = 'ok', text = text, continuation = {} }
    current_section.counts.ok = current_section.counts.ok + 1
    ensure_subsection(current_section)
    table.insert(current_subsection.items, current_item)
    in_advice = false

  -- Status item: WARNING
  elseif line:match('^%- ⚠️') and current_section then
    local text = line:match('^%- ⚠️ WARNING (.+)') or line:match('^%- ⚠️ (.+)') or ''
    current_item = { status = 'warn', text = text, continuation = {} }
    current_section.counts.warn = current_section.counts.warn + 1
    ensure_subsection(current_section)
    table.insert(current_subsection.items, current_item)
    in_advice = false

  -- Status item: ERROR
  elseif line:match('^%- ❌') and current_section then
    local text = line:match('^%- ❌ ERROR (.+)') or line:match('^%- ❌ (.+)') or ''
    current_item = { status = 'err', text = text, continuation = {} }
    current_section.counts.err = current_section.counts.err + 1
    ensure_subsection(current_section)
    table.insert(current_subsection.items, current_item)
    in_advice = false

  -- LSP config block header: "- config_name:" (no status emoji)
  elseif line:match('^%- %S+:$') and current_section and current_section.name == 'vim.lsp' then
    local config_name = line:match('^%- (%S+):$')
    current_item = { status = 'info', text = config_name, continuation = {} }
    ensure_subsection(current_section)
    table.insert(current_subsection.items, current_item)
    in_advice = false

  -- Continuation line (indented, belongs to current item)
  elseif line:match('^%s%s') and current_item and not in_advice then
    table.insert(current_item.continuation, vim.trim(line))

  -- Non-status informational line in a section
  elseif current_section and line ~= '' and not line:match('^=') then
    -- Ensure we have a subsection to store raw lines
    ensure_subsection(current_section)
    -- Only collect if it's not a continuation of a status item
    if not current_item or (not line:match('^%s%s') and not line:match('^%s*$')) then
      table.insert(current_subsection.raw_lines, line)
      current_item = nil
      in_advice = false
    end
  else
    -- Empty line or other -- reset advice tracking
    if line == '' then
      in_advice = false
    end
  end

  i = i + 1
end

print('✓ Parsed ' .. #sections .. ' sections')

-- Build markdown
local md = {}

-- Header
table.insert(md, '# Neovim Health Check')
table.insert(md, '')
table.insert(md, string.format('> Generated on %s by `poe test-checkhealth`', os.date('%Y-%m-%d')))
table.insert(md, '')

-- Summary table
table.insert(md, '## Summary')
table.insert(md, '')
table.insert(md, '| Section | Status | OK | Warnings | Errors |')
table.insert(md, '|---------|--------|----|----------|--------|')

for _, section in ipairs(sections) do
  local status_icon
  if section.counts.err > 0 then
    status_icon = '❌'
  elseif section.counts.warn > 0 then
    status_icon = '⚠️'
  else
    status_icon = '✅'
  end
  -- Generate anchor: lowercase, spaces to hyphens, strip dots
  local anchor = section.name:lower():gsub('%s+', '-'):gsub('%.', '')
  table.insert(md, string.format('| [%s](#%s) | %s | %d | %d | %d |',
    section.name, anchor, status_icon, section.counts.ok, section.counts.warn, section.counts.err))
end

-- Section details
for _, section in ipairs(sections) do
  table.insert(md, '')
  table.insert(md, '## ' .. section.name)

  -- Show parser matrix summary if present
  if section.parser_matrix_count > 0 then
    table.insert(md, '')
    table.insert(md, string.format(
      '*%d parsers with feature support. Run `:checkhealth %s` for full matrix.*',
      section.parser_matrix_count, section.name))
  end

  for _, subsection in ipairs(section.subsections) do
    -- Emit subsection heading (skip unnamed default subsections)
    if subsection.name then
      table.insert(md, '')
      table.insert(md, '### ' .. subsection.name)
    end
    table.insert(md, '')

    -- Check if this subsection should be condensed (>20 items, all OK)
    local non_ok_items = {}
    for _, item in ipairs(subsection.items) do
      if item.status ~= 'ok' and item.status ~= 'info' then
        table.insert(non_ok_items, item)
      end
    end

    local condense = #subsection.items > 20 and #non_ok_items == 0

    if condense then
      table.insert(md, string.format(
        '*%d items checked (all OK). Run `:checkhealth %s` for full list.*',
        #subsection.items, section.name))
    else
      -- Emit items
      for _, item in ipairs(subsection.items) do
        local icon = STATUS_ICONS[item.status]

        if item.status == 'info' then
          -- LSP config block: parse key-value structure into markdown
          table.insert(md, '')
          table.insert(md, '#### ' .. item.text)
          table.insert(md, '')
          -- Extract top-level "- key: value" pairs from continuation lines
          local j = 1
          while j <= #item.continuation do
            local line = item.continuation[j]
            local key, value = line:match('^%- (%w[%w_]*): (.+)')
            if key then
              -- Skip multi-line blocks and trivial empty ones (e.g. settings: {})
              if value:match('^{%s*}%s*$') then
                -- Skip empty table values like "settings: {}"
              elseif value:match('^{') and not value:match('}%s*$') then
                -- Skip nested block lines (settings, handlers, init_options)
                local depth = 1
                while depth > 0 and j < #item.continuation do
                  j = j + 1
                  local inner = item.continuation[j]
                  for _ in inner:gmatch('{') do depth = depth + 1 end
                  for _ in inner:gmatch('}') do depth = depth - 1 end
                end
              elseif key == 'cmd' then
                -- Format cmd array as a command string
                local cmd_str = value:match('^{ (.+) }$')
                if cmd_str then
                  cmd_str = cmd_str:gsub('"', ''):gsub(',%s*', ' ')
                else
                  cmd_str = value
                end
                table.insert(md, '- **cmd:** `' .. cmd_str .. '`')
              elseif key == 'filetypes' then
                -- Render filetypes as comma-separated inline code
                local types = {}
                for ft in value:gmatch('%S+') do
                  local cleaned = ft:gsub(',', '')
                  if cleaned ~= '' then table.insert(types, '`' .. cleaned .. '`') end
                end
                table.insert(md, '- **filetypes:** ' .. table.concat(types, ', '))
              elseif key == 'root_markers' then
                -- Render root_markers as comma-separated inline code
                local markers = {}
                for m in value:gmatch('"([^"]+)"') do
                  table.insert(markers, '`' .. m .. '`')
                end
                if #markers > 0 then
                  table.insert(md, '- **root_markers:** ' .. table.concat(markers, ', '))
                else
                  table.insert(md, '- **root_markers:** ' .. value)
                end
              elseif key == 'on_attach' or key == 'before_init' or key == 'root_dir' then
                -- Show function references with just the file:line
                local ref = value:match('@(.+)>') or value
                table.insert(md, '- **' .. key .. ':** `' .. ref .. '`')
              else
                -- Other simple key-value pairs
                table.insert(md, '- **' .. key .. ':** ' .. value)
              end
            end
            j = j + 1
          end
          table.insert(md, '')
        else
          -- Standard status item
          table.insert(md, '- ' .. (icon or '?') .. ' ' .. item.text)

          -- Continuation lines (indented under the bullet)
          if #item.continuation > 0 then
            local limit = math.min(#item.continuation, 5)
            for j = 1, limit do
              table.insert(md, '  ' .. item.continuation[j])
            end
            if #item.continuation > 5 then
              table.insert(md, '  *...(' .. (#item.continuation - 5) .. ' more lines)*')
            end
          end

          -- Advice lines
          if item.advice and #item.advice > 0 then
            for _, advice in ipairs(item.advice) do
              table.insert(md, '  - **Advice:** ' .. advice)
            end
          end
        end
      end
    end

    -- Raw informational lines
    if #subsection.raw_lines > 0 and not condense then
      table.insert(md, '')
      if #subsection.raw_lines <= 10 then
        for _, raw in ipairs(subsection.raw_lines) do
          table.insert(md, raw)
        end
      else
        table.insert(md, string.format('*(%d additional info lines omitted)*', #subsection.raw_lines))
      end
    end
  end
end

-- Trailing newline
table.insert(md, '')

-- Post-process: trim trailing whitespace and collapse consecutive blank lines
local cleaned = {}
local prev_blank = false
for _, line in ipairs(md) do
  line = line:gsub('%s+$', '')
  if line == '' then
    if not prev_blank then
      table.insert(cleaned, line)
    end
    prev_blank = true
  else
    prev_blank = false
    table.insert(cleaned, line)
  end
end

local content = table.concat(cleaned, '\n')
print('✓ Generated markdown (' .. #cleaned .. ' lines)')

--------------------------------------------------------------------------------
-- [4/4] Write HEALTH.md
--------------------------------------------------------------------------------
print('\n[4/4] Writing HEALTH.md...')
local output_path = vim.fn.expand('~/.vim/HEALTH.md')
local wrote, write_err = write_file(output_path, content)

if not wrote then
  success = false
  table.insert(errors, 'Failed to write HEALTH.md: ' .. tostring(write_err))
  print('✗ Failed to write HEALTH.md')
else
  print('✓ HEALTH.md written to ' .. output_path)
end

--------------------------------------------------------------------------------
-- Results
--------------------------------------------------------------------------------
print('\n' .. string.rep('=', 50))

if success then
  print('ALL TESTS PASSED ✓')
  print('\nGenerated HEALTH.md snapshot of current health status.')
  os.exit(0)
else
  print('TESTS FAILED ✗')
  print('\nErrors found:')
  for _, error_msg in ipairs(errors) do
    print('  - ' .. error_msg)
  end
  os.exit(1)
end
