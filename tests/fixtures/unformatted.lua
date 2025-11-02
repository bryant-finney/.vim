-- Lua file with various issues for testing lua_ls
local function test_function( a,b,c )
  local x=1
  local y = 2
  local unused_variable = 3

  if a==b then
    print("a equals b")
  end

  -- Missing return statement
end

-- Global variable (should warn)
global_var = "test"

-- Undefined variable usage
local result = undefined_var + 10

-- Inconsistent spacing
local table1={a=1,b=2,c=3}
local table2 = { d = 4, e = 5 }
