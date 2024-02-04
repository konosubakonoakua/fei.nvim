-- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes
-- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Visual-Customizations
--
-- Network
-- https://github.com/miversen33/netman.nvim#neo-tree
--
-- How to get the current path of a neo-tree buffer
-- https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/319
--
--

local Util = require("lazyvim.util")
local icons = require("util.icons").todo
local events = require("neo-tree.events")

-- region neo-tree event_handlers
local neotree_event_handlers = {

  -- https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/667
  -- force neo-tree buffer to stay in normal mode
  {
    event = events.NEO_TREE_BUFFER_ENTER,
    handler = function()
      vim.cmd("stopinsert")
    end,
  },

}
-- endregion neo-tree event_handlers

-- region emulating Vim's fold commands
local renderer = require "neo-tree.ui.renderer"

-- Expand a node and load filesystem info if needed.
local function open_dir(state, dir_node)
  local fs = require "neo-tree.sources.filesystem"
  fs.toggle_directory(state, dir_node, nil, true, false)
end

-- Expand a node and all its children, optionally stopping at max_depth.
local function recursive_open(state, node, max_depth)
  local max_depth_reached = 1
  local stack = { node }
  while next(stack) ~= nil do
    node = table.remove(stack)
    if node.type == "directory" and not node:is_expanded() then
      open_dir(state, node)
    end

    local depth = node:get_depth()
    max_depth_reached = math.max(depth, max_depth_reached)

    if not max_depth or depth < max_depth - 1 then
      local children = state.tree:get_nodes(node:get_id())
      for _, v in ipairs(children) do
        table.insert(stack, v)
      end
    end
  end

  return max_depth_reached
end

--- Open the fold under the cursor, recursing if count is given.
local function neotree_zo(state, open_all)
  local node = state.tree:get_node()

  if open_all then
    recursive_open(state, node)
  else
    recursive_open(state, node, node:get_depth() + vim.v.count1)
  end

  renderer.redraw(state)
end

--- Recursively open the current folder and all folders it contains.
local function neotree_zO(state)
  neotree_zo(state, true)
end

-- The nodes inside the root folder are depth 2.
local MIN_DEPTH = 2

--- Close the node and its parents, optionally stopping at max_depth.
local function recursive_close(state, node, max_depth)
  if max_depth == nil or max_depth <= MIN_DEPTH then
    max_depth = MIN_DEPTH
  end

  local last = node
  while node and node:get_depth() >= max_depth do
    if node:has_children() and node:is_expanded() then
      node:collapse()
    end
    last = node
    node = state.tree:get_node(node:get_parent_id())
  end

  return last
end

--- Close a folder, or a number of folders equal to count.
local function neotree_zc(state, close_all)
  local node = state.tree:get_node()
  if not node then
    return
  end

  local max_depth
  if not close_all then
    max_depth = node:get_depth() - vim.v.count1
    if node:has_children() and node:is_expanded() then
      max_depth = max_depth + 1
    end
  end

  local last = recursive_close(state, node, max_depth)
  renderer.redraw(state)
  renderer.focus_node(state, last:get_id())
end

-- Close all containing folders back to the top level.
local function neotree_zC(state)
  neotree_zc(state, true)
end

--- Open a closed folder or close an open one, with an optional count.
local function neotree_za(state, toggle_all)
  local node = state.tree:get_node()
  if not node then
    return
  end

  if node.type == "directory" and not node:is_expanded() then
    neotree_zo(state, toggle_all)
  else
    neotree_zc(state, toggle_all)
  end
end

--- Recursively close an open folder or recursively open a closed folder.
local function neotree_zA(state)
  neotree_za(state, true)
end

--- Set depthlevel, analagous to foldlevel, for the neo-tree file tree.
local function set_depthlevel(state, depthlevel)
  if depthlevel < MIN_DEPTH then
    depthlevel = MIN_DEPTH
  end

  local stack = state.tree:get_nodes()
  while next(stack) ~= nil do
    local node = table.remove(stack)

    if node.type == "directory" then
      local should_be_open = depthlevel == nil or node:get_depth() < depthlevel
      if should_be_open and not node:is_expanded() then
        open_dir(state, node)
      elseif not should_be_open and node:is_expanded() then
        node:collapse()
      end
    end

    local children = state.tree:get_nodes(node:get_id())
    for _, v in ipairs(children) do
      table.insert(stack, v)
    end
  end

  vim.b.neotree_depthlevel = depthlevel
end

