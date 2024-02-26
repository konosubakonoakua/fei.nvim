local M = {}

M.raw_colors = {
  bg       = '#00161616', -- oxocarbon.nvim
  fg       = '#bbc2cf',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#51afef',
  red      = '#ec5f67',
}

M.lualine_colors = {
  lualine_b_branch_inactive = "lualine_b_branch_inactive",
  lualine_b_branch_normal = "lualine_b_branch_normal",
}

M.mode_colors = {
  n = M.raw_colors.red,
  i = M.raw_colors.green,
  v = M.raw_colors.blue,
  [''] = M.raw_colors.blue,
  V = M.raw_colors.blue,
  c = M.raw_colors.magenta,
  no = M.raw_colors.red,
  s = M.raw_colors.orange,
  S = M.raw_colors.orange,
  [''] = M.raw_colors.orange,
  ic = M.raw_colors.yellow,
  R = M.raw_colors.violet,
  Rv = M.raw_colors.violet,
  cv = M.raw_colors.red,
  ce = M.raw_colors.red,
  r = M.raw_colors.cyan,
  rm = M.raw_colors.cyan,
  ['r?'] = M.raw_colors.cyan,
  ['!'] = M.raw_colors.red,
  t = M.raw_colors.red,
}

M.int2colorcode = function (int)
  return string.format("#%x", int)
end

return M
