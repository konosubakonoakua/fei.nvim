# Configuration Structure

[English](STRUCTURE.md) | [中文](STRUCTURE.zh.md)

How this LazyVim-based config is laid out, and the conventions it follows.

## Layout

```text
.
├── init.lua                    # entry point: config.filetypes (early) + config.lazy
├── after/ftplugin/<ft>.lua     # filetype-scoped buffer options (e.g. ipf commentstring)
├── lua/
│   ├── config/
│   │   ├── options.lua         # auto-loaded by LazyVim before lazy.nvim starts
│   │   ├── autocmds.lua        # auto-loaded on VeryLazy; also loads usercmds
│   │   ├── filetypes.lua       # vim.filetype.add for types Neovim doesn't detect
│   │   ├── usercmds.lua        # user commands (NOT auto-loaded; required by autocmds.lua)
│   │   ├── lazy.lua            # lazy.nvim bootstrap and spec imports
│   │   └── keymaps/
│   │       ├── init.lua        # core editing maps + the silent-by-default keymap.set patch
│   │       ├── windows.lua     # window navigation / resize / management
│   │       ├── tabs.lua        # tab pages
│   │       ├── terminal.lua    # terminals & dotfile search
│   │       ├── utils.lua       # <leader>; utilities
│   │       ├── lsp.lua         # LSP workspace maps (buffer-local via LspAttach)
│   │       ├── cmdwin.lua      # command-line window maps (via CmdWinEnter)
│   │       └── gui.lua         # Neovide / GUI font & transparency maps
│   ├── plugins/                # lazy.nvim specs, imported via `import = "plugins"`
│   │   ├── *.lua               # base specs (editor / ui / coding / ...)
│   │   ├── keymaps.lua         # plugin-spec keymaps ONLY (no imperative code)
│   │   ├── lsp/init.lua        # lspconfig opts (treesitter & mason handled by LazyVim)
│   │   └── extras/<group>/     # user extras - see "Extras" below
│   ├── util/                   # helpers: term, statusline, icons, logos
│   └── platform/               # OS / CI detection and terminal setup
├── misc/                       # non-config assets - see below
└── scripts/                    # installers
```

## Conventions

### Keymaps

- `config/keymaps.lua` does not exist: LazyVim loads `config.keymaps`, which
  resolves to `config/keymaps/init.lua`. Submodules are plain side-effect
  modules required from `init.lua`.
- Buffer-local maps that need an autocmd (LspAttach, CmdWinEnter) also live in
  `config/keymaps/` (`lsp.lua`, `cmdwin.lua`) instead of `config/autocmds.lua`.
- `vim.keymap.set` is patched in `keymaps/init.lua` to default `silent = true`;
  all user maps go through it.

### Filetype-scoped settings

- Buffer-local options for a *detected* filetype go to `after/ftplugin/<ft>.lua`.
- Filetypes Neovim doesn't detect are registered in `config/filetypes.lua`,
  which is loaded early from `init.lua` (before any buffer is read).
- Rules that mix filename and extension patterns (e.g. disabling diagnostics
  for `.env` / `*.md` / `*.MD`) stay in `config/autocmds.lua`, because
  `after/ftplugin` can't express them (`*.MD` gets no filetype at all).

### Autocmds

- Augroups are prefixed `user_`, **never** `lazyvim_`: LazyVim creates its
  groups as `lazyvim_<name>` with `clear = true`, so an identically named group
  here would silently wipe LazyVim's.

### User commands

- LazyVim only auto-loads `options` / `autocmds` / `keymaps`. User commands live
  in `config/usercmds.lua`, which is required from `config/autocmds.lua`.

### Extras

- `lua/plugins/extras/**` is **not** auto-imported: lazy.nvim's `import` scans
  only one directory level (a subdirectory is only entered when it has an
  `init.lua`). Only extras listed in `lazyvim.json` are loaded, and `:LazyExtras`
  manages that list (it also walks this directory as the "User" extras source).
- A top-level `desc` in an extra is shown in `:LazyExtras`, but it only works
  for multi-spec lists and plain plugin specs: a single-entry spec list with a
  named key is misdetected by lazy's `is_list()` and errors out.
- Extras under `lua/plugins/extras/lang/` mostly add treesitter parsers, Mason
  tools and LSP servers through `opts` functions - keep that shape.

### Redundancy guard

Before overriding a LazyVim default, check whether the value is identical to
the default: `opts_extend` merges lists (it does not replace), so re-declaring
LazyVim lists (e.g. treesitter `ensure_installed`) is a no-op that only rots.

## misc/

| path | purpose |
|---|---|
| `misc/vim/init.vim` | plain-Vim (vimscript-only, no plugins) vimrc for resource-limited / embedded boards |
| `misc/clangd/` | clangd project examples (`.nvim.lua`, linux / uboot `.clangd`) |
| `misc/troubleshooting/minimal.lua` | isolated repro config (`NVIM_APP_NAME`, own data dir) |
| `misc/.lazy.lua` | template copied into a project root by `:LazyrcGenerate` |

## scripts/

| script | purpose |
|---|---|
| `scripts/install.ps1` | Windows: scoop + dependencies, clone config into `%LOCALAPPDATA%\fei.nvim`, `fvim` launcher |
| `scripts/install.sh` | Linux/macOS full bootstrap (system deps, CLI tools, fonts, Neovim, shell integration, config) |
| `scripts/install-config.sh` | config-only installer (clone / update) - what CI uses |

## CI

`.github/workflows/update_lock.yml` runs weekly, points the default config dir
at the checked-out copy, refreshes `lazy-lock.json` with `Lazy! update` and
opens a PR (no direct auto-commit).
