local M = {}
local term_border = "rounded"

M.cmd_concat = function(command)
  return table.concat({ "<Cmd>", command, "<CR>" })
end

M.custom_floatterm = LazyVim.terminal.open

M.custom_lazyterm = function()
  LazyVim.terminal(nil, {
    cwd = LazyVim.root(),
    ctrl_hjkl = false,
    size = { width = 0.95, height = 0.93 },
    border = term_border,
  })
end

M.custom_lazyterm_cwd = function()
  LazyVim.terminal(nil, {
    cwd = tostring(vim.fn.expand("%:p:h")),
    ctrl_hjkl = false,
    -- size = { width = 1.0, height = 1.0 },
    size = { width = 0.95, height = 0.93 },
    border = term_border,
  })
end

M.lualine_setup_recording_status = function()
  local colors = {
    bg = "#16161e",
    fg = "#ff9e64",
    red = "#ec5f67",
    blue = "#5fb3b3",
    green = "#99c794",
    text_bg = "#16161e",
    text_delay = "",
    text_play = "",
    text_rec = "",
  } local function set_highlight(group, fg, bg)
    vim.cmd(string.format("highlight %s guifg=%s guibg=%s", group, fg, bg))
  end

  set_highlight("PlayingSymbol", colors.green, colors.bg)
  set_highlight("RecordingSymbol", colors.red, colors.bg)
  set_highlight("PlayingText", colors.text_play, colors.text_bg)
  set_highlight("RecordingText", colors.text_rec, colors.text_bg)

  -- hide `recording reg` message
  vim.cmd[[set shm+=q]]

  return function()
      local reg_exe = vim.fn.reg_executing()
      local reg_rec = vim.fn.reg_recording()
      if reg_exe ~= "" then
        -- BUG: executing too fast, not displaying
        return "%#PlayingSymbol#%*%#PlayingText# " .. reg_exe .. "%*"
      elseif reg_rec ~= "" then
        return "%#RecordingSymbol#󰨜" .. "%*" .. " " .. reg_rec .. "%*"
        -- %#HLName# (:help 'statusline')
      else
        return " " .. os.date("%R")
          and "" -- don't show time
      end
    end
end


function M.version()
  local v = vim.version()
  if v and not v.prerelease then
    vim.notify(
      ("Neovim v%d.%d.%d"):format(v.major, v.minor, v.patch),
      vim.log.levels.WARN,
      { title = "Neovim: not running nightly!" }
    )
  end
end


function M.base64(data)
  data = tostring(data)
  local bit = require("bit")
  local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
  local b64, len = "", #data
  local rshift, lshift, bor = bit.rshift, bit.lshift, bit.bor

  for i = 1, len, 3 do
    local a, b, c = data:byte(i, i + 2)
    b = b or 0
    c = c or 0

    local buffer = bor(lshift(a, 16), lshift(b, 8), c)
    for j = 0, 3 do
      local index = rshift(buffer, (3 - j) * 6) % 64
      b64 = b64 .. b64chars:sub(index + 1, index + 1)
    end
  end

  local padding = (3 - len % 3) % 3
  b64 = b64:sub(1, -1 - padding) .. ("="):rep(padding)

  return b64
end

-- Insert values into a list if they don't already exist
---@param tbl string[]
---@param vals string|string[]
function M.list_insert_unique(tbl, vals)
  if type(vals) ~= "table" then
    vals = { vals }
  end
  for _, val in ipairs(vals) do
    if not vim.tbl_contains(tbl, val) then
      table.insert(tbl, val)
    end
  end
end

return M
