# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## Notes
### Installing
### Push after shallow-clone
```bash
git fetch --unshallow
```
### Todos
[TODO.md](./TODO.md)

### LSP
#### clangd with different compilers

In order to re-config lspconfig, first set `vim.o.exrc = true`,
then new a `.nvim.lua` file in project root.

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
