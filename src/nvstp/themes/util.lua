local main = {}

function main.extractable(tbl)
  local et = tbl
  for k, v in pairs(tbl) do
    if type(v) == "table" then
      local tmp = setmetatable(main.extractable(v), {
        __tostring = function() return k end,
      })
      et[k] = tmp
    end
  end
  ---Get the child value or the defaults
  ---@param key string|integer
  ---@param def table|string
  ---@return table|string
  function et:get(key, def)
    local v = rawget(self, key)
    if v == nil then v = rawget(self, tonumber(key)) end
    if v == nil then return def or self end
    return v
  end
  return setmetatable(et, { __tostring = function(_) return "root" end })
end

return main
