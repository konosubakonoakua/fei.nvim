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

```bat
scoop install neovim @REM or just download from github releases, need to set sys path for nvim.exe

pip install pynvim pywin32 @REM pywin32 for windows platform

mkdir %userprofile%\AppData\Local\nvim
cd %userprofile%\AppData\Local\nvim
git clone https://github.com/konosubakonoakua/fei.nvim.git .
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
</details>

## Reference
> [!TIP]
> - [TODO.md](./docs/TODO.md)
> - [USAGE.md](./docs/USAGE.md)
> - [I AM VIM MAN](https://github.com/konosubakonoakua/vimer/blob/main/README.md)
> - [.dotfiles](https://github.com/konosubakonoakua/.dotfiles/blob/main/README.md)
> - [programming in lua](https://www.lua.org/manual/5.4/manual.html)
> - [neovim lua guide](https://neovim.io/doc/user/lua-guide.html)
> - [nvim-lua-guide-zh](https://github.com/glepnir/nvim-lua-guide-zh/blob/main/README.md)
> - [learnbyexample vim](https://learnbyexample.github.io/vim_reference/preface.html)
> - [vim regex](https://www.vimregex.com/)
> - [LazyVim for Ambitious Developers](https://lazyvim-ambitious-devs.phillips.codes)