--- Refresh the tree UI after a change of depthlevel.
-- @bool stay Keep the current node revealed and selected
local function redraw_after_depthlevel_change(state, stay)
  local node = state.tree:get_node()

  if stay then
    require("neo-tree.ui.renderer").expand_to_node(state.tree, node)
  else
    -- Find the closest parent that is still visible.
    local parent = state.tree:get_node(node:get_parent_id())
    while not parent:is_expanded() and parent:get_depth() > 1 do
      node = parent
      parent = state.tree:get_node(node:get_parent_id())
    end
  end

  renderer.redraw(state)
  renderer.focus_node(state, node:get_id())
end

--- Update all open/closed folders by depthlevel, then reveal current node.
local function neotree_zx(state)
  set_depthlevel(state, vim.b.neotree_depthlevel or MIN_DEPTH)
  redraw_after_depthlevel_change(state, true)
end

--- Update all open/closed folders by depthlevel.
local function neotree_zX(state)
  set_depthlevel(state, vim.b.neotree_depthlevel or MIN_DEPTH)
  redraw_after_depthlevel_change(state, false)
end

-- Collapse more folders: decrease depthlevel by 1 or count.
local function neotree_zm(state)
  local depthlevel = vim.b.neotree_depthlevel or MIN_DEPTH
  set_depthlevel(state, depthlevel - vim.v.count1)
  redraw_after_depthlevel_change(state, false)
end

-- Collapse all folders. Set depthlevel to MIN_DEPTH.
local function neotree_zM(state)
  set_depthlevel(state, MIN_DEPTH)
  redraw_after_depthlevel_change(state, false)
end

-- Expand more folders: increase depthlevel by 1 or count.
local function neotree_zr(state)
  local depthlevel = vim.b.neotree_depthlevel or MIN_DEPTH
  set_depthlevel(state, depthlevel + vim.v.count1)
  redraw_after_depthlevel_change(state, false)
end

-- Expand all folders. Set depthlevel to the deepest node level.
local function neotree_zR(state)
  local top_level_nodes = state.tree:get_nodes()

  local max_depth = 1
  for _, node in ipairs(top_level_nodes) do
    max_depth = math.max(max_depth, recursive_open(state, node))
  end

  vim.b.neotree_depthlevel = max_depth
  redraw_after_depthlevel_change(state, false)
end
-- endregion emulating Vim's fold commands

-- region execute bash on selected
-- https://www.reddit.com/r/neovim/comments/13pixc0/how_to_get_whole_path_in_neotree_if_not_in_root/
local neotree_execute_bash = function (state)
  -- state.path # this points to the root dir of the tree
  local node = state.tree:get_node() -- node in focus when keybind is pressed
  local abs_path = node.path
  local rel_path = vim.fn.fnamemodify(abs_path, ":~:.")
  local file_name = node.name
  local is_file = node.type == "file" -- or `node.type` could be a "directory"
  local file_ext = node.ext
  local file_type = vim.filetype.match({ filename = abs_path })
  vim.print(node)
end
-- endregion execute bash on selected

-- region Navigation with hjkl
-- https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/163
local neotree_navi_h = function(state)
  local node = state.tree:get_node()
  -- goto parent folder when reach the current root
  if node:get_parent_id() == nil then
    require'neo-tree.sources.filesystem.commands'.navigate_up(state)
  end
  if node.type == 'directory' and node:is_expanded() then
    require'neo-tree.sources.filesystem'.toggle_directory(state, node)
  else
    require'neo-tree.ui.renderer'.focus_node(state, node:get_parent_id())
  end
end

local neotree_navi_l = function(state)
  local node = state.tree:get_node()
  if node.type == 'directory' then
    if not node:is_expanded() then
      require'neo-tree.sources.filesystem'.toggle_directory(state, node)
    elseif node:has_children() then
      require'neo-tree.ui.renderer'.focus_node(state, node:get_child_ids()[1])
    end
  end
end
-- endregion Navigation with hjkl

-- region open file without losing focus
local neotree_openfile_nojump = function (state)
  local node = state.tree:get_node()
  if require("neo-tree.utils").is_expandable(node) then
    state.commands["toggle_node"](state)
  else
    state.commands['open'](state)
    vim.cmd('Neotree reveal')
  end
end
-- endregion open file without losing focus

-- region fix file following issue
local open_tree = function (args)
  local manager = require("neo-tree.sources.manager")
  local reveal_file = manager.get_path_to_reveal()

  if args.dir and jit.os == "Windows" then
    -- Hack to work around a bug in neo-tree where it changes path too late for reveal
    state = manager.get_state(args.source, nil, nil)
    manager.navigate(state, args.dir, reveal_file, nil, false)
  end

  require("neo-tree.command").execute({
    dir = args.dir,
    -- source = args.source,
    reveal_file = reveal_file,
    reveal_force_cwd = true,
    toggle = true,
  })
end

