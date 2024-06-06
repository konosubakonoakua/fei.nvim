# Tips for `lazy.nvim` & `LazyVim`

## lazy.nvim
- https://github.com/folke/lazy.nvim#-plugin-spec

<details>
<summary><b>manually load time-consuming plugins after stratup</b></summary>

Use `module=false` and then `:Lazy load <plugin>` after startup.

```lua
return {
  {
    -- may take long time due to network issues
    'pwntester/octo.nvim',
    -- event = "VeryLazy", -- don't use event if use module
    module = false, -- NOTE: do not automatically load it
    init = function ()
      -- will be overwritten by setup later
      vim.api.nvim_create_user_command('Octo', function ()
        vim.cmd[[Lazy load octo.nvim]]
        Lazyvim.info(":Lazy load octo.nvim")
      end, {desc = ":Lazy load octo.nvim"})
    end,
    cmd = {"Octo"}, config = function() require("octo").setup({ }) end,
  },
}
```

</details>

## LazyVim

