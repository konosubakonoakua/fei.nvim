-- region flash jump line
vim.keymap.set({ "i", "x", "n", "s" }, "<A-s>", function()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  require("flash").jump({
    search = {
      mode = "search",
      max_length = 0,
      multi_window = false,
    },
    label = { after = { 0, 0 } },
    -- label = { after = { 0, col } },
    pattern = "^",
    highlight = {
      matches = false,
    },
  })
  vim.api.nvim_input(col .. 'l')
end, { desc = "line jump" })
-- endregion flash jump line

return {
  -- https://github.com/folke/flash.nvim
  {
    "folke/flash.nvim",
    optional = true,
    event = "VeryLazy",
    vscode = true,
    ---@type Flash.Config
    opts = {
      jump = {
        -- save location in the jumplist
        jumplist = true,
        -- jump position
        pos = "start", ---@type "start" | "end" | "range"
        -- add pattern to search history
        history = false,
        -- add pattern to search register
        register = false,
        -- clear highlight after jump
        nohlsearch = false,
        -- automatically jump when there is only one match
        autojump = false,
        -- You can force inclusive/exclusive jumps by setting the
        -- `inclusive` option. By default it will be automatically
        -- set based on the mode.
        inclusive = nil, ---@type boolean?
        -- jump position offset. Not used for range jumps.
        -- 0: default
        -- 1: when pos == "end" and pos < current position
        offset = nil, ---@type number
      },
      modes = {
        -- options used when flash is activated through
        -- a regular search with `/` or `?`
        search = {
          -- when `true`, flash will be activated during regular search by default.
          -- You can always toggle when searching with `require("flash").toggle()`
          enabled = true,
          highlight = { backdrop = false },
          jump = { history = true, register = true, nohlsearch = true },
          search = {
            -- `forward` will be automatically set to the search direction
            -- `mode` is always set to `search`
            -- `incremental` is set to `true` when `incsearch` is enabled
          },
        },
        char = {
          enabled = false,
          -- dynamic configuration for ftFT motions
          config = function(opts)
            -- autohide flash when in operator-pending mode
            opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")

            -- autohide flash when using macro
            opts.autohide = not opts.autohide and not (vim.fn.reg_executing() == "" and vim.fn.reg_recording() == "")

            -- disable jump labels when not enabled, when using a count,
            -- or when recording/executing registers
            opts.jump_labels = opts.jump_labels
              and vim.v.count == 0
              and vim.fn.reg_executing() == ""
              and vim.fn.reg_recording() == ""

            -- Show jump labels only in operator-pending mode
            -- opts.jump_labels = vim.v.count == 0 and vim.fn.mode(true):find("o")
          end,
          -- hide after jump when not using jump labels
          autohide = false,
          -- show jump labels
          jump_labels = false,
          -- set to `false` to use the current line only
          multi_line = false,
          -- When using jump labels, don't use these keys
          -- This allows using those keys directly after the motion
          label = { exclude = "hjkliardc" },
          -- by default all keymaps are enabled, but you can disable some of them,
          -- by removing them from the list.
          -- If you rather use another key, you can map them
          -- to something else, e.g., { [";"] = "L", [","] = H }
          keys = { "f", "F", "t", "T", ";", "," },
          ---@alias Flash.CharActions table<string, "next" | "prev" | "right" | "left">
          -- The direction for `prev` and `next` is determined by the motion.
          -- `left` and `right` are always left and right.
          char_actions = function(motion)
            return {
              [";"] = "next", -- set to `right` to always go right
              [","] = "prev", -- set to `left` to always go left
              -- clever-f style
              [motion:lower()] = "next",
              [motion:upper()] = "prev",
              -- jump2d style: same case goes next, opposite case goes prev
              -- [motion] = "next",
              -- [motion:match("%l") and motion:upper() or motion:lower()] = "prev",
            }
          end,
          search = { wrap = false },
          highlight = { backdrop = true },
          jump = { register = false },
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = { "o" }, function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  -- {
  --   "nvim-telescope/telescope.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     local function flash(prompt_bufnr)
  --       require("flash").jump({
  --         pattern = "^",
  --         label = { after = { 0, 0 } },
  --         search = {
  --           mode = "search",
  --           exclude = {
  --             function(win)
  --               return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
  --             end,
  --           },
  --         },
  --         action = function(match)
  --           local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
  --           picker:set_selection(match.pos[1] - 1)
  --         end,
  --       })
  --     end
  --     opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
  --       mappings = {
  --         n = { s = flash },
  --         i = { ["<c-s>"] = flash },
  --       },
  --     })
  --   end,
  -- },
  -- https://github.com/gsuuon/tshjkl.nvim
  {
    "gsuuon/tshjkl.nvim",
    enabled = true,
    opts = {
      keymaps = {
        toggle = "<leader>um",
      },
      marks = {
        parent = {
          virt_text = { { "h", "ModeMsg" } },
          virt_text_pos = "overlay",
        },
        child = {
          virt_text = { { "l", "ModeMsg" } },
          virt_text_pos = "overlay",
        },
        prev = {
          virt_text = { { "k", "ModeMsg" } },
          virt_text_pos = "overlay",
        },
        next = {
          virt_text = { { "j", "ModeMsg" } },
          virt_text_pos = "overlay",
        },
      },
    },
  },
}
