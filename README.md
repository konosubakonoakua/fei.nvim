# A personal neovim config based on LazyVim💤

[![update lockfile](https://github.com/konosubakonoakua/fei.nvim/actions/workflows/update_lock.yml/badge.svg)](https://github.com/konosubakonoakua/fei.nvim/actions/workflows/update_lock.yml)

## Showcase
<details>
<summary><b>dashboard</b></summary>

<img src="https://github.com/konosubakonoakua/.dotfiles/blob/main/screenshots/neovim.png" atl="dashboard" width="100%" >

</details>
<details>
<summary><b>ikun logo</b></summary>

<img src="https://github.com/konosubakonoakua/.dotfiles/blob/main/screenshots/ikun.png" alt="ikun" width="100%">

</details>

<details>
<summary><b>oxocarbon light</b></summary>

<img src="https://github.com/konosubakonoakua/fei.nvim/assets/42881610/375d09fe-6297-423c-8524-d724d9d59427" alt="oxocarbon light" width="100%">

</details>

<details>
<summary><b>oxocarbon dark</b></summary>

<img src="https://github.com/konosubakonoakua/fei.nvim/assets/42881610/a9016fe3-c4ad-4436-b371-6734a8ec2551" alt="oxocarbon dark" width="100%">

</details>

## Installing

<details>
<summary><b>Install on Windows</b></summary>

The bundled installer sets up scoop + dependencies, clones this config into
`%LOCALAPPDATA%\fei.nvim` and adds an `fvim` launcher, so it can coexist with an
existing `%LOCALAPPDATA%\nvim` config:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
iwr -useb https://raw.githubusercontent.com/konosubakonoakua/fei.nvim/main/scripts/install.ps1 | iex
```

Manual alternative (clones straight into `%LOCALAPPDATA%\nvim`, **replacing** the
default config - don't mix this with the `fei.nvim` / `fvim` route above, the
config/data dirs differ):

```bat
scoop install neovim
scoop install neovide
scoop install wakatime-cli
scoop install lazygit
scoop install gh
scoop install fzf
scoop install zoxide
scoop install tree-sitter
scoop install glow
scoop install nodejs-lts
scoop install fd
scoop install zig
scoop install ripgrep

npm config set registry https://registry.npmmirror.com

pip install pynvim pywin32

$nvimDir = "$env:USERPROFILE\AppData\Local\nvim"
New-Item -ItemType Directory -Force -Path $nvimDir
Set-Location $nvimDir
git clone https://github.com/konosubakonoakua/fei.nvim.git .
git config --local user.name konosubakonoakua
git config --local user.email "ailike_meow@qq.com"

$url = "https://raw.githubusercontent.com/konosubakonoakua/.dotfiles/main/lazygit/config.yml"
$outputPath = "$env:USERPROFILE\AppData\Local\lazygit\config.yml"
Invoke-WebRequest -Uri $url -OutFile $outputPath
Write-Output "downloaded to $outputPath"

```
</details>

<details>
<summary><b>Install on Linux</b></summary>

```bash
pip install pynvim
cargo install tree-sitter-cli

if command -v curl >/dev/null 2>&1; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/konosubakonoakua/fei.nvim/main/scripts/install.sh)"
else
    bash -c "$(wget -O- https://raw.githubusercontent.com/konosubakonoakua/fei.nvim/main/scripts/install.sh)"
fi
```

Only want the Neovim config (no tools / fonts)? Use the config-only installer:

```shell
./scripts/install-config.sh
```

or just try it.

```shell
git clone https://github.com/konosubakonoakua/fei.nvim.git ~/.config/fei.nvim
tee -a ~/.bashrc << EOF
alias fvim='NVIM_APPNAME="fei.nvim" nvim' # will save plugins at ~/.local/share/fei.nvim
EOF
source ~/.bashrc
```

or use the plain-Vim config - pure vimscript, no plugins, for Vim on
resource-limited / embedded boards:

```shell
git clone https://github.com/konosubakonoakua/fei.nvim.git ~/.config/fei.nvim
ln -s ~/.config/fei.nvim/misc/vim/init.vim ~/.vimrc
# optional: also use it as your Neovim config
# ln -s ~/.config/fei.nvim/misc/vim/init.vim ~/.config/nvim/init.vim
```

</details>

## Configuration layout

```text
lua/config/keymaps/   all user keymaps, one concern per file
lua/plugins/extras/   opt-in extras, enabled via :LazyExtras (lazyvim.json)
after/ftplugin/       filetype-scoped buffer options
misc/                 plain-Vim vimrc, clangd examples, repro config
scripts/              installers (full bootstrap vs config-only)
```

See [docs/STRUCTURE.md](./docs/STRUCTURE.md) ([中文](./docs/STRUCTURE.zh.md))
for the full layout and conventions, and
[docs/USAGE.md](./docs/USAGE.md) ([中文](./docs/USAGE.zh.md)) for keymaps and
cookbooks.

## Reference
> [!TIP]
> - [STRUCTURE.md](./docs/STRUCTURE.md) ([中文](./docs/STRUCTURE.zh.md)) - layout & conventions
> - [USAGE.md](./docs/USAGE.md) ([中文](./docs/USAGE.zh.md)) - keymaps & cookbook
> - [lua-guide 中文笔记](./docs/lua-guide.zh.md)
> - [I AM VIM MAN](https://github.com/konosubakonoakua/vimer/blob/main/README.md)
> - [.dotfiles](https://github.com/konosubakonoakua/.dotfiles/blob/main/README.md)
> - [programming in lua](https://www.lua.org/manual/5.4/manual.html)
> - [neovim lua guide](https://neovim.io/doc/user/lua-guide.html)
> - [nvim-lua-guide-zh](https://github.com/glepnir/nvim-lua-guide-zh/blob/main/README.md)
> - [learnbyexample vim](https://learnbyexample.github.io/vim_reference/preface.html)
> - [vim regex](https://www.vimregex.com/)
> - [LazyVim for Ambitious Developers](https://lazyvim-ambitious-devs.phillips.codes)

