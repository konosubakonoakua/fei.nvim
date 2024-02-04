# USAGE
take down common use case here.

## Keymap
### Function keys
map `<C-Fx>` is equal to map `<Fy>` where y = x + 24.
map `<S-Fx>` is equal to map `<Fy>` where y = x + 12.
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
### POSIX Character classes
> [!Tip]
> https://www.regular-expressions.info/posixbrackets.html

The POSIX standard supports the following classes or categories of charactersh (note that classes must be defined within brackets):

| **POSIX class** | **Equivalent to** | **Matches** |
| --- | --- | --- |
| `[:alnum:]` | `[A-Za-z0-9]` | digits, uppercase and lowercase letters |
| `[:alpha:]` | `[A-Za-z]` | upper- and lowercase letters |
| `[:ascii:]` | `[\x00-\x7F]` | ASCII characters |
| `[:blank:]` | `[ \t]` | space and TAB characters only |
| `[:cntrl:]` | `[\x00-\x1F\x7F]` | Control characters |
| `[:digit:]` | `[0-9]` | digits |
| `[:graph:]` | `[^ [:cntrl:]]` | graphic characters (all characters which have graphic representation) |
| `[:lower:]` | `[a-z]` | lowercase letters |
| `[:print:]` | `[[:graph:] ]` | graphic characters and space |
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
## FILES
### do something for all `lua` files
```shell
# remove all leading # in lua files
find -name "*.lua" -exec sh -c "echo -n {}'>>>>>>\n'; sed -i 's/#region/region/' {}; sed -i 's/#endregion/endregion/' {}" \;
```