local neotree_reveal = function (use_cwd)
  local bufnr = vim.fn.bufnr('%')
  local abs_file_path = vim.api.nvim_buf_get_name(bufnr)
  abs_file_path = Util.is_win() and abs_file_path:gsub("/", "\\") or abs_file_path
  local abs_dir_path = vim.fn.fnamemodify(abs_file_path, ":p:h")
  abs_dir_path = Util.is_win() and abs_dir_path:gsub("/", "\\") or abs_dir_path
  local smart_path = nil
  if use_cwd then
    smart_path = vim.loop.cwd()
  else
    smart_path = Util.root({
      { "lsp" },
      { ".git", "lua", ".root" },
      { "cwd" },
    })
  end

  -- vim.notify(
  --   "\n" ..
  --   "abs_file:" .. tostring(abs_file_path) .. "\n" ..
  --   "abs_dir:" .. tostring(abs_dir_path) .. "\n" ..
  --   "smart:" .. tostring(smart_path) .. "\n" ..
  --   "\n"
  -- )

  -- local loc = string.find(abs_dir_path, smart_path)
  local loc = abs_dir_path and abs_dir_path:find(smart_path, 1, true) == 1
  if not loc then
    smart_path = abs_dir_path
    -- vim.notify("abs_dir DOSEN'T contain smartpath")
  else
    -- vim.notify("abs_dir DOSE contain smartpath")
  end


  -- open_tree({
  --   dir = smart_path,
  --   source = "filesystem",
  -- })
  require("neo-tree.command").execute({
    -- reveal = true,
    -- current = true,
    -- reveal_force_cwd = true,
    -- reveal_file = abs_file_path,
    toggle = true,
    dir = smart_path
  })
    -- vim.notify(
    --   "\n" ..
    --   -- "abs_file:" .. tostring(abs_file_path) .. "\n" ..
    --   -- "abs_dir:" .. tostring(abs_dir_path) .. "\n" ..
    --   -- "loc:" .. tostring(loc) .. "\n" ..
    --   "smart:" .. tostring(smart_path) .. "\n" ..
    --   "\n"
    -- )
end
local neotree_reveal_cwd = function() neotree_reveal(true) end
local neotree_reveal_root = function() neotree_reveal(false) end
-- region fix file following issue

