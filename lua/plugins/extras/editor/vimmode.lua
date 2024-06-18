return {
  {
    "konosubakonoakua/modicator.nvim",
    enabled = true,
    opts = {
      show_warnings = false,
      cursor_line_nr_background = true,
      highlights = {
        defaults = {
          bold = true,
          italic = false,
        }
      },
      integration = {
        lualine = {
          enabled = true,
          -- Letter of lualine section to use (if `nil`, gets detected automatically)
          mode_section = nil,
          -- Whether to use lualine's mode highlight's foreground or background
          highlight = 'bg',
        },
      },
    },
  },
  {
    "mvllow/modes.nvim",
    enabled = false,
    opts = {
      line_opacity = 0.15,
      set_cursor = true,
      set_cursorline = true,
      set_number = false,
      ignore_filetypes = {
        'NvimTree',
        'TelescopePrompt',
      }
    },

    config = function (_, opts)
      vim.api.nvim_set_hl(0, "ModesCopy", { default = true, link = "lualine_a_normal" })
      vim.api.nvim_set_hl(0, "ModesDelete", { default = true, link = "lualine_a_replace" })
      vim.api.nvim_set_hl(0, "ModesInsert", { default = true, link = "lualine_a_insert" })
      vim.api.nvim_set_hl(0, "ModesVisual", { default = true, link = "lualine_a_visual" })
      require("modes").setup(opts)
    end,
  }
}
