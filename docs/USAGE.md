# Usage

[English](USAGE.md) | [中文](USAGE.zh.md)

Common use cases and keymaps for this config. Layout and conventions live in
[STRUCTURE.md](STRUCTURE.md).

## Keymap

### Function keys

map `<C-Fx>` is equal to map `<Fy>` where y = x + 24.
map `<S-Fx>` is equal to map `<Fy>` where y = x + 12.

### Utilities (`<leader>;`)

| key | action |
| --- | --- |
| `<leader>;;` | open the dashboard |
| `<leader>;c` / `<leader>;C` | `:lcd` / `:cd` to the current file's dir |
| `<leader>;l` / `;m` / `;I` / `;x` | Lazy / Mason / LspInfo / LazyExtras |
| `<leader>;t` / `<leader>;T` | terminal (current file dir / project root) |
| `<leader>;b` | btop in a floating terminal (if installed) |
| `<leader>;p` | copy the current file path to the `+` register |
| `<leader>;P` | add the current project to the picker list |
| `<leader>;L` | LazyVim changelog |

### Terminals & buffers

| key | action |
| --- | --- |
| `<leader>ft` / `<leader>fT` | terminal (project root / current file dir) |
| `<leader>fD` | search dotfiles |
| `<leader>b.` | delete all empty buffers |
| `<leader>c/` | insert a `:set ts/sw` snippet as a comment |
| `<C-s>` | write file |

### Window & tabs

| key | action |
| --- | --- |
| `<C-h/j/k/l>` | move to left / lower / upper / right window |
| `<C-Arrows>` | resize window |
| `<leader>ws` / `wv` / `wc` / `wo` | split below / right, close, close others |
| `<leader><tab>]` / `[` / `d` / `o` | next / previous / close / close other tabs |

## Macro

- macros play through a `noautocmd` wrapper, so autocmds don't fire while
  playing (see `config/keymaps/init.lua`).
- disable auto-pairs while recording manually - macros don't toggle it; use
  `<C-v>` where you'd otherwise fight the pairs.

## Dev

### Bisect

https://git-scm.com/book/en/v2/Git-Tools-Debugging-with-Git

### Backtraces

https://neovim.io/doc/user/dev_tools.html#dev-tools-backtrace

### Isolated repro config

`misc/troubleshooting/minimal.lua` boots lazy.nvim with its own `NVIM_APP_NAME`
and data dir - good for bisecting plugin issues.

## Lsp

### lspconfig clangd with different compilers

In order to re-config lspconfig, first set `vim.o.exrc = true`,
then new a `.nvim.lua` file in project root (see `misc/clangd/.nvim.lua`).

```bash
require("lspconfig").clangd.setup({
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--completion-style=detailed",
		"--function-arg-placeholders",
		"--fallback-style=llvm",
		"--query-driver=/usr/bin/c++",
	},
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
})
```

## Search

### POSIX Character classes

> [!Tip]
> https://www.regular-expressions.info/posixbrackets.html

The POSIX standard supports the following classes or categories of characters
(note that classes must be defined within brackets):

| **POSIX class** | **Equivalent to** | **Matches** |
| --- | --- | --- |
| `[:alnum:]` | `[A-Za-z0-9]` | digits, uppercase and lowercase letters |
| `[:alpha:]` | `[A-Za-z]` | upper- and lowercase letters |
| `[:ascii:]` | `[\x00-\x7F]` | ASCII characters |
| `[:blank:]` | `[ \t]` | space and TAB characters only |
| `[:cntrl:]` | `[\x00-\x1F\x7F]` | Control characters |
| `[:digit:]` | `[0-9]` | digits |
| `[:graph:]` | `[^[:cntrl:]]` | graphic characters (all characters which have graphic representation) |
| `[:lower:]` | `[a-z]` | lowercase letters |
| `[:print:]` | `[[:graph:]]` | graphic characters and space |
| `[:punct:]` | ``[-!"#$%&'()*+,./:;<=>?@[]^_`{\|}~]`` | all punctuation characters (all graphic characters except letters and digits) |
| `[:space:]` | `[ \t\n\r\f\v]` | all blank (whitespace) characters, including spaces, tabs, new lines, carriage returns, form feeds, and vertical tabs |
| `[:upper:]` | `[A-Z]` | uppercase letters |
| `[:word:]` | `[A-Za-z0-9_]` | word characters |
| `[:xdigit:]` | `[0-9A-Fa-f]` | hexadecimal digits |

#### Examples

* `a[[:digit:]]b` matches `a0b`, `a1b`, ..., `a9b`.
* `a[:digit:]b` is invalid, character classes must be enclosed in brackets
* `[[:digit:]abc]` matches any digit, as well as `a`, `b`, and `c`.
* `[abc[:digit:]]` is the same as the previous, matching any digit, as well as `a`, `b`, and `c`
* `[^ABZ[:lower:]]` matches any character except lowercase letters, `A`, `B`, and `Z`.

### put all matched patterns into quick-fix

#### vimgrep

```vim
:vim pattern % | copen
```

### delete all [un]matched lines

```vim
:g/pattern/d " matched
:g!/pattern/d " unmatched
```

## Git

### lazygit

- put `config.yml` to `~/AppData/Roaming/lazygit/config.yml`.

### Push after shallow-clone

```bash
git fetch --unshallow
```

## Files

### do something for all `lua` files

```shell
# remove all leading # in lua files
find -name "*.lua" -exec sh -c "echo -n {}'>>>>>>\n'; sed -i 's/#region/region/' {}; sed -i 's/#endregion/endregion/' {}" \;
```

## lazy.nvim

### manually load time-consuming plugins after startup

Use `module = false` and then `:Lazy load <plugin>` after startup.

```lua
return {
  {
    -- may take long time due to network issues
    'pwntester/octo.nvim',
    -- event = "VeryLazy", -- don't use event if use module
    module = false, -- NOTE: do not automatically load it
    init = function()
      -- will be overwritten by setup later
      vim.api.nvim_create_user_command('Octo', function()
        vim.cmd[[Lazy load octo.nvim]]
        LazyVim.info(":Lazy load octo.nvim")
      end, { desc = ":Lazy load octo.nvim" })
    end,
    cmd = { "Octo" },
    config = function() require("octo").setup({}) end,
  },
}
```

## Nvim Docs

### Preview with `nvim-bqf`

> [!TIP]
> When using <kbd>gO</kbd> to open toc, press <kbd>o</kbd> instead of <kbd>enter</kbd>
>
> https://github.com/kevinhwang91/nvim-bqf/tree/main?tab=readme-ov-file#function-table
