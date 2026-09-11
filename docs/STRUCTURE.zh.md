# 配置结构说明

[English](STRUCTURE.md) | [中文](STRUCTURE.zh.md)

这份 LazyVim 配置的目录布局与约定。

## 布局

```text
.
├── init.lua                    # 入口：先加载 config.filetypes，再加载 config.lazy
├── after/ftplugin/<ft>.lua     # 按 filetype 生效的 buffer 选项（如 ipf 的 commentstring）
├── lua/
│   ├── config/
│   │   ├── options.lua         # LazyVim 在 lazy.nvim 启动前自动加载
│   │   ├── autocmds.lua        # VeryLazy 时自动加载；同时负责加载 usercmds
│   │   ├── filetypes.lua       # 用 vim.filetype.add 补充 Neovim 没有的 filetype 侦测
│   │   ├── usercmds.lua        # 用户命令（不会被自动加载，由 autocmds.lua require）
│   │   ├── lazy.lua            # lazy.nvim 引导与 spec 导入
│   │   └── keymaps/
│   │       ├── init.lua        # 核心编辑映射 + 默认 silent 的 keymap.set 补丁
│   │       ├── windows.lua     # 窗口跳转 / 调整大小 / 管理
│   │       ├── tabs.lua        # 标签页
│   │       ├── terminal.lua    # 终端与 dotfile 搜索
│   │       ├── utils.lua       # <leader>; 工具组
│   │       ├── lsp.lua         # LSP workspace 映射（经 LspAttach 设为 buffer-local）
│   │       ├── cmdwin.lua      # 命令行窗口映射（经 CmdWinEnter）
│   │       └── gui.lua         # Neovide / GUI 字体与透明度映射
│   ├── plugins/                # lazy.nvim spec，经 `import = "plugins"` 导入
│   │   ├── *.lua               # 基础 spec（editor / ui / coding 等）
│   │   ├── keymaps.lua         # 只放插件按键映射（不放命令式代码）
│   │   ├── lsp/init.lua        # lspconfig 选项（treesitter / mason 交给 LazyVim）
│   │   └── extras/<group>/     # 自定义 extras，见下文 "Extras"
│   ├── util/                   # 工具函数：term、statusline、icons、logos
│   └── platform/               # 系统 / CI 判定与终端设置
├── misc/                       # 非配置资产，见下文
└── scripts/                    # 安装脚本
```

## 约定

### 键位

- `config/keymaps.lua` 不存在：LazyVim 加载 `config.keymaps`，对应
  `config/keymaps/init.lua`；各子模块是无副作用的普通模块，由 `init.lua` require。
- 需要 autocmd 才能挂载的 buffer-local 键位（LspAttach、CmdWinEnter）也放在
  `config/keymaps/`（`lsp.lua`、`cmdwin.lua`），而不是 `config/autocmds.lua`。
- `keymaps/init.lua` 里给 `vim.keymap.set` 打了补丁：默认 `silent = true`，
  所有用户键位都走它。

### 按 filetype 生效的设置

- 能被侦测出 filetype 的 buffer 局部选项放 `after/ftplugin/<ft>.lua`。
- Neovim 侦测不出来的 filetype 在 `config/filetypes.lua` 里注册；它在
  `init.lua` 里最先加载（早于任何 buffer 读取）。
- 混用文件名与扩展名 pattern 的规则（如对 `.env` / `*.md` 关闭诊断）留在
  `config/autocmds.lua`——`after/ftplugin` 表达不了（`*.MD` 根本没有 filetype）。

### Autocmds

- augroup 前缀用 `user_`，**不要**用 `lazyvim_`：LazyVim 用 `clear = true`
  创建 `lazyvim_<name>` 组，同名会静默清掉 LazyVim 的组。

### 用户命令

- LazyVim 只自动加载 `options` / `autocmds` / `keymaps`。用户命令放在
  `config/usercmds.lua`，由 `config/autocmds.lua` require 进来。

### Extras

- `lua/plugins/extras/**` **不会**被自动导入：lazy.nvim 的 `import` 只扫一层
  目录（子目录只有在含 `init.lua` 时才会进入）。只有写在 `lazyvim.json`
  `extras` 数组里的才会加载；`:LazyExtras` 负责管理这个列表（它也会遍历该
  目录作为 "User" extras 来源）。
- extra 顶层的 `desc` 会显示在 `:LazyExtras` 里，但只对多条目 spec 列表和
  单插件 spec 有效：单条目列表混入命名键会被 lazy 的 `is_list()` 误判而报错。
- `lang/` 下的 extras 基本都是通过 `opts` 函数追加 treesitter parser、Mason
  工具和 LSP server，保持这个形状。

### 冗余防线

覆盖 LazyVim 默认值之前先确认值确实不同：`opts_extend` 对列表是**合并**而
不是替换，重复声明 LazyVim 的列表（如 treesitter 的 `ensure_installed`）
是只会腐烂的无效代码。

## misc/

| 路径 | 用途 |
|---|---|
| `misc/vim/init.vim` | 纯 Vim（纯 vimscript、无插件）的 vimrc，用于资源有限的嵌入式板卡 |
| `misc/clangd/` | clangd 项目示例（`.nvim.lua`、linux / uboot 的 `.clangd`） |
| `misc/troubleshooting/minimal.lua` | 隔离的复现配置（`NVIM_APP_NAME`，独立 data 目录） |
| `misc/.lazy.lua` | `:LazyrcGenerate` 复制到项目根目录的模板 |

## scripts/

| 脚本 | 用途 |
|---|---|
| `scripts/install.ps1` | Windows：scoop + 依赖，clone 配置到 `%LOCALAPPDATA%\fei.nvim`，并创建 `fvim` 启动器 |
| `scripts/install.sh` | Linux/macOS 全量引导（系统依赖、CLI 工具、字体、Neovim、shell 集成、配置） |
| `scripts/install-config.sh` | 只装配置（clone / 更新）——CI 用的就是这个 |

## CI

`.github/workflows/update_lock.yml` 每周运行一次：把默认配置目录指向
checkout 出来的副本，用 `Lazy! update` 刷新 `lazy-lock.json`，然后开一个 PR
（不再直接自动 commit）。
