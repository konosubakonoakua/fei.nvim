return {
  {
    "rasulomaroff/reactive.nvim",
    enabled = true,
    keys = {
      {
        "<leader>uM",
        function()
          vim.cmd("ReactiveToggle")
          vim.notify("ReactiveToggle", vim.log.levels.WARN)
        end,
        desc = "Toggle Reactive Cursorlines",
      },
    },
    event = "VeryLazy",
    config = function()
      rgb_tweak = require("util.colors").rgb_tweak
      rgb_tweak_ratio = 0.25

      local get_hl_cursorline_normal_bg = function()
        local hl_cursorline_normal = vim.api.nvim_get_hl(0, { name = "CursorLine" })
        vim.notify(vim.inspect(vim.api.nvim_get_hl(0, { name = "CursorLine" })))
        return string.format("#%x", hl_cursorline_normal.bg or 0)-- or "#262626"
      end

      local modes_n_line_bg   = function()
        -- vim.notify(get_hl_cursorline_normal_bg())
        return rgb_tweak(get_hl_cursorline_normal_bg(), 1.0) end
      -- local modes_n_linenr_bg = function() return rgb_tweak(get_hl_cursorline_normal_bg(), 1.0) end
      -- local modes_n_linenr_fg = function() return get_hl_cursorline_normal_bg() end

      local modes_i_line_bg   = rgb_tweak("#42be65", rgb_tweak_ratio)
      local modes_i_linenr_bg = rgb_tweak("#42be65", rgb_tweak_ratio)
      local modes_i_linenr_fg = "#42be65"

      local modes_v_line_bg   = rgb_tweak("#be95ff", rgb_tweak_ratio)
      local modes_v_linenr_bg = rgb_tweak("#be95ff", rgb_tweak_ratio)
      local modes_v_linenr_fg = "#be95ff"

      local modes_R_line_bg   = rgb_tweak("#eaca89", rgb_tweak_ratio)
      local modes_R_linenr_bg = rgb_tweak("#eaca89", rgb_tweak_ratio)
      local modes_R_linenr_fg = "#eaca89"

      require("reactive").add_preset({
        name = "my-preset",
        skip = function()
          -- vim.notify(vim.inspect(hl_cursorline_normal_bg))
          local buftype = vim.api.nvim_buf_get_option(0, "buftype")
          return buftype ~= "" -- skip non-normal buffers
        end,
        -- static = {
        --   winhl = {
        --     inactive = {
        --       CursorLine = { bg = rgb_tweak(hl_cursorline_normal_bg, rgb_tweak_ratio*0.5) },
        --       CursorLineNr = { bg = rgb_tweak(hl_cursorline_normal_bg, rgb_tweak_ratio*0.5)  },
        --     },
        --   },
        -- },
        modes = {
          -- NOTE: cannot set bg dynamiclly
          -- use autocmd instead
          -- n = {
          --   winhl = {
          --     CursorLine = { bg = modes_n_line_bg() },
          --     CursorLineNr = { bg = modes_n_linenr_bg() },
          --   },
          -- },
          i = {
            winhl = {
              CursorLine = { bg = modes_i_line_bg },
              CursorLineNr = { fg = modes_i_linenr_fg, bg = modes_i_linenr_bg },
            },
          },
          -- visual
          [{ "v", "V", "\x16" }] = {
            winhl = {
              Visual = { bg = modes_v_line_bg },
              CursorLineNr = { fg = modes_v_linenr_fg, bg = modes_v_linenr_bg },
            },
          },
          -- replace
          R = {
            winhl = {
              CursorLine = { bg = modes_R_line_bg },
              CursorLineNr = { fg = modes_R_linenr_fg, bg = modes_R_linenr_bg },
            },
          },
        },
      })
    end,
  },
}
