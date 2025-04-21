local str = require("src.warm.str")
local tbl = require("src.warm.table")

local main = {
  props = {}, -- stores window and buffer info
  ns = vim.api.nvim_create_namespace("nvstp-palette"),
}

local function resize_float(display, new_height)
  local cfg = vim.api.nvim_win_get_config(display.win)
  if cfg.height == new_height then return end

  new_height = math.min(display.height, new_height)

  -- Shift row if height is changing, to keep bottom anchored
  cfg.row = display.row + display.height - new_height
  if new_height == display.height then cfg.row = display.row end
  cfg.height = new_height

  vim.api.nvim_win_set_config(display.win, cfg)
end

local function keymap_len_backward(s)
  local len = #s
  if len == 0 then return 1 end

  -- if last char is not ">", return 1
  if s:sub(len, len) ~= ">" then return 1 end

  -- if last char is ">", search backwards for "<"
  for i = len, 1, -1 do
    if s:sub(i, i) == "<" then
      return len - i + 1 -- include the "<"
    end
  end

  return 1 -- fallback if no "<" is found
end

local function delete_from_cursor_back(len)
  local row, col = table.unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()

  local start_col = math.max(0, col - len)
  local new_line = line:sub(1, start_col) .. line:sub(col + 1)

  vim.api.nvim_set_current_line(new_line)
  vim.api.nvim_win_set_cursor(0, { row, start_col })
end

