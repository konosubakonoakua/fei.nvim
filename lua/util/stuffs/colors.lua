local M = {}

M.raw_colors = {
  bg = "#00161616", -- oxocarbon.nvim
  fg = "#bbc2cf",
  yellow = "#ECBE7B",
  cyan = "#008080",
  darkblue = "#081633",
  green = "#98be65",
  orange = "#FF8800",
  violet = "#a9a1e1",
  magenta = "#c678dd",
  blue = "#51afef",
  red = "#ec5f67",
}

M.lualine_colors = {
  lualine_b_branch_inactive = "lualine_b_branch_inactive",
  lualine_b_branch_normal = "lualine_b_branch_normal",
}

M.mode_colors = {
  n = M.raw_colors.red,
  i = M.raw_colors.green,
  v = M.raw_colors.blue,
  [""] = M.raw_colors.blue,
  V = M.raw_colors.blue,
  c = M.raw_colors.magenta,
  no = M.raw_colors.red,
  s = M.raw_colors.orange,
  S = M.raw_colors.orange,
  [""] = M.raw_colors.orange,
  ic = M.raw_colors.yellow,
  R = M.raw_colors.violet,
  Rv = M.raw_colors.violet,
  cv = M.raw_colors.red,
  ce = M.raw_colors.red,
  r = M.raw_colors.cyan,
  rm = M.raw_colors.cyan,
  ["r?"] = M.raw_colors.cyan,
  ["!"] = M.raw_colors.red,
  t = M.raw_colors.red,
}

M.int2colorcode = function(int)
  return string.format("#%x", int)
end

-- https://scottplot.net/cookbook/4.1/colors/#category-20
M.ScottPlot_colors = {}
M.ScottPlot_colors.PastelWheel = {
  "#F8C5C7",
  "#FADEC3",
  "#FBF6C4",
  "#E1ECC8",
  "#D7E8CB",
  "#DAEBD7",
  "#D9EEF3",
  "#CADBED",
  "#C7D2E6",
  "#D4D1E5",
  "#E8D3E6",
  "#F8C7DE",
}
M.ScottPlot_colors.Penumbra = {
  "#CB7459",
  "#A38F2D",
  "#46A473",
  "#00A0BE",
  "#7E87D6",
  "#BD72A8",
}

-- https://colorpalettes.io/dark-aesthetic-color-palette/
M.DarkPalette_v1 = {
  ["black"] = "#101820",
  ["dark_blue_green"] = "#253746",
  ["seal_brown"] = "#4e4544",
  ["gray"] = "#7f7384",
  ["red_brown"] = "#73391d",
  ["dark_olive"] = "#1c4220",
}

-- http://axonflux.com/handy-rgb-to-hsl-and-rgb-to-hsv-color-model-c

--[[
 * Converts an RGB color value to HSL. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSL_color_space.
 * Assumes r, g, and b are contained in the set [0, 255] and
 * returns h, s, and l in the set [0, 1].
 *
 * @param   Number  r       The red color value
 * @param   Number  g       The green color value
 * @param   Number  b       The blue color value
 * @return  Array           The HSL representation
]]
M.rgb2hsl = function (r, g, b, a)
  r, g, b = r / 255, g / 255, b / 255

  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, l

  l = (max + min) / 2

  if max == min then
    h, s = 0, 0 -- achromatic
  else
    local d = max - min
    local s
    if l > 0.5 then s = d / (2 - max - min) else s = d / (max + min) end
    if max == r then
      h = (g - b) / d
      if g < b then h = h + 6 end
    elseif max == g then h = (b - r) / d + 2
    elseif max == b then h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h, s, l, a or 255
end

--[[
 * Converts an HSL color value to RGB. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSL_color_space.
 * Assumes h, s, and l are contained in the set [0, 1] and
 * returns r, g, and b in the set [0, 255].
 *
 * @param   Number  h       The hue
 * @param   Number  s       The saturation
 * @param   Number  l       The lightness
 * @return  Array           The RGB representation
]]
M.hsl2rgb = function(h, s, l, a)
  local r, g, b

  if s == 0 then
    r, g, b = l, l, l -- achromatic
  else
    function hue2rgb(p, q, t)
      if t < 0   then t = t + 1 end
      if t > 1   then t = t - 1 end
      if t < 1/6 then return p + (q - p) * 6 * t end
      if t < 1/2 then return q end
      if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
      return p
    end

    local q
    if l < 0.5 then q = l * (1 + s) else q = l + s - l * s end
    local p = 2 * l - q

    r = hue2rgb(p, q, h + 1/3)
    g = hue2rgb(p, q, h)
    b = hue2rgb(p, q, h - 1/3)
  end

  return r * 255, g * 255, b * 255, a * 255