return {
  -- PERF: when using / to search, will aborting early if matched with flash
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "neo-tree", "neo-tree-popup", "notify" },
            -- if the buffer type is one of following, the window will be ignored
            buftype = { "terminal", "quickfix" },
          },
        },
        hint = "floating-big-letter",
      })
    end,
  },

  -- TODO: config neo-tree
  -- use 'o' as toggle folder open or close
  -- [[
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    -- "konosubakonoakua/neo-tree.nvim",
    -- branch = "main",
    cmd = "Neotree",
    keys = {
      -- region fix file following issue
      { "<leader>e", neotree_reveal_root, desc = "Explorer NeoTree (root dir)", },
      { "<leader>E", neotree_reveal_cwd, desc = "Explorer NeoTree (cwd)", },
      -- endregion fix file following issue
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer explorer",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.loop.fs_stat(tostring(vim.fn.argv(0)))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      use_popups_for_input = false,
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      filesystem = {
        bind_to_cwd = false,
        -- BUG: not working on windows
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        find_command = "fd",
        find_args = {
          fd = {
            "--exclude",
            ".git",
            "--exclude",
            "node_modules",
          },
        },
      },
      window = {
        mappings = {
          -- region open file without losing focus
          ['<tab>'] = neotree_openfile_nojump,
          -- endregion open file without losing focus
          ["<space>"] = "none",
          ["/"] = "none",
          ["g/"] = "fuzzy_finder",
          -- region Navigation with hjkl
          ["h"] = neotree_navi_h,
          ["l"] = neotree_navi_l,
          -- endregion Navigation with hjkl

          -- ['e'] = function() vim.api.nvim_exec('Neotree focus filesystem left', true) end,
          -- ['b'] = function() vim.api.nvim_exec('Neotree focus buffers left', true) end,
          -- ['g'] = function() vim.api.nvim_exec('Neotree focus git_status left', true) end,

          -- region emulating Vim's fold commands
          ["z"] = "none",
          ["zo"] = neotree_zo,
          ["zO"] = neotree_zO,
          ["zc"] = neotree_zc,
          ["zC"] = neotree_zC,
          ["za"] = neotree_za,
          ["zA"] = neotree_zA,
          ["zx"] = neotree_zx,
          ["zX"] = neotree_zX,
          ["zm"] = neotree_zm,
          ["zM"] = neotree_zM,
          ["zr"] = neotree_zr,
          ["zR"] = neotree_zR,
          -- endregion emulating Vim's fold commands
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
      },
    },
    config = function(_, opts)
      local function on_move(data)
        Util.lsp.on_rename(data.source, data.destination)
      end

      -- region neo-tree event_handlers
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
      -- extend default handlers with user defined ones
      vim.list_extend(opts.event_handlers, neotree_event_handlers)
      -- endregion neo-tree event_handlers
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
  },
  --]]

  -- here only using whichkey for reminding
  -- using 'keymap.lua' or other files to register actual keys
  {
    "folke/which-key.nvim",
    opts = {
      plugins = { spelling = true },
      defaults = {
        mode = { "n", "v" },
        ["gz"] = {},
        ["<leader>l"] = { name = "placeholder" }, -- TODO: remap <leader>l
        ["<leader>L"] = { name = "placeholder" }, -- TODO: remap <leader>L
        ["<leader>;"] = { name = "+utils" },
        ["<leader><leader>"] = { name = "+FzfLua" },
        ["<leader>T"] = { name = "+Test" },
        ["<leader>t"] = { name = "+Telescope" },
      },
    },
  },

  -- Automatically highlights other instances of the word under your cursor.
  -- This works with LSP, Treesitter, and regexp matching to find the other
  -- instances.
  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      { -- add telescope-fzf-native
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        enabled = true,
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      { -- add telescope-zf-native
        "natecraddock/telescope-zf-native.nvim",
        enabled = false,
        config = function()
          require("telescope").load_extension("zf-native")
        end,
      },
    },
    keys = {},
    config = function(_, opts)
      -- PERF: default is "smart", performance killer
      opts.defaults.path_display = { "absolute" }
      opts.defaults.layout_config = {
        width = 999,
        height = 999,
        -- vertical = { width = 1.0, height = 1.0 }
      }
      -- stylua: ignore start
      opts.defaults.mappings = {
        i = {
          ["<C-j>"] = function(...) return require("telescope.actions").move_selection_next(...) end,
          ["<C-k>"] = function(...) return require("telescope.actions").move_selection_previous(...) end,
          ["<C-n>"] = function(...) return require("telescope.actions").move_selection_next(...) end,
          ["<C-p>"] = function(...) return require("telescope.actions").move_selection_previous(...) end,
          ["<A-p>"] = function(...) return require("telescope.actions.layout").toggle_preview(...) end,
        },
        n = {
          ["<A-p>"] = function(...) return require("telescope.actions.layout").toggle_preview(...) end,
        },
      }
      -- stylua: ignore end
      local telescope = require("telescope")
      telescope.setup(opts)
    end,
  },

  -- todo-comments
  -- TODO: ###
  -- FIX: ###
  -- HACK: ###
  -- WARN: ###
  -- PERF: ###
  -- NOTE: ###
  -- TEST: ###
  {
    "folke/todo-comments.nvim",
    version = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = true, -- show icons in the signs column
      sign_priority = 8, -- sign priority
      -- keywords recognized as todo comments
      -- found icons on https://www.nerdfonts.com/cheat-sheet
      keywords = {
        FIX = { icon = icons.bug, color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = icons.todo, color = "info" },
        HACK = { icon = icons.hack, color = "#F86F03" },
        WARN = { icon = icons.warn, color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = icons.perf, alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = icons.note, color = "hint", alt = { "INFO" } },
        TEST = { icon = icons.test, color = "#2CD3E1", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      gui_style = {
        fg = "NONE", -- The gui style to use for the fg highlight group.
        bg = "BOLD", -- The gui style to use for the bg highlight group.
      },
      merge_keywords = true, -- when true, custom keywords will be merged with the defaults
      -- highlighting of the line containing the todo comment
      -- * before: highlights before the keyword (typically comment characters)
      -- * keyword: highlights of the keyword
      -- * after: highlights after the keyword (todo text)
      highlight = {
        multiline = true, -- enable multine todo comments
        multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
        multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
        before = "", -- "fg" or "bg" or empty
        keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = "fg", -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
        comments_only = true, -- uses treesitter to match keywords in comments only
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
      },
      -- list of named colors where we try to extract the guifg from the
      -- list of highlight groups or use the hex color if hl not found as a fallback
      colors = {
        -- error   = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        -- warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
        -- info    = { "DiagnosticInfo", "#2563EB" },
        -- hint    = { "DiagnosticHint", "#10B981" },
        -- default = { "Identifier", "#7C3AED" },
        -- test    = { "Identifier", "#FF00FF" }
        error = { "#DC2626" },
        warning = { "#FBBF24" },
        info = { "#2563EB" },
        hint = { "#10B981" },
        default = { "#7C3AED" },
        test = { "#FF00FF" },
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        -- regex that will be used to match keywords.
        -- don't replace the (KEYWORDS) placeholder
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
      },
    },
  },

  -- search/replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    version = false,
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
  },

}
