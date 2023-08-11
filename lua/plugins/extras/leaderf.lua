-- -- do not enable for now
if true then
  return {}
end

-- local keymap = require("util").keymap

-- TODO: solving searching slowly
-- lvim.builtin.telescope.defaults.path_display = { shorten = 5 }

return {
  {
    "Yggdroot/LeaderF",
    event = "VimEnter",
    -- stylua: ignore
    keys = {
        { "<F5>", "<cmd>:Leaderf gtags --update<cr>", desc = "Update Gtags", noremap = false, silent = false, },
        -- { "<F7>", "<cmd>:Leaderf! rg --next<cr>", desc = "Goto Next rg result", noremap = false, silent = true, },
        -- { "<F8>", "<cmd>:Leaderf! rg --prev<cr>", desc = "Goto Next rg result", noremap = false, silent = true, },
        { "<leader>kd", "", desc = "Find gtags Definition", noremap = false, callback = function() vim.api.nvim_exec(string.format("Leaderf! gtags -d %s --auto-jump", vim.fn.expand('<cword>')), true) end, },
        -- { "<leader>kp", "<cmd>:LeaderfFile<cr>", desc = "Find Files", noremap = false, },
        { "<leader>kt", "<cmd>:LeaderfTag<cr>", desc = "Find Tags", noremap = false, },
        { "<leader>kg", "<cmd>:Leaderf gtags<cr>", desc = "Find Gtags", noremap = false, },
        { "<leader>kr", "", desc = "Find References", noremap = false, callback = function() vim.api.nvim_exec(string.format("Leaderf! gtags -r %s --auto-jump", vim.fn.expand('<cword>')), true) end, },
        { "<leader>kG", "<cmd>:Leaderf! gtags --recall <cr>", desc = "Resume Gtags window", noremap = false, },
        -- { "<leader>ks", "<cmd>:LeaderfBufTag<cr>", desc = "Find buffer Symbol", noremap = false, },
        -- { "<leader>kl", "<cmd>:LeaderfLine<cr>", desc = "Find buffer Lines", noremap = false, },
        -- { "<leader>kw", "<cmd>:Leaderf! rg<cr>", desc = "Find Words (Live rg)", noremap = false, },
        -- { "<leader>kc", "", desc = "Find current word (rg)", noremap = false, callback = function() vim.api.nvim_exec(string.format("Leaderf! rg -s -w -F %s ", vim.fn.exepath('<cword>')), true) end, },
        -- { "<leader>kR", "<cmd>:Leaderf! rg --recall <cr>", desc = "Resume Rg window", noremap = false, },
        -- { "<leader>k\\", "<cmd>:LeaderfRgInteractive<cr>", desc = "Interactive search", noremap = false, },
        -- { "<leader>kb", "<cmd>:LeaderfBuffer<cr>", desc = "Find Buffers" },
    },
    init = function()
      -- vim.g.Lf_Gtagslabel = "native-pygments"
      vim.g.Lf_GtagsGutentags = false
      vim.g.Lf_GtagsAutoGenerate = true
      vim.g.Lf_GtagsAutoUpdate = true

      -- vim.g.Lf_ShortcutF = "<leader>p" -- to avoid <leader>f open LeaderfFile picker
      -- vim.g.Lf_ShortcutB = "<leader>fb" -- to avoid <leader>b open LeaderBuffer picker

      -- vim.g.Lf_PopupColorscheme = "onedark"
      -- vim.g.Lf_StlColorscheme = 'onedark'
      vim.g.Lf_WindowPosition = "popup"
      vim.g.Lf_WindowHeight = 0.4
      vim.g.Lf_PopupHeight = 0.4
      vim.g.Lf_PopupWidth = 0.8
      vim.g.Lf_PopupPosition = { 1, 0 }
      vim.g.Lf_PopupPreviewPosition = "bottom"
      vim.g.Lf_DefaultMode = "NameOnly"
      vim.g.Lf_PreviewInPopup = 1
      vim.g.Lf_ShowDevIcons = 1
      vim.g.Lf_JumpToExistingWindow = 0
      vim.g.Lf_StlSeparator = { left = "", right = "" }
      -- stylua: ignore
      vim.g.Lf_NormalMap = {
          _        = {{"<C-j>", "j"}, {"<C-k>", "k"}},
          Rg       = {{"<ESC>", ':exec g:Lf_py "rgExplManager.quit()"<CR>'}},
          Mru      = {{"<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<CR>'}},
          Tag      = {{"<ESC>", ':exec g:Lf_py "tagExplManager.quit()"<CR>'}},
          Help     = {{"<ESC>", ':exec g:Lf_py "helpExplManager.quit()"<CR>'}},
          Self     = {{"<ESC>", ':exec g:Lf_py "selfExplManager.quit()"<CR>'}},
          Line     = {{"<ESC>", ':exec g:Lf_py "lineExplManager.quit()"<CR>'}},
          Files    = {{"<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>'}},
          Gtags    = {{"<ESC>", ':exec g:Lf_py "gtagsExplManager.quit()"<CR>'}},
          BufTag   = {{"<ESC>", ':exec g:Lf_py "bufTagExplManager.quit()"<CR>'}},
          Buffer   = {{"<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<CR>'}},
          Function = {{"<ESC>", ':exec g:Lf_py "functionExplManager.quit()"<CR>'}},
          History  = {{"<ESC>", ':exec g:Lf_py "historyExplManager.quit()"<CR>'}},
          Colorscheme = {{"<ESC>", ':exec g:Lf_py "colorschemeExplManager.quit()"<CR>'}},
      }
      vim.g.Lf_PreviewResult = {
        File = 0,
        Buffer = 0,
        Mru = 1,
        Tag = 0,
        BufTag = 1,
        Function = 0,
        Line = 1,
        Colorscheme = 1,
        Rg = 0,
        Gtags = 0,
      }
      vim.g.Lf_CtagsFuncOpts = {
        -- python = "--langmap=Python:.py.pyw",
        c = "--excmd=number --fields=+nS",
      }
    end,
  },
}
