-- More than mostly needed table functions

local spr = require("src.warm.spr")
local main = {}

-- A accurate way to check is empty or empty items
--
-- Since #table only returns the total indexable items in the table
--
-- use this to check for keys of any type.
---@param tbl table<any>
---@return boolean
function main.is_empty(tbl)
  spr.validate({ "table" }, { tbl })
  return next(tbl) == nil
end

---Return the table type
--
---Not a table `-1`, empty `0`, list `1`, dict `2`, mixed `3`,
---@param tbl table
---@return -1|0|1|2|3
function main.type(tbl)
  if type(tbl) ~= "table" then return -1 end
  local kc = #main.get_keys(tbl)
  -- stylua: ignore
  return spr.switch(true)({
    { main.is_empty(tbl),     0 }, -- Empty
    { (#tbl == kc),           1 }, -- List
    { (#tbl == 0 and kc > 0), 2 }, -- Dict
    { (#tbl ~= kc),           3 }, -- Mixed
  })
end

---Get all keys in a table
---@param tbl table<any, any>
---@return table<any>
function main.get_keys(tbl)
  spr.validate({ "table" }, { tbl })
  if main.is_empty(tbl) then return {} end
  local keys = {}
  for key, _ in pairs(tbl) do
    table.insert(keys, key)
  end
  return keys
end

---Get all values in a table
---@param tbl table<any, any>
---@return table<any>
function main.get_vals(tbl)
  spr.validate({ "table" }, { tbl })
  if main.is_empty(tbl) then return {} end
  local vals = {}
  for _, val in pairs(tbl) do
    table.insert(vals, val)
  end
  return vals
end

---Make table flat, not containing tables
---the contents of nested tables will be in first level
---@param tbl table
---@return table<any>
function main.flatten(tbl)
  local res = {}
  for k, v in pairs(tbl) do
    local tp = type(v)
    if tp == "table" then
      res = main.extend(res, main.flatten(v))
    else
      res[k] = v
    end
  end
  return res
end

---Extend to a table checking for duplicate keys
--
--- If `force` is true, it will not keep duplicate keys values
---@param ts table
---@param td table
---@param force? boolean
---@return table
function main.extend(ts, td, force)
  spr.validate({ "table", "table", { "boolean?" } }, { ts, td, force })
  if main.is_empty(ts) then return td end
  if main.is_empty(td) then return ts end
  local res = ts
  for k, v in pairs(td) do
    if res[k] == nil or (type(res[k]) == "table" and #main.get_keys(res[k]) == 0) then
      res[k] = v
    elseif force then
      res[k] = v
    else
      res[#res + 1] = v
    end
  end
  return res
end

---Merges the given tables into one table
---@param ts table
---@param td table
---@return table
function main.merge(ts, td)
  spr.validate({ "table", "table" }, { ts, td })
  if main.is_empty(ts) then return td end
  if main.is_empty(td) then return ts end
  local res = ts
  for k, _ in pairs(td) do
    if td[k] ~= nil then res[k] = td[k] end
  end
  return res
end

---Merge the given tables recursively
---@param ts table
---@param td table
---@return table
function main.deep_merge(ts, td)
  spr.validate({ "table", "table" }, { ts, td })
  if main.is_empty(td) then return ts end
  if main.is_empty(ts) then return td end
  local res = ts
  for k, v in pairs(td) do
    if td[k] ~= nil then
      local t1, t2 = type(res[k]), type(v)
      if t1 == "table" and t2 == "table" then
        res[k] = main.deep_merge(res[k], td[k])
      elseif t1 == "table" then
        res[k] = table.insert(res[k], v)
      elseif t2 == "table" then
        res[k] = table.insert(v, res[k])
      else
        res[k] = v
      end
    end
  end
  return res
end

---Filter a table by a given condition function
---@param tbl table
---@param condition fun(k, v):boolean
---@param recurse? boolean
---@return table
function main.filter(tbl, condition, recurse)
  ---@diagnostic disable-next-line: cast-local-type
  tbl, condition, recurse = table.unpack(
    spr.parse_args(
      { "table", "function", { "boolean?", def = false } },
      { tbl, condition, recurse }
    )
  )
  ---@cast tbl table
  ---@cast condition fun(k, v): boolean
  ---@cast recurse boolean?

  local result = {}
  for k, v in pairs(tbl) do
    if type(v) == "table" and recurse then
      result[k] = main.filter(v, condition, true)
    elseif condition(k, v) then
      -- If table has indexed values, then treat the
      -- table as a list and not a k, v pairs table.
      -- if #tbl >= 1 then
      if type(k) == "number" then
        table.insert(result, v)
      else
        result[k] = v
      end
    end
  end
  return result
end

---Check whether an item exists in a table
---@param tbl table
---@param val any
---@return boolean
---@return integer
function main.contains(tbl, val)
  spr.validate({ "table", "some" }, { tbl, val })
  for i, v in pairs(tbl) do
    if v == val then return true, i end
  end
  return false, 0
end

---Returns true if all items are some (not nil) or true, otherwise false.
---@param tbl table
---@return boolean
function main.all(tbl)
  spr.validate({ "table" }, { tbl })
  for _, v in pairs(tbl) do
    if v == nil or v == false then return false end
  end
  return true
end

---Returns true if any item is some (not nil) or true, otherwise false.
---@param tbl table
---@return boolean
function main.any(tbl)
  spr.validate({ "table" }, { tbl })
  for _, v in pairs(tbl) do
    if v ~= nil and v then return true end
  end
  return false
end

---Turn all table values into a boolean value
---@param tbl table
---@param recurse? boolean
---@return table<boolean>
function main.boolean(tbl, recurse)
  ---@diagnostic disable-next-line: cast-local-type
  tbl, recurse =
    table.unpack(spr.parse_args({ "table", { "boolean?", def = false } }, { tbl, recurse }))
  ---@cast tbl table
  ---@cast recurse boolean?
  local recursive = (recurse ~= nil and recurse ~= false) or false
  local result = {}
  for k, v in pairs(tbl) do
    local vt = type(v)
    if vt == "table" and recursive then
      result[k] = main.boolean(v, true)
    else
      result[k] = (
        v ~= nil
        and (
          (vt ~= "string" and vt ~= "table")
          or (vt == "string" and #v > 0)
          or (vt == "table" and not main.is_empty(v))
        )
      )
    end
  end
  return result
end

---Run fun for every k, v from the given table
---
---fun receives k, v from the given table, this function (map)
---and the function fun (self)
-- ```lua
-- local prcstbl = main.map(table, function(k, v, map, me)
--   -- Make recursive mapping
--   if type(v) == "table" then return map(v, me) end
--   -- Do stuff with k, v
-- end)
-- ```
---@param tbl table Table to map
---@param fun fun(k, v, map:function, me:function) Callback to run for each item
---@param track boolean Keep track of key names
---@return table<integer, {key:string|integer, ret:any}>
function main.map(tbl, fun, track)
  if track == nil then track = false end
  spr.validate({ "table", "function", "boolean" }, { tbl, fun, track })
  local rvl = {}
  for k, v in pairs(tbl) do
    rvl[#rvl + 1] = fun(k, v, main.map, fun)
    if track then rvl[#rvl] = {
      key = k,
      ret = rvl[#rvl],
    } end
  end
  return rvl
end

-- Returns a function that returns every element of the given indexed table.
--
-- When all items are mapped, restarts the process
---@param tbl table
---@return fun():any|nil
function main.iter(tbl)
  spr.validate({ "table" }, { tbl })
  -- A table with one item only... is not worth it
  local ks = nil
  return function()
    local k, v = next(tbl, ks)
    if k == nil then
      k, v = next(tbl, ks)
    end
    ks = k
    return v
  end
end

---Shuffle items in a table
---@generic T
---@param tbl T[]
---@return T[]
function main.shuffle(tbl)
  spr.validate({ "table" }, { tbl })
  local size = #tbl
  for i = size, 1, -1 do
    local rand = math.random(size)
    tbl[i], tbl[rand] = tbl[rand], tbl[i]
  end
  return tbl
end

---Remove duplicate values
---@param tbl table
---@return table
function main:dedup(tbl)
  local seen = {}
  local res = {}
  for k, v in pairs(tbl) do
    if not seen[v] then
      res[k] = v
      seen[v] = true
    end
  end
  return res
end

---Return the dominant value based on the given function
---@param tbl table
---@param fun fun(k, cur)
---@param mem? any
---@return any
function main.reduce(tbl, fun, mem)
  local res = mem
  for _, v in pairs(tbl) do
    res = fun(v, res)
  end
  return res
end

---Return tbl[idx] or a random item from it
---@param tbl any[]
---@param idx? integer
---@return any
function main.choose(tbl, idx)
  spr.validate({ "table", "number?" }, { tbl, idx })
  if idx ~= nil and tbl[idx] ~= nil then return tbl[idx] end
  return tbl[math.random(#tbl)]
end

---Lua table.unpack with dict like list support, as well as key filtering.
---
---Note that keys are returned as they where defined or added, so { a = 1, b = "2" } will return 1, "2"
---
---Returns the elements from the given list. This function is equivalent to
---```lua
---    return list[i], list[i+1], ···, list[j]
---```
---By default, `i` is `1` and `j` is `#list`.
---@generic T
---@param tbl table<any, T>
---@param i?   integer
---@param j?   integer
---@param keys?   table
---@return T   ...
---@nodiscard
function main.unpack(tbl, i, j, keys)
  spr.validate({ "table", "number?", "number?", "number?" }, { tbl, i, j, keys })
  -- Manage negative numbers
  if i == nil then i = 1 end
  if j == nil then j = #tbl end
  -- if i < 0 then i = 1 end -- A table can have
  -- if j < 0 then j = #tbl end -- negative numbers

  local range = spr.range(i, j)

  if keys == nil or #keys == 0 then keys = main.get_keys(tbl) end
  local res = {}
  for k, v in pairs(tbl) do
    local tk = type(k)
    if tk == "string" then
      if main.contains(keys, k) then table.insert(res, v) end
    elseif tk == "number" then
      if range % k then table.insert(res, v) end
    end
  end
  return table.unpack(res)
end

return main
