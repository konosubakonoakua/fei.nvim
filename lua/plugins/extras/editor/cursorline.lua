-- TODO: make cursorline as plugin
local api = vim.api
local rgb_tweak = require("util.colors").rgb_tweak
local tweak_ratio = 0.38
local tweak_ratio_insert = 0.38 * 0.6

vim.cmd([[
au WinLeave * setlocal cursorlineopt=number
au WinEnter * setlocal cursorlineopt=both
]])

local M = {}

local options = {
  show_warnings = true, -- Show warning if any required option is missing
  highlights = {
    defaults = {
      bold = false,
      italic = false,
    },
  },
}

--- Gets the highlight `group`.
--- @param hl_name string
--- @return table<string, any>
function M.get_highlight(hl_name)
  return api.nvim_get_hl(0, { name = hl_name, link = false })
end

local function fallback_hl_from_mode(mode)
  local hls = {
    Normal = 'BufferLineBackground',
    Insert = 'Debug',
    Visual = '@constant',
    Select = 'Keyword',
    Replace = 'Keyword',
    Command = 'Constant',
    Terminal = 'Question',
    TerminalNormal = 'CursorLineNr',
  }
  return hls[mode] or hls.normal
end

-- Link any missing mode highlight to its fallback highlight
function M.set_fallback_highlight_groups()
  local modes = {
    'Normal',
    'Insert',
    'Visual',
    'Command',
    'Replace',
    'Select',
    'Terminal',
    'TerminalNormal',
  }

  for _, mode in pairs(modes) do
    local hl_name = mode .. 'Mode'
    if vim.tbl_isempty(M.get_highlight(hl_name)) then
      local fallback_hl = fallback_hl_from_mode(mode)

      -- if mode == 'Normal' or mode == 'TerminalNormal' then
      --   -- We can't directly link the `(Terminal)NormalMode` highlight to
      --   -- `CursorLineNr` since it will mutate, so we copy it instead
      --   local cursor_line_nr = M.get_highlight('CursorLineNr')
      --   api.nvim_set_hl(0, hl_name, cursor_line_nr)
      -- else
        api.nvim_set_hl(0, hl_name, { link = fallback_hl })
      -- end
    end
  end
end

--- Get mode name from mode.
---@param mode string
---@return string
local function mode_name_from_mode(mode)
  local mode_names = {
    ['n']  = 'Normal',
    ['i']  = 'Insert',
    ['v']  = 'Visual',
    ['V']  = 'Visual',
    ['']  = 'Visual',
    ['s']  = 'Select',
    ['S']  = 'Select',
    ['R']  = 'Replace',
    ['c']  = 'Command',
    ['t']  = 'Terminal',
    ['nt'] = 'TerminalNormal',
  }
  return mode_names[mode] or 'Normal'
end

--- Set the foreground and background color of 'CursorLineNr'. Accepts any
--- highlight definition map that `vim.api.nvim_set_hl()` does.
--- @param hl_name string
function M.set_cursor_line_highlight(hl_name)
  local hl_group = M.get_highlight(hl_name)
  local hl = vim.tbl_extend('force', options.highlights.defaults, hl_group)
  -- hl.bg = hl.fg
  local _tweak_ratio = tweak_ratio
  if hl_name == "InsertMode" then
    _tweak_ratio = tweak_ratio_insert
  end

  hl.bg = (hl.fg and rgb_tweak(string.format("#%x", hl.fg), _tweak_ratio)) -- or "#000000"
  hl_new = {}
  hl_new.bg = hl.bg
  hl_new.bold = true
  hl_new.cterm = {
    bold = true
  }
  if hl_name == "VisualMode" then
    api.nvim_set_hl(0, 'Visual', hl_new)
  end
  api.nvim_set_hl(0, 'CursorLineNr', hl_new)
  hl_new.cterm.bold = false
  hl_new.bold = false
  api.nvim_set_hl(0, 'CursorLine', hl_new)
end

function M.cb_cursorline_hl()
  local mode = api.nvim_get_mode().mode
  local mode_name = mode_name_from_mode(mode)
  M.set_cursor_line_highlight(mode_name .. 'Mode')
end

function M.create_autocmds()
  local augroup = api.nvim_create_augroup('Modicator', {})
  api.nvim_create_autocmd('ModeChanged', {
    callback = M.cb_cursorline_hl,
    group = augroup,
  })
  api.nvim_create_autocmd('Colorscheme', {
    callback = M.set_fallback_highlight_groups,
    group = augroup,
  })
end

-- api.nvim_set_hl(0, 'CursorLineNr', { link = 'NormalMode' })
M.set_fallback_highlight_groups()
M.cb_cursorline_hl()
M.create_autocmds()

return {}
