-- configuration fast access

local str = require("warm.str")
local tbl = require("warm.table")

local main = {}

main.old_buf = nil
main.cgf_open = nil
---@param file_path string
---@return integer
---@return integer
---@return integer
function main.replace_buffer(file_path)
  local cur_buf = vim.api.nvim_get_current_buf()
  local cur_win = vim.api.nvim_get_current_win()
  -- local buf = vim.api.nvim_create_buf(true, true) -- New buffer
  local buf = vim.fn.bufadd(file_path) or 0 -- New buffer

  if buf == 0 then return cur_win, buf, cur_buf end

  vim.api.nvim_set_option_value("buflisted", false, { buf = buf }) -- Set as unlisted/hidden
  vim.api.nvim_win_set_buf(cur_win, buf) -- Atach the buffer to window
  return cur_win, buf, cur_buf
end

vim.api.nvim_create_user_command("NvstpConfig", function(opts)
  local notify_params = { title = "Nvstp Config" }
  local arg1 = opts.fargs[1]
  local function is_cfg_file(item)
    return tbl.contains({
      "mapping",
      "options",
      "globals",
      "plugins",
    }, item)
  end
  if main.cur_into ~= nil and not tbl.contains({ "--return", "--reload" }, arg1) then
    vim.api.nvim_notify(
      "A config file (" .. main.cur_into[1] .. ") is already open",
      vim.log.levels.INFO,
      notify_params
    )
    return
  end
  local nvcfg = vim.fn.stdpath("config")
  ---@cast nvcfg string
  if arg1 == "--cdir" then
    vim.fn.chdir(nvcfg)
    return
  elseif arg1 == "--help" then
    vim.api.nvim_command("help NvstpConfig")
    return
  elseif arg1 == "--reload" then
    vim.api.nvim_command("source " .. nvcfg .. "/init.lua")
    return
  elseif arg1 == "--return" then
    if main.cur_into == nil then
      vim.api.nvim_notify("No config to close", vim.log.levels.INFO, notify_params)
      return
    end
    local bufto = main.cur_into[3]
    if main.cur_into[4] == 0 then
      vim.api.nvim_notify("Config file closed successfully", vim.log.levels.INFO, notify_params)
      vim.api.nvim_buf_delete(bufto, { force = true })
      main.cur_into = nil
      return
    end
    vim.api.nvim_notify(
      "Config file closed successfully, returning to the previous buffer",
      vim.log.levels.INFO,
      notify_params
    )
    local winto = main.cur_into[2]
    vim.api.nvim_win_set_buf(winto, main.cur_into[4])
    -- Also delete the config buffer
    vim.api.nvim_buf_delete(bufto, { force = true })
    main.cur_into = nil
    return
  elseif arg1 == "--init" then
    local cfg_file = nvcfg .. "/init.lua"
    local w, b, p = main.replace_buffer(cfg_file)
    main.cur_into = { "init.lua", w, b, p }
    return
  elseif arg1 == "--loader" then
    local cfg_file = nvcfg .. "/config/init.lua"
    local w, b, p = main.replace_buffer(cfg_file)
    main.cur_into = { "config/init.lua", w, b, p }
    return
  elseif arg1 == "--custom" then
    local ov_file = "/custom/init.lua"
    if str.boolean(opts.fargs[2]) then
      if not is_cfg_file(opts.fargs[2]) then
        vim.api.nvim_notify(
          "The requested config file does not exist",
          vim.log.levels.WARN,
          notify_params
        )
        return
      end
      ov_file = "/custom/" .. opts.fargs[2] .. ".lua"
    end
    local cfg_file = nvcfg .. ov_file
    local w, b, p = main.replace_buffer(cfg_file)
    main.cur_into = { "custom/init.lua", w, b, p }
    return
  end
  -- arg1 should be a configuration file
  local file = arg1
  if main.cur_into ~= nil then
    vim.api.nvim_notify(
      "Config file '" .. main.cur_into[1] .. "' already open",
      vim.log.levels.WARN,
      notify_params
    )
    return
  end
  if not is_cfg_file(file) then
    vim.api.nvim_notify(
      "The requested config file does not exist",
      vim.log.levels.WARN,
      notify_params
    )
    return
  end
  local cfg_type = "/config/data/"
  if opts.fargs[2] == "--custom" then cfg_type = "/custom/" end
  local cfg_file = nvcfg .. cfg_type .. file .. ".lua"
  local w, b, p = main.replace_buffer(cfg_file)
  main.cur_into = { cfg_type .. file .. ".lua", w, b, p }
end, {
  desc = "Open configuration files",
  nargs = "+",
  complete = function(arglead, _, _) -- cmdline, curpos
    local cmp = {
      "mapping",
      "options",
      "globals",
      "plugins",
      "--cdir",
      "--init",
      "--help",
      "--return",
      "--loader",
      "--custom",
      "--reload",
    }
    if arglead == "" or str.starts_with(arglead, " ") then return cmp end
    cmp = tbl.filter(cmp, function(_, v) return str.starts_with(v, arglead) end, false)
    if #tbl.get_keys(cmp) == 0 then return { "--init" } end
    return cmp
  end,
})
