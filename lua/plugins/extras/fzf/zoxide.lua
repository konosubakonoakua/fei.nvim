return {
  "calebfroese/fzf-lua-zoxide",
  -- "konosubakonoakua/fzf-lua-zoxide",
  enabled = not LazyVim.has("telescope.nvim"),
  dependencies = { "ibhagwan/fzf-lua" },
  config = function()
    require("fzf-lua-zoxide").setup()
  end,
  keys = {
    {
      "<leader>sz",
      function()
        require("fzf-lua-zoxide").open({
          preview = jit.os == "Linux" and "ls -la {}" or "dir {}",
          callback = function(selected)
            vim.cmd("e " .. selected)
          end,
        })
      end,
    },
  },
}
