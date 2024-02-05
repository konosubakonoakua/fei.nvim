local M = {
  'nmac427/guess-indent.nvim',
}

M.opts = function (_, opts)
  opts.auto_cmd = true  -- Set to false to disable automatic execution
  opts.override_editorconfig = false -- Set to true to override settings set by .editorconfig
  opts.filetype_exclude = {  -- A list of filetypes for which the auto command gets disabled
    "netrw",
    "tutor",
  }
  opts.buftype_exclude = {  -- A list of buffer types for which the auto command gets disabled
    "help",
    "nofile",
    "terminal",
    "prompt",
  }
  return opts
end

M.keys = {
}

return { M }
