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

- [ ] TODO: (editor) add regex to exlude solved TODOs like `[x] TODO:`
- [x] TODO: (coding) adjust impair behavior
  - use `<C-v>"` or disable by `<leader>up`
- [x] TODO: (lazygit) integrate neovim-remote & lazygit (edit in same process)
- [x] TODO: (tags)(leaderf) add `leaderf` and config gtags for huge cpp projects
- [x] TODO: (tags)(leaderf) find a way to index multiple folders when using gtags with leaderf
- [x] TODO: (python) create `~/.venv` for nvim python support
- [x] TODO: (lsp) try lsp inlay in `neovim 0.10.*` (working well for c++)
- [x] TODO: (completion) make better completions
- [x] TODO: (completion) enable in command mode
- [ ] TODO: (lualine) set highlights for different modes
- [ ] TODO: (lualine) change spacer
- [ ] TODO: (dashboard) change vertical spacing (upstream)
- [x] TODO: (fzf-lua) config fzf-lua keymaps
- [ ] TODO: (fzf-lua) adapt keymap for fzf-lua file & grep command that using cwd
- [ ] TODO: (fzf-lua) use up/down arrow for preview page up/down
- [x] TODO: (fzf-lua) need a plugin like telescope-file-browser
- [x] TODO: (markdown) create autocommands to disable diagnosis for markdown file type
- [x] TODO: (telescope) fullscreen
- [x] TODO: (cmpletion) add tab functionalities to tab out surroundings (`tabout.nvim`)
- [ ] TODO: (editor) integrate tmux or zellij with neovim
- [x] TODO: (macros) when using macros, some plugins should keep closed (autopair,smartF/T)

## PERFs

- [ ] PERF: (telescopte)(fzf-lua) replace performance critial functionalities (telescope) with fzf-lua

## FIXMEs

- [ ] FIXME: (mason) installed stylua cannot run in ubuntu18
- [ ] FIXME: (highlight) todo-commnets highlight not working in md files
- [x] FIXME: (theme) dynamic colorscheme not working (not been reproduced)
- [x] FIXME: (neo-tree) <leader>e open edge will leave a random character at right bottom, <leader>ue will not
  - closed as `edge` is disabled
- [x] FIXME: (editor) vim illuminate encountered error when processing `-- #region` blocks (upstream fixed)
- [ ] FIXME: (leaderf) sometimes cursor block disapper: [nvim issue](https://github.com/neovim/neovim/issues/21018) [leaderf commit](https://github.com/Yggdroot/LeaderF/commit/998a06e48d755ab84845735a6720a0ef3a43f937)
  - wont be fixed
- [x] FIXME: (python) No Python executable found that can `import neovim`. (fixed by set python3_host_prog)
- [x] FIXME: (folding) error when saving/opening yml file: Request textDocument/foldingRange failed with message: Cannot read properties of undefined (reading 'lineFoldingOnly')(not been reproduced)
- [x] FIXME: (terminal) neovim 0.10.\* breaks the `<C-/>` terminal
- [ ] FIXME: (neo-tree) not syncing path with buffer on Windows platform (maybe security software issue)
- [ ] FIXME: (termianl) sometimes terminal remaining, cannot close
  - if open terminal at dashboard on startup, there's a high chance to reproduce the issue
  - and it is safer to use `<C-/>` to toggle instead of quitting.
- [ ] FIXME: (logo) colorful banner cannot close when resizing
- [ ] FIXME: (telescope) telescope-file-browser.nvim slow (~2s) when initing
- [x] FIXME: (dap) cpp dap break point not working (compiling issue, need debug info `-g`)
- [x] FIXME: (terminal) closing terminal causing nvim not responding with high cpu loading sometimes
  - cannot reproduce
- [x] FIXME: (editor) _FREEZE FOR NO REASON_ randomly (0.10)
  - seems that yanky is the root cause, disable it for now
  - seems that xclip is the troublemaker [#37](https://github.com/gbprod/yanky.nvim/issues/37)
  - **USE** `xsel` **INSTEAD**.
- [ ] FIXME: (telescope) todo & project not included in telescope builtins
- [x] FIXME: (keymap) `ctrl-;` is globally bounded by ibus. `gsettings list-recursively | grep -i "semi" && gsettings set org.freedesktop.ibus.panel.emoji hotkey []`
  - there's no support in terminal for `ctrl-;`
- [ ] FIXME: (python) after opening python files in big codebase like u-boot, nvim become slaggish (maybe the pylsp)
- [x] FIXME: (nnn) nnn explorer fails to show up sometiems (ERROR: too many open files)
  - currently solution: `ulimit -n `
- [x] FIXME: (project) if opened a file not in a `root pattern` folder, then open a lua file something that in `root pattern`, neo-tree cannot follow the former.
  - this is caused by `lspconfig rootspec`.
- [x] FIXME: (motion) disable char motions (fFtT) when searching or during MACRO playing and recording.
- [x] FIXME: (coding) disable char pairs when during MACRO playing and recording.
  - using `<C-v>` to enter special chars like `"'({`
  - using `<leader>up` manually for now.
  - don't know how to call functions before playing macros
  - https://github.com/neovim/neovim/pull/24565
