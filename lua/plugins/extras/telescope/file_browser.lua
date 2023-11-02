-- https://github.com/nvim-telescope/telescope-file-browser.nvim
return {
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  init = function()
    local fb_actions = require("telescope._extensions.file_browser.actions")
    require("telescope").setup({
      extensions = {
        file_browser = {
          cwd_to_path = true,
          grouped = true,
          files = true,
          add_dirs = true,
          depth = 1,
          auto_depth = false,
          select_buffer = false,
          hidden = { file_browser = false, folder_browser = false },
          hide_parent_dir = false,
          collapse_dirs = false,
          prompt_path = true,
          quiet = false,
          dir_icon = "📁",
          dir_icon_hl = "Default",
          display_stat = { date = true, size = true, mode = true },
          hijack_netrw = false,
          use_fd = true,
          git_status = false,
          mappings = {
            ["i"] = {
              ["<A-c>"] = fb_actions.create,
              ["<S-CR>"] = fb_actions.create_from_prompt,
              ["<A-r>"] = fb_actions.rename,
              ["<A-m>"] = fb_actions.move,
              ["<A-y>"] = fb_actions.copy,
              ["<A-d>"] = fb_actions.remove,
              ["<C-o>"] = fb_actions.open,
              ["<C-g>"] = fb_actions.goto_parent_dir,
              ["<C-e>"] = fb_actions.goto_home_dir,
              ["<C-w>"] = fb_actions.goto_cwd,
              ["<C-t>"] = fb_actions.change_cwd,
              ["<C-f>"] = fb_actions.toggle_browser,
              ["<C-h>"] = fb_actions.toggle_hidden,
              ["<C-s>"] = fb_actions.toggle_all,
              ["<bs>"] = fb_actions.backspace,
            },
            ["n"] = {
              ["c"] = fb_actions.create,
              ["r"] = fb_actions.rename,
              ["m"] = fb_actions.move,
              ["y"] = fb_actions.copy,
              ["d"] = fb_actions.remove,
              ["o"] = fb_actions.open,
              ["g"] = fb_actions.goto_parent_dir,
              ["e"] = fb_actions.goto_home_dir,
              ["w"] = fb_actions.goto_cwd,
              ["t"] = fb_actions.change_cwd,
              ["f"] = fb_actions.toggle_browser,
              ["h"] = fb_actions.toggle_hidden,
              ["s"] = fb_actions.toggle_all,
            },
          },
        },
      },
    })
    require("telescope").load_extension("file_browser")

  -- stylua: ignore start
  local keymap_force = vim.keymap.set
  keymap_force("n", "<leader>tf", ":Telescope file_browser<CR>", { desc = "Telescope file_browser", noremap = true })
  keymap_force("n", "<leader>tc", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", { desc = "Telescope cwd file_browser", noremap = true })
    -- stylua: ignore end
  end,
}
