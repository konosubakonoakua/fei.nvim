local M = {}
local term_border = "rounded"
local LazyVim = require("lazyvim.util")

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
      end
    end
end

return M
