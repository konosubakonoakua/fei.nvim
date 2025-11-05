return {
  {
    "mawkler/modicator.nvim",
    enabled = true,
    lazy = true,
    event = {"VimEnter", "InsertEnter"},
    opts = {
      show_warnings = false,
      highlights = {
        defaults = {
          bold = true,
          italic = false,
        },
        use_cursorline_background = true,
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
}
