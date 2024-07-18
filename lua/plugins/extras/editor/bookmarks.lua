return {
  {
    -- https://github.com/crusj/bookmarks.nvim
    -- "crusj/bookmarks.nvim",
    "konosubakonoakua/bookmarks.nvim",
    keys = {
      { "\\\\", function () require("telescope").extensions.bookmarks.bookmarks() end, mode = { "n" }, desc = "Telescope Bookmarks", },
    },
    branch = "main",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bookmarks").setup({
        storage_dir = "", -- Default path: vim.fn.stdpath("data").."/bookmarks,  if not the default directory, should be absolute path",
        mappings_enabled = true, -- If the value is false, only valid for global keymaps: toggle、add、delete_on_virt、show_desc
        -- TODO: reassign keymaps for bookmarks
        keymap = {
          toggle = "\\t", -- Toggle bookmarks(global keymap)
          add = "\\a", -- Add bookmarks(global keymap)
          jump = "<CR>", -- Jump from bookmarks(buf keymap)
          delete = "dd", -- Delete bookmarks(buf keymap)
          order = "<space>", -- Order bookmarks by frequency or updated_time(buf keymap)
          delete_on_virt = "\\dd", -- Delete bookmark at virt text line(global keymap)
          show_desc = "\\sd", -- show bookmark desc(global keymap)
          -- focus_tags = "", -- focus tags window
          -- focus_bookmarks = "", -- focus bookmarks window
          toogle_focus = "<tab>", -- toggle window focus (tags-window <-> bookmarks-window)
        },
        width = 0.8, -- Bookmarks window width:  (0, 1]
        height = 0.7, -- Bookmarks window height: (0, 1]
        preview_ratio = 0.45, -- Bookmarks preview window ratio (0, 1]
        tags_ratio = 0.1, -- Bookmarks tags window ratio
        fix_enable = false, -- If true, when saving the current file, if the bookmark line number of the current file changes, try to fix it.

        virt_text = "", -- Show virt text at the end of bookmarked lines, if it is empty, use the description of bookmarks instead.
        sign_icon = "󰃃", -- if it is not empty, show icon in signColumn.
        virt_pattern = { -- Show virt text only on matched pattern
          "*.c",
          "*.cpp",
          "*.go",
          "*.lua",
          "*.sh",
          "*.php",
          "*.rs"
        },
        virt_ignore_pattern = {}, -- Ignore showing virt text on matched pattern, this works after virt_pattern
        border_style = "rounded", -- border style: "single", "double", "rounded"
        -- hl = {
          -- border = "TelescopeBorder", -- border highlight
          -- cursorline = "guibg=Gray guifg=White", -- cursorline highlight
        -- },
      })
      _ = require("util.picker").has_telescope()
        and require("telescope").load_extension("bookmarks")
    end,
  },
}
