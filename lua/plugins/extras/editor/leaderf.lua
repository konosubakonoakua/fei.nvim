-- TODO: solving searching slowly
-- lvim.builtin.telescope.defaults.path_display = { shorten = 5 }

if not vim.fn.has("python3") then
  return {}
  --[[
      python3 -m pip install --user --upgrade pynvim
      https://github.com/Yggdroot/LeaderF/wiki/Leaderf-rg
      https://github.com/Yggdroot/LeaderF/wiki/Leaderf-gtags
  --]]
end

return {
  {
    -- "Yggdroot/LeaderF",
    "konosubakonoakua/LeaderF",
    version = false,
    branch = "fix/guicursor-invisible",
    event = "VimEnter",
    lazy = false,
    -- build = ":LeaderfInstallCExtension", -- sudo apt install python3.10-distutils python3-dev python3-pip
    -- stylua: ignore
    keys = {
      -- { "<leader>kt", "<cmd>:LeaderfTag<cr>", desc = "Find Tags", noremap = false },
      { "<F5>",       "<cmd>:Leaderf gtags --update<cr>", desc = "Update Gtags",      noremap = false, silent = false },
      { "<leader>kt", "<cmd>:Leaderf bufTag<cr>",         desc = "Find Buf Tags",     noremap = false },
      { "<leader>kT", "<cmd>:Leaderf bufTagAll<cr>",      desc = "Find All Buf Tags", noremap = false },
      { "<leader>kf", "<cmd>:Leaderf funcions<cr>",       desc = "Fincd Functions",   noremap = false },
      { "<leader>kg", "<cmd>:Leaderf gtags<cr>",          desc = "Find Gtags",        noremap = false },

      { "<leader>kd", "", desc = "Find gtags Definition", noremap = false, callback = function() vim.api.nvim_exec2(string.format("Leaderf! gtags -d %s --auto-jump", vim.fn.expand("<cword>")), {}) end, },
      { "<leader>kr", "", desc = "Find References",       noremap = false, callback = function() vim.api.nvim_exec2(string.format("Leaderf! gtags -r %s --auto-jump", vim.fn.expand("<cword>")), {}) end, },
      { "<leader>ko", "", desc = "Find Next",             noremap = false, callback = function() vim.api.nvim_exec2(string.format("Leaderf! gtags --recall %s", ""), {}) end, },
      { "<leader>kn", "", desc = "Find Prev",             noremap = false, callback = function() vim.api.nvim_exec2(string.format("Leaderf! gtags --previous %s", ""), {}) end, },
      -- { "<leader>kG", "<cmd>:Leaderf! gtags --recall <cr>", desc = "Resume Gtags window", noremap = false },


      { "<F7>",       "<cmd>:Leaderf! rg --next<cr>",     desc = "Goto Next rg result",   noremap = false, silent = true },
      { "<F8>",       "<cmd>:Leaderf! rg --prev<cr>",     desc = "Goto Next rg result",   noremap = false, silent = true },
      { "<leader>kw", "<cmd>:Leaderf! rg<cr>",            desc = "Find Words (Live rg)",  noremap = false },
      { "<leader>kR", "<cmd>:Leaderf! rg --recall <cr>",  desc = "Resume Rg window",      noremap = false },
      { "<leader>kc", "", desc = "Find current word (rg)", noremap = false, callback = function() vim.api.nvim_exec2(string.format("Leaderf! rg -s -w -F %s ", vim.fn.exepath("<cword>")), {}) end, },

      { "<leader>ks", "<cmd>:LeaderfBufTag<cr>",          desc = "Find buffer Symbol",  noremap = false },
      { "<leader>kp", "<cmd>:LeaderfFile<cr>",            desc = "Find Files",          noremap = false },
      { "<leader>kl", "<cmd>:LeaderfLine<cr>",            desc = "Find buffer Lines",   noremap = false },
      { "<leader>kb", "<cmd>:LeaderfBuffer<cr>",          desc = "Find Buffers",                        },
      { "<leader>kk", "<cmd>:LeaderfFile<cr>",            desc = "Find Files",          noremap = false },
      { "<leader>k\\", "<cmd>:LeaderfRgInteractive<cr>",  desc = "Interactive search",  noremap = false },
      -- { "<leader>kk", "<cmd>:Leaderf self<cr>", desc = "Leadrf self", noremap = false },
    },
    init = function()
      vim.g.Lf_PythonVersion = 3
      vim.g.Lf_UseVersionControlTool = false
      vim.g.Lf_ShortcutF = ""
      vim.g.Lf_ShortcutB = ""
      -- vim.g.Lf_Gtagslabel = "native-pygments"
      vim.g.Lf_GtagsGutentags = false
      vim.g.Lf_GtagsAutoGenerate = false
      vim.g.Lf_GtagsAutoUpdate = false
      -- vim.g.Lf_CacheDirectory = vim.fn.expand("~/.cache/nvim/ctags")
      -- vim.g.Lf_CacheDirectory = vim.fn.expand("~/.LfCache/gtags")
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
      vim.g.Lf_RootMarkers = { ".root_marker" }
      vim.g.Lf_StlSeparator = { left = "", right = "" }
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
