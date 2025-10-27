return {
  {
    'nmac427/guess-indent.nvim',
    lazy = true,
    keys = {},
    event = { "BufEnter" },
    opts = {
      auto_cmd = true,  -- Set to false to disable automatic execution
      override_editorconfig = false, -- Set to true to override settings set by .editorconfig
      filetype_exclude = {  -- A list of filetypes for which the auto command gets disabled
        "netrw",
        "tutor",
      },
      buftype_exclude = {  -- A list of buffer types for which the auto command gets disabled
        "help",
        "nofile",
        "terminal",
        "prompt",
      },
    },
  },

  {
    'nvim-mini/mini.align',
    version = false,
    enabled = true,
  },

  {
    'nvim-mini/mini.trailspace',
    version = false,
    enabled = true,
  },
}
