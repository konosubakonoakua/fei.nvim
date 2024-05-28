return {
  -- tabout
  {
    "abecodes/tabout.nvim",
    enabled = false,
    version = false,
    opts = function(_, opts)
      opts.tabkey = "" -- key to trigger tabout, set to an empty string to disable
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
  {
    "kawre/neotab.nvim",
    event = "InsertEnter",
    opts = {
      tabkey = "<tab>",
      act_as_tab = true,
      behavior = "nested", ---@type ntab.behavior
      pairs = { ---@type ntab.pair[]
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = "`", close = "`" },
        { open = "<", close = ">" },
      },
      exclude = {},
      smart_punctuators = {
        enabled = false,
        semicolon = {
          enabled = false,
          ft = { "cs", "c", "cpp", "java" },
        },
        escape = {
          enabled = false,
          triggers = {}, ---@type table<string, ntab.trigger>
        },
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    optional = true,
    keys = {
      {
        "<Tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<Plug>(neotab-out)"
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local luasnip = require("luasnip")
      local neotab = require("neotab")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          -- -- tweak tab behaviour, only use it for snip
          if cmp.visible() then
            -- cmp.confirm({ select = true }) -- vscode style
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
          -- elseif luasnip.jumpable(1) then
          --   luasnip.jump(1)
          else
            neotab.tabout()
            -- fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
          else
            neotab.tabout()
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
}