end

--[[
 * Converts an RGB color value to HSV. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSV_color_space.
 * Assumes r, g, and b are contained in the set [0, 255] and
 * returns h, s, and v in the set [0, 1].
 *
 * @param   Number  r       The red color value
 * @param   Number  g       The green color value
 * @param   Number  b       The blue color value
 * @return  Array           The HSV representation
]]
M.rgb2hsv = function (r, g, b, a)
  r, g, b, a = r / 255, g / 255, b / 255, a / 255
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, v
  v = max

  local d = max - min
  if max == 0 then s = 0 else s = d / max end

  if max == min then
    h = 0 -- achromatic
  else
    if max == r then
    h = (g - b) / d
    if g < b then h = h + 6 end
    elseif max == g then h = (b - r) / d + 2
    elseif max == b then h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h, s, v, a
end

--[[
 * Converts an HSV color value to RGB. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSV_color_space.
 * Assumes h, s, and v are contained in the set [0, 1] and
 * returns r, g, and b in the set [0, 255].
 *
 * @param   Number  h       The hue
 * @param   Number  s       The saturation
 * @param   Number  v       The value
 * @return  Array           The RGB representation
]]
M.hsv2rgb = function (h, s, v, a)
  local r, g, b

  local i = math.floor(h * 6);
  local f = h * 6 - i;
  local p = v * (1 - s);
  local q = v * (1 - f * s);
  local t = v * (1 - (1 - f) * s);

  i = i % 6

  if i == 0 then r, g, b = v, t, p
  elseif i == 1 then r, g, b = q, v, p
  elseif i == 2 then r, g, b = p, v, t
  elseif i == 3 then r, g, b = p, q, v
  elseif i == 4 then r, g, b = t, p, v
  elseif i == 5 then r, g, b = v, p, q
  end

  return r * 255, g * 255, b * 255, a * 255
end

M.rgb_tweak = function(color, ratio)
  local r_decimal = tonumber(color:sub(2, 3), 16)
  local g_decimal = tonumber(color:sub(4, 5), 16)
  local b_decimal = tonumber(color:sub(6, 7), 16)

  local h, s, v = M.rgb2hsv(r_decimal, g_decimal, b_decimal, 255)
  -- local res1 = string.format("#%4f%4f%4f", h, s, v)
  -- local final_str = ""
  -- final_str = final_str .. "\n" .. string.format("rgb2hsv: %s ---> %s", color, res1)

  -- Adjust lightness
  v = v * ratio

  local r, g, b = M.hsv2rgb(h, s, v, 255)
  -- local res2 = string.format("#%02x%02x%02x", r, g, b)
  -- final_str = final_str .. "\n" .. string.format("hsv2rgb: %s ---> %s", color, res2)

  -- Convert to hexadecimal representation
  local res = string.format("#%02x%02x%02x", r, g, b)
  -- vim.notify(final_str .. "\n" .. string.format("final: %s ---> %s", color, res))

  return res
end

-- region taken from zen-mode
function M.get_hl(name)
  local ok, hl = pcall( vim.api.nvim_get_hl, 0,
    {
      name = name,
      link = false, -- false to follow link
    }
  )
  if not ok then
    return nil
  end
  for _, key in pairs({ "fg", "bg" }) do
    if hl[key] then
      hl[key] = string.format("#%06x", hl[key])
    end
  end
  return hl
end

function M.hex2rgb(hex)
  hex = hex:gsub("#", "")
  return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

function M.rgb2hex(r, g, b)
  return string.format("#%02x%02x%02x", r, g, b)
end

function M.darken(hex, amount)
  local r, g, b = M.hex2rgb(hex)
  return M.rgb2hex(r * amount, g * amount, b * amount)
end

function M.is_dark(hex)
  local r, g, b = M.hex2rgb(hex)
  local lum = (0.299 * r + 0.587 * g + 0.114 * b) / 255
  return lum <= 0.5
end
-- endregion taken from zen-mode

return M
