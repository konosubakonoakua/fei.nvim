# TODO.md

## FEATs

- lazyextras
  - telescope
    - [ ] [octo](https://github.com/pwntester/octo.nvim)
    - [x] [pathogen](https://github.com/brookhong/telescope-pathogen.nvim)
    - [x] [zoxide](https://github.com/nvim-telescope/telescope-z.nvim.git)
    - [ ] [tmux](https://github.com/camgraff/telescope-tmux.nvim)
    - [ ] [lazy](https://github.com/tsakirist/telescope-lazy.nvim)
    - [ ] [luasnip](https://github.com/benfowler/telescope-luasnip.nvim)

## TODOs

- [ ] TODO: add regex to exlude solved TODOs like '[x] TODO:'
- [ ] TODO: adjust impair behavior
- [ ] TODO: config fzf-lua keymaps
- [x] TODO: integrate neovim-remote & lazygit (edit in same process)
- [x] TODO: add `leaderf` and config gtags for huge cpp projects
- [x] TODO: find a way to index multiple folders when using gtags with leaderf
- [x] TODO: create ~/.venv for nvim python support
- [x] TODO: try lsp inlay in neovim 0.10.\* (working well for c++)
- [ ] TODO: make better completions
- [x] TODO: enable completion in command mode
- [ ] TODO: set highlights for different modes (lualine)
- [ ] TODO: change spacer for lualine
- [ ] TODO: change dashboard vertical spacing (upstream)
- [ ] TODO: adapt keymap for fzf-lua command that using cwd
- [ ] TODO: (fzf-lua) use up/down arrow for preview page up/down
- [x] TODO: (markdown) create autocommands to disable diagnosis for markdown file type
- [ ] TODO: (telescope) fullscreen

## PERFs

- [ ] PERF: replace performance critial functionalities (telescope) with fzf-lua

## FIXMEs

- [ ] FIXME: mason installed stylua cannot run in ubuntu18
- [ ] FIXME: todo-commnets highlight not working in md files
- [x] FIXME: dynamic colorscheme not working (not been reproduced)
- [ ] FIXME: <leader>e open edge will leave a random character at right bottom, <leader>ue will not
- [x] FIXME: vim illuminate encountered error when processing `-- #region` blocks (upstream fixed)
- [ ] FIXME: sometimes cursor block disapper: [nvim issue](https://github.com/neovim/neovim/issues/21018) [leaderf commit](https://github.com/Yggdroot/LeaderF/commit/998a06e48d755ab84845735a6720a0ef3a43f937)
- [x] FIXME: No Python executable found that can `import neovim`. (fixed by set python3_host_prog)
- [x] FIXME: error when saving/opening yml file: Request textDocument/foldingRange failed with message: Cannot read properties of undefined (reading 'lineFoldingOnly')(not been reproduced)
- [x] FIXME: neovim 0.10.\* breaks the `<C-/>` terminal
- [ ] FIXME: NEOTREE not syncing path with buffer on Windows platform (maybe security software issue)
- [ ] FIXME: sometimes terminal remaining, cannot close
- [ ] FIXME: colorful banner cannot close when resizing
- [ ] FIXME: telescope-file-browser.nvim slow (~2s) when initing
- [x] FIXME: cpp dap break point not working (compiling issue, need debug info `-g`)
- [ ] FIXME: closing terminal causing nvim not responding with high cpu loading sometimes
- [x] BUG: _FREEZE FOR NO REASON_ randomly (0.10)
  - seems that yanky is the root cause, disable it for now
  - seems that xclip is the troublemaker [#37](https://github.com/gbprod/yanky.nvim/issues/37)
- [ ] FIXME: todo & project not included in telescope builtins
- [ ] FIXME: `ctrl-;` is globally bounded by ibus. `gsettings list-recursively | grep -i "semi" && gsettings set org.freedesktop.ibus.panel.emoji hotkey []`
- [ ] FIXME: after opening python files in big codebase like u-boot, nvim become slaggish (maybe the pylsp)
- [ ] FIXME: nnn explorer fails to show up sometiems (ERROR: too many open files)