local function make_results(mapps, pref)
  local lines = {}
  local res = {}
  local fmt = "{: =<11} ➜ {: =<" .. main.props.width - 14 .. "}"
  for n, v in pairs(mapps) do
    if str.starts_with(n, pref) then
      lines[#lines + 1] = str.format(fmt, n:sub(#pref + 1), v.desc)
      res[#res + 1] = n
    end
  end
  return lines, res
end

function main.get_mapps()
  local bmaps = vim.api.nvim_buf_get_keymap(0, "n")
  local gmaps = vim.api.nvim_get_keymap("n")

  local res = {}
  for _, v in ipairs(gmaps) do
    if not str.starts_with(v.lhs, "<Plug>") then
      local lhs = string.gsub(v.lhs, " ", "<Space>")
      res[lhs] = v
    end
  end
  for _, v in ipairs(bmaps) do
    if not str.starts_with(v.lhs, "<Plug>") then
      local lhs = string.gsub(v.lhs, " ", "<Space>")
      res[lhs] = v
    end
  end
  return res
end

function main.whichkey()
  local mapps = main.get_mapps()
  if tbl.is_empty(mapps) then return end
  local em_fmt = "{}/" .. #tbl.get_keys(mapps)

  main.open()

  local function on_select_keymap(mapp, state)
    local s = {
      win = vim.api.nvim_get_current_win(),
      buf = vim.api.nvim_get_current_buf(),
      mod = vim.api.nvim_get_mode().mode:lower():sub(1, 1),
    }
    if state.win ~= s.win or state.buf ~= s.buf or state.mod ~= s.mod then return end

    local count = vim.api.nvim_get_vvar("count1")
    if type(mapp.callback) == "function" then
      for _ = 1, count, 1 do
        mapp.callback()
      end
    else
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(tostring(count) .. mapp.rhs, true, false, true),
        mapps.noremap == 0 and "n" or "m",
        false
      )
    end
  end

  -- local line = ""
  local em_id = vim.api.nvim_buf_set_extmark(main.props.input.buf, main.ns, 0, 0, {
    virt_text = { { "", "String" } },
    virt_text_pos = "right_align",
    hl_mode = "combine",
  })

  local match_hl = nil
  local function handle_updates()
    local line = vim.api.nvim_buf_get_lines(main.props.input.buf, 0, 1, false)[1]
    local lines, res = make_results(mapps, str.strip(line))
    if #lines == 1 then
      local state = main.props.state
      main.close()
      vim.schedule(function() on_select_keymap(mapps[res[1]], state) end)
      return true
    end

    vim.api.nvim_win_call(main.props.display.win, function()
      if match_hl ~= nil then vim.fn.matchdelete(match_hl) end
      vim.api.nvim_set_hl(0, "NvstpPalleteMatch", { fg = "#fd95f5" })
      match_hl = vim.fn.matchadd("NvstpPalleteMatch", "^.")
    end)

    if #lines > 0 then resize_float(main.props.display, #lines) end

    vim.api.nvim_set_option_value("modifiable", true, { buf = main.props.display.buf })
    vim.api.nvim_buf_set_lines(main.props.display.buf, 0, -1, true, lines)
    vim.api.nvim_set_option_value("modifiable", false, { buf = main.props.display.buf })

    vim.api.nvim_buf_set_extmark(main.props.input.buf, main.ns, 0, 0, {
      virt_text = { { str.format(em_fmt, #lines), "String" } },
      virt_text_pos = "right_align",
      hl_mode = "combine",
      id = em_id,
    })
    return false
  end
  local placeholder = "<Space>"
  vim.api.nvim_buf_set_lines(main.props.input.buf, 0, -1, true, { placeholder })
  vim.api.nvim_win_set_cursor(main.props.input.win, { 1, #placeholder })

  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    buffer = main.props.input.buf,
    callback = handle_updates,
  })

  local hi = "NvstpPalleteTags"
  vim.api.nvim_win_call(main.props.display.win, function()
    vim.api.nvim_set_hl(0, hi, { fg = "#fdc5c5" })
    vim.fn.matchadd(hi, "\\[[^\\]]*\\]")
  end)

  local function on_key_handler(key, typed)
    local key_repr = vim.fn.keytrans(typed)

    if
      key_repr == "<BS>"
      or key_repr == "<Left>"
      or key_repr == "<Right>"
      or key_repr == "<C-Left>"
      or key_repr == "<C-Right>"
      or key_repr == "<lt>"
      or key_repr == "<gt>"
      or key_repr == "<Home>"
      or key_repr == "<kHome>"
      or key_repr == "<End>"
      or key_repr == "<kEnd>"
    then
      return
    end

    if key_repr == "<Esc>" or key_repr == "<CR>" then
      main.close()
      return
    elseif key_repr == "<C-Esc>" then
      vim.api.nvim_buf_set_lines(main.props.input.buf, 0, -1, false, {})
    elseif key_repr == "<C-BS>" then
      local _, col = table.unpack(vim.api.nvim_win_get_cursor(0))
      local line = vim.api.nvim_get_current_line()
      local tail_len = math.max(keymap_len_backward(line:sub(1, col)), 1)
      delete_from_cursor_back(tail_len - 1)
    elseif key ~= key_repr then -- means it is not getting inserted
      local row, col = table.unpack(vim.api.nvim_win_get_cursor(main.props.input.win))
      local line = vim.api.nvim_buf_get_lines(main.props.input.buf, row - 1, row, false)[1]

      local new_line = line:sub(1, col) .. key_repr .. line:sub(col + 1)
      vim.api.nvim_buf_set_lines(main.props.input.buf, row - 1, row, false, { new_line })
      vim.api.nvim_win_set_cursor(main.props.input.win, { row, col + #key_repr })

      vim.schedule(function() delete_from_cursor_back(#typed) end)
    end
  end
  vim.on_key(on_key_handler, main.ns, {})
end

-- Open display + input window
function main.open()
  local ui = vim.api.nvim_list_uis()[1]
  if not ui then return end

  local state = {
    win = vim.api.nvim_get_current_win(),
    buf = vim.api.nvim_get_current_buf(),
    mod = vim.api.nvim_get_mode().mode:lower():sub(1, 1),
  }

  local display_height = math.floor(ui.height / 2) - 5
  local width = math.floor(ui.width / 4)
  local input_height = 1
  local total_height = display_height + input_height

  local row = ui.height - total_height - 5
  local col = 0

  -- === Display Window ===
  local display_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value("modifiable", false, { buf = display_buf })

  local display_win = vim.api.nvim_open_win(display_buf, false, {
    relative = "editor",
    title = " Select ",
    title_pos = "center",
    width = width,
    height = display_height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  -- === Input Window ===
  local input_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value("buflisted", false, { buf = input_buf })
  vim.api.nvim_set_option_value("swapfile", false, { buf = input_buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = input_buf })
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = input_buf })

  vim.bo[input_buf].omnifunc = ""
  vim.bo[input_buf].completefunc = ""
  vim.bo[input_buf].tagfunc = ""
  vim.bo[input_buf].formatexpr = ""

  do
    local ok, cmp = pcall(require, "cmp.config")
    if ok then cmp.set_buffer({ enabled = false }, input_buf) end
  end

  vim.api.nvim_buf_call(input_buf, function() vim.api.nvim_command("map <buffer>") end)
  vim.api.nvim_command("startinsert")

  local input_win = vim.api.nvim_open_win(input_buf, true, {
    relative = "editor",
    width = width,
    height = input_height,
    row = row + display_height + 5,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  main.props = {
    display = {
      buf = display_buf,
      win = display_win,
      height = display_height,
      row = row,
    },
    input = {
      buf = input_buf,
      win = input_win,
      height = input_height,
      row = row + display_height + 5,
    },
    state = state,
    width = width,
    col = col,
    open = true,
  }
end

-- Close both windows
function main.close()
  vim.api.nvim_win_close(main.props.input.win, true)
  vim.api.nvim_win_close(main.props.display.win, true)
  vim.api.nvim_command("stopinsert")
  vim.on_key(nil, main.ns, {})
  main.props = {}
end

return main
