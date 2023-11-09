-- FIXME: nnn explorer mode not working
-- FIXME: nnn crash (too many open files) randomly

local cfg = {
  explorer = {
    cmd = "nnn", -- command override (-F1 flag is implied, -a flag is invalid!)
    width = 24, -- width of the vertical split
    side = "topleft", -- or "botright", location of the explorer window
    session = "", -- or "global" / "local" / "shared"
    tabs = true, -- separate nnn instance per tab
    fullscreen = true, -- whether to fullscreen explorer window when current tab is empty
  },
  picker = {
    cmd = "tmux new-session nnn -Pp", -- command override (-p flag is implied)
    style = {
      width = 0.9, -- percentage relative to terminal size when < 1, absolute otherwise
      height = 0.8, -- ^
      xoffset = 0.5, -- ^
      yoffset = 0.5, -- ^
      border = "rounded", -- border decoration for example "rounded"(:h nvim_open_win)
    },
    session = "shared", -- or "global" / "local" / "shared"
    tabs = true, -- separate nnn instance per tab
    fullscreen = true, -- whether to fullscreen picker window when current tab is empty
  },
  auto_open = {
    setup = nil, -- or "explorer" / "picker", auto open on setup function
    tabpage = nil, -- or "explorer" / "picker", auto open when opening new tabpage
    empty = false, -- only auto open on empty buffer
    ft_ignore = { -- dont auto open for these filetypes
      "gitcommit",
    },
  },
  auto_close = false, -- close tabpage/nvim when nnn is last window
  replace_netrw = nil, -- or "explorer" / "picker"
  mappings = {}, -- table containing mappings, see below
  windownav = { -- window movement mappings to navigate out of nnn
    left = "<C-w>h",
    right = "<C-w>l",
    next = "<C-w>w",
    prev = "<C-w>W",
  },
  buflisted = false, -- whether or not nnn buffers show up in the bufferlist
  quitcd = nil, -- or "cd" / tcd" / "lcd", command to run on quitcd file if found
  offset = false, -- whether or not to write position offset to tmpfile(for use in preview-tui)
}

return {
  "luukvbaal/nnn.nvim",
  version = false,
  config = function()
    require("nnn").setup(cfg)
    vim.api.nvim_set_hl(0, "NnnBorder", { bg = "NONE" })
    -- stylua: ignore
    vim.keymap.set("n", "<leader><leader>n", ":NnnPicker<cr>", { desc = "NnnPicker", noremap = true })
  end,
}
