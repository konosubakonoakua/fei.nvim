-- lualine component that shows the macro register being recorded / played.
local M = {}

function M.recording_status()
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
  }

  local function set_highlight(group, fg, bg)
    vim.cmd(string.format("highlight %s guifg=%s guibg=%s", group, fg, bg))
  end

  set_highlight("PlayingSymbol", colors.green, colors.bg)
  set_highlight("RecordingSymbol", colors.red, colors.bg)
  set_highlight("PlayingText", colors.text_play, colors.text_bg)
  set_highlight("RecordingText", colors.text_rec, colors.text_bg)

  -- hide `recording reg` message
  vim.cmd([[set shm+=q]])

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
      return " " .. os.date("%R") and "" -- don't show time
    end
  end
end

return M
