# 使用手册

[English](USAGE.md) | [中文](USAGE.zh.md)

本配置的常用操作与键位速查。目录布局与约定见
[STRUCTURE.zh.md](STRUCTURE.zh.md)。

## 键位

### 功能键

map `<C-Fx>` 等价于 map `<Fy>`，其中 y = x + 24。
map `<S-Fx>` 等价于 map `<Fy>`，其中 y = x + 12。

### 工具组（`<leader>;`）

| 键 | 作用 |
| --- | --- |
| `<leader>;;` | 打开 dashboard |
| `<leader>;c` / `<leader>;C` | `:lcd` / `:cd` 到当前文件目录 |
| `<leader>;l` / `;m` / `;I` / `;x` | Lazy / Mason / LspInfo / LazyExtras |
| `<leader>;t` / `<leader>;T` | 终端（当前文件目录 / 项目根目录） |
| `<leader>;b` | 浮动终端里跑 btop（需已安装） |
| `<leader>;p` | 复制当前文件路径到 `+` 寄存器 |
| `<leader>;P` | 把当前项目加入 picker 列表 |
| `<leader>;L` | LazyVim 更新日志 |

### 终端与 buffer

| 键 | 作用 |
| --- | --- |
| `<leader>ft` / `<leader>fT` | 终端（项目根目录 / 当前文件目录） |
| `<leader>fD` | 搜索 dotfiles |
| `<leader>b.` | 删除所有空 buffer |
| `<leader>c/` | 以注释形式插入 `:set ts/sw` 片段 |
| `<C-s>` | 保存文件 |

### 窗口与标签页

| 键 | 作用 |
| --- | --- |
| `<C-h/j/k/l>` | 跳到 左 / 下 / 上 / 右 窗口 |
| `<C-方向键>` | 调整窗口大小 |
| `<leader>ws` / `wv` / `wc` / `wo` | 向下分屏 / 向右分屏 / 关闭 / 只保留当前 |
| `<leader><tab>]` / `[` / `d` / `o` | 下一个 / 上一个 / 关闭 / 关闭其他标签页 |

## 宏

- 宏播放包在 `noautocmd` 里，播放期间不会触发 autocmd（见
  `config/keymaps/init.lua`）。
- 录制时不会自动关 auto-pairs，需要手动处理；不想和配对打架时用 `<C-v>`。

## 开发

### Bisect

https://git-scm.com/book/en/v2/Git-Tools-Debugging-with-Git

### Backtraces

https://neovim.io/doc/user/dev_tools.html#dev-tools-backtrace

### 隔离的复现配置

`misc/troubleshooting/minimal.lua` 用独立的 `NVIM_APP_NAME` 和 data 目录启动
lazy.nvim，适合排查插件问题。

## Lsp

### 用不同编译器配置 clangd

先设 `vim.o.exrc = true`，再在项目根目录新建 `.nvim.lua`
（参考 `misc/clangd/.nvim.lua`）。

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

## 搜索

### POSIX 字符类

> [!Tip]
> https://www.regular-expressions.info/posixbrackets.html

POSIX 支持以下字符类（注意必须写在方括号内）：

| **POSIX 类** | **等价于** | **匹配** |
| --- | --- | --- |
| `[:alnum:]` | `[A-Za-z0-9]` | 数字、大小写字母 |
| `[:alpha:]` | `[A-Za-z]` | 大小写字母 |
| `[:ascii:]` | `[\x00-\x7F]` | ASCII 字符 |
| `[:blank:]` | `[ \t]` | 仅空格和 TAB |
| `[:cntrl:]` | `[\x00-\x1F\x7F]` | 控制字符 |
| `[:digit:]` | `[0-9]` | 数字 |
| `[:graph:]` | `[^[:cntrl:]]` | 可打印字符（有图形表示的字符） |
| `[:lower:]` | `[a-z]` | 小写字母 |
| `[:print:]` | `[[:graph:]]` | 图形字符与空格 |
| `[:punct:]` | ``[-!"#$%&'()*+,./:;<=>?@[]^_`{\|}~]`` | 标点符号 |
| `[:space:]` | `[ \t\n\r\f\v]` | 所有空白字符（含空格、制表符、换行等） |
| `[:upper:]` | `[A-Z]` | 大写字母 |
| `[:word:]` | `[A-Za-z0-9_]` | 单词字符 |
| `[:xdigit:]` | `[0-9A-Fa-f]` | 十六进制数字 |

#### 示例

* `a[[:digit:]]b` 匹配 `a0b`、`a1b`、…、`a9b`。
* `a[:digit:]b` 非法，字符类必须写在方括号内
* `[[:digit:]abc]` 匹配任意数字以及 `a`、`b`、`c`。
* `[abc[:digit:]]` 同上。
* `[^ABZ[:lower:]]` 匹配除小写字母、`A`、`B`、`Z` 之外的任意字符。

### 把所有匹配行放进 quick-fix

#### vimgrep

```vim
:vim pattern % | copen
```

### 删除所有（不）匹配的行

```vim
:g/pattern/d " 匹配的
:g!/pattern/d " 不匹配的
```

## Git

### lazygit

- 把 `config.yml` 放到 `~/AppData/Roaming/lazygit/config.yml`。

### shallow clone 之后 push

```bash
git fetch --unshallow
```

## 文件

### 对所有 `lua` 文件做同样的事

```shell
# 去掉 lua 文件里的 #region 前缀
find -name "*.lua" -exec sh -c "echo -n {}'>>>>>>\n'; sed -i 's/#region/region/' {}; sed -i 's/#endregion/endregion/' {}" \;
```

## lazy.nvim

### 手动加载启动慢的插件

用 `module = false`，启动后再 `:Lazy load <plugin>`。

```lua
return {
  {
    -- 可能因为网络问题耗时较长
    'pwntester/octo.nvim',
    -- event = "VeryLazy", -- 用 module 时不要再设 event
    module = false, -- NOTE: 不要自动加载
    init = function()
      -- 之后再被 setup 覆盖
      vim.api.nvim_create_user_command('Octo', function()
        vim.cmd[[Lazy load octo.nvim]]
        LazyVim.info(":Lazy load octo.nvim")
      end, { desc = ":Lazy load octo.nvim" })
    end,
    cmd = { "Octo" },
    config = function() require("octo").setup({}) end,
  },
}
```

## Nvim 文档

### 用 `nvim-bqf` 预览

> [!TIP]
> 用 <kbd>gO</kbd> 打开目录后，按 <kbd>o</kbd> 而不是 <kbd>enter</kbd>
>
> https://github.com/kevinhwang91/nvim-bqf/tree/main?tab=readme-ov-file#function-table
