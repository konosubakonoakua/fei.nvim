# 💤 LazyVim

[![update lockfile](https://github.com/konosubakonoakua/lazyvim.conf/actions/workflows/update_lock.yml/badge.svg)](https://github.com/konosubakonoakua/lazyvim.conf/actions/workflows/update_lock.yml)

> [!TIP]
> 
> A personal [LazyVim](https://github.com/LazyVim/LazyVim) config.
> 
> - [TODO.md](./docs/TODO.md)
> - [USAGE.md](./docs/USAGE.md)
> - [I AM VIM MAN](https://github.com/konosubakonoakua/vimer/blob/main/README.md)
> - [DOTFILES](https://github.com/konosubakonoakua/.dotfiles/blob/main/README.md)
> - [Programming in lua](https://www.lua.org/manual/5.4/manual.html)
> - [neovim lua guide](https://neovim.io/doc/user/lua-guide.html)

## Installing

<details>
<summary><b>Install on Windows</b></summary>

```bat
scoop install neovim :: or just download from github releases, need to set sys path for nvim.exe
pip install pynvim pywin32 # pywin32 for windows platform
mkdir %userprofile%\AppData\Local\nvim
cd %userprofile%\AppData\Local\nvim
git clone https://github.com/konosubakonoakua/lazyvim.conf.git .
```
</details>

<details>
<summary><b>Install on Linux</b></summary>

```bash
pip install pynvim
if command -v curl >/dev/null 2>&1; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/konosubakonoakua/lazyvim.conf/main/scripts/install.sh)"
else
    bash -c "$(wget -O- https://raw.githubusercontent.com/konosubakonoakua/lazyvim.conf/main/scripts/install.sh)"
fi
```
</details>
