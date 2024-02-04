local _util       = require("lazyvim.util")
local keymap      = vim.keymap.set
local _floatterm  = _util.terminal.open

-- Glow Keymap
-- TODO: disable ctrl_hjkl & fix quit by q
if vim.fn.executable("glow") == 1 then
  keymap("n", "<leader>;G",
    function () _floatterm( { "glow" }, { cwd = tostring(vim.fn.expand("%:p:h")), ctrl_hjkl = false }) end,
    { desc = "!Glow" }
  )
  keymap("n", "<leader>;g", "<cmd>Glow<cr>", { desc = "Preview Markdown" })
end

-- markdown preview
return {
  {
    "ellisonleao/glow.nvim",
    version = false,
    config = true,
    cmd = "Glow",
    keys = {},
    init = function()
      require("glow").setup({
        -- glow_path = "", -- will be filled automatically with your glow bin in $PATH, if any
        -- install_path = "~/.local/bin", -- default path for installing glow binary
        border = "shadow", -- floating window border config
        -- pager = true,
        style = "dark", -- filled automatically with your current editor background, you can override using glow json style
        width = 999,
        height = 999,
        height_ratio = 1,
        width_ratio = 1, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
      })
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    optional = true,
    enabled = false, -- preview in browser, I don't need it.
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = {"markdown"},
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<leader>cp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.cmd([[do FileType]])
    end,
  },
  {
    -- preview in buffers
    "lukas-reineke/headlines.nvim",
    optional = true,
    enabled = false,
    opts = function()
      -- local filetypes = { "markdown", "norg", "rmd", "org" }
      local filetypes = { "norg", "org" }
      local opts = {}
      for _, ft in ipairs(filetypes) do
        opts[ft] = {
          headline_highlights = {},
        }
        for i = 1, 6 do
          local hl = "Headline" .. i
          vim.api.nvim_set_hl(0, hl, { link = "Headline", default = true })
          table.insert(opts[ft].headline_highlights, hl)
        end
      end
      return opts
    end,
    ft = filetypes,
    config = function(_, opts)
      -- PERF: schedule to prevent headlines slowing down opening a file
      vim.schedule(function()
        require("headlines").setup(opts)
        require("headlines").refresh()
      end)
    end,
  },
  {
    '0x00-ketsu/markdown-preview.nvim',
    name = "mdpreview",
    enabled = false,
    ft = {'md', 'markdown', 'mkd', 'mkdn', 'mdwn', 'mdown', 'mdtxt', 'mdtext', 'rmd', 'wiki'},
    keys = {
      { "<leader>uM", "<cmd>MPToggle<cr>", desc = "Toggle Markdown Preview", },
    },
    config = function()
      require('markdown-preview').setup {
        term = {
          -- reload term when rendered markdown file changed
          reload = {
            enable = true,
            events = {'InsertLeave', 'TextChanged'},
          },
          direction = 'vertical', -- choices: vertical / horizontal
          keys = {
            close = {'q', '<Esc>'},
            refresh = 'r',
          }
        }
      }
    end
  },
  {
    'mrjones2014/mdpreview.nvim',
    enabled = false, -- preview is a mess
    lazy = true,
    ft = {'md', 'markdown', 'mkd', 'mkdn', 'mdwn', 'mdown', 'mdtxt', 'mdtext', 'rmd', 'wiki'},
    -- requires the `terminal` filetype to render ASCII color and format codes
    dependencies = { 'norcalli/nvim-terminal.lua', config = true },
    keys = {
      { "<leader>uM", "<cmd>Mdpreivew<cr>", desc = "Markdown Preview", },
    },
  },
}
