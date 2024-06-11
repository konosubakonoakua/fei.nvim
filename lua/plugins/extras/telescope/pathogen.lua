-- [pathogen](https://github.com/brookhong/telescope-pathogen.nvim)

return {
  "nvim-telescope/telescope.nvim",
  enabled = LazyVim.has("telescope.nvim"),
  version = false,
  dependencies = {
    { "brookhong/telescope-pathogen.nvim" },
  },
  config = function()
    require("telescope").setup({
      extensions = {
        ["pathogen"] = {
          -- remove below if you want to enable it
          use_last_search_for_live_grep = false,
        },
      },
    })
    require("telescope").load_extension("pathogen")
    vim.keymap.set("v", "<leader>pg", require("telescope").extensions["pathogen"].grep_string)
  end,
  -- stylua: ignore start
  keys = {
    { "<leader>pl", ":Telescope pathogen live_grep<CR>",   silent = true },
    { "<leader>pg", ":Telescope pathogen<CR>",             silent = true },
    { "<leader>pf", ":Telescope pathogen find_files<CR>",  silent = true },
    { "<leader>ps", ":Telescope pathogen grep_string<CR>", silent = true },
  },
  -- stylua: ignore end
}
