return {
  -- tabout
  {
    "abecodes/tabout.nvim",
    version = false,
    opts = function(_, opts)
      opts.tabkey = "<Tab>" -- key to trigger tabout, set to an empty string to disable
      opts.backwards_tabkey = "<S-Tab>" -- key to trigger backwards tabout, set to an empty string to disable
      opts.act_as_tab = true -- shift content if tab out is not possible
      opts.act_as_shift_tab = false -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
      opts.default_tab = "<C-t>" -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
      opts.default_shift_tab = "<C-d>" -- reverse shift default action,
      opts.enable_backwards = true -- well ...
      opts.completion = true -- if the tabkey is used in a completion pum
      opts.tabouts = {
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = "`", close = "`" },
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
        { open = "|", close = "|" },
      }
      opts.ignore_beginning = true --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
      opts.exclude = {} -- tabout will ignore these filetypes
    end,
  },
}
