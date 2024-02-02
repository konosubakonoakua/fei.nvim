# USAGE
take down common use case here.

## Edit
## Macro

## Terminal
## CWD
## LSP
### lspconfig clangd with different compilers

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
## Window
## Navi
## Search
## GIT
### lazygit
- put `config.yml` to `~/AppData/Roaming/lazygit/config.yml`.
### Push after shallow-clone
```bash
git fetch --unshallow
```
## Grep
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
## FILES
### do something for all `lua` files
```shell
# remove all leading # in lua files
find -name "*.lua" -exec sh -c "echo -n {}'>>>>>>\n'; sed -i 's/#region/region/' {}; sed -i 's/#endregion/endregion/' {}" \;
```
