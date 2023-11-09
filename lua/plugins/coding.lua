--[[ Summary
  -- nvim-cmp
]]

--[[ TODO: cmp kind icons
--
local kind_icons = {
  Text = "",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰇽",
  Variable = "󰂡",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰅲",
}
]]

return {

  -- extend auto completion
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
    opts = function(_, opts)
      opts.history = false
      opts.delete_check_events = "TextChanged"
    end,
  },
  {
    -- TODO: add lspkind maybe
    "hrsh7th/nvim-cmp",
    version = false,
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "emoji" } }))
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        -- TODO: find out how to use supertab
        --
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            cmp.select_next_item()
          -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
          -- this way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        -- ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        -- ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        -- ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        -- ["<C-f>"] = cmp.mapping.scroll_docs(4),
        -- ["<C-Space>"] = cmp.mapping.complete(),
        -- ["<C-e>"] = cmp.mapping.abort(),
        -- ["<CR>"] = cmp.mapping.confirm({ select = true }),
        -- ["<S-CR>"] = cmp.mapping.confirm({
        --   behavior = cmp.ConfirmBehavior.Replace,
        --   select = true,
        -- }),
      })
      opts.formatting.fields = { "kind", "abbr", "menu" }
      opts.formatting.format = function(_, item)
        -- FIXME: How to get types on the left, and offset the menu
        --
        -- local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
        -- local strings = vim.split(kind.kind, "%s", { trimempty = true })
        -- kind.kind = " " .. (strings[1] or "") .. " "
        -- kind.menu = "    (" .. (strings[2] or "") .. ")"
        local icons = require("lazyvim.config").icons.kinds
        -- item.kind = string.format('%s %s', icons[item.kind], item.kind)
        item.kind = string.format(" %s", icons[item.kind])
        return item
      end
      -- TODO: completion ghost text ON or OFF
      -- opts.experimental.ghost_text = {
      --   hl_group = "CmpGhostText",
      -- }
    end,
  },
  -- better increase/descrease
  {
    "monaqa/dial.nvim",
    version = false,
    -- stylua: ignore
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
      -- TODO: config dial.nvim keymap
      --
      -- vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
      -- vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
      -- vim.keymap.set("n", "g<C-a>", require("dial.map").inc_gnormal(), { noremap = true })
      -- vim.keymap.set("n", "g<C-x>", require("dial.map").dec_gnormal(), { noremap = true })
      -- vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
      -- vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
      -- vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual(), { noremap = true })
      -- vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual(), { noremap = true })
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          -- augend.constant.new({ elements = { "let", "const" } }),
          augend.integer.alias.decimal,
          augend.integer.alias.decimal_int,
          augend.integer.alias.hex,
          augend.integer.alias.binary,
          augend.integer.alias.octal,
          augend.date.alias["%Y/%m/%d"],
          augend.semver.alias.semver,
          augend.constant.alias.bool,
        },
      })
    end,
  },

  -- TODO: config mini.pairs
  -- auto pairs
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    -- opts = {},
    init = function()
      require("mini.pairs").setup({
        mappings = {
          -- -- Don't add closing pair if cursor is in front of closing character
          -- ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\][^%)]" },
          -- ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\][^%]]" },
          -- ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\][^%}]" },
        },
      })
    end,
  },
}
