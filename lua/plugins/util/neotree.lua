local M = {}
local events = require("neo-tree.events")
-- region neo-tree event_handlers
M.neotree_event_handlers = {

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
local renderer = require("neo-tree.ui.renderer")

-- Expand a node and load filesystem info if needed.
local function open_dir(state, dir_node)
  local fs = require("neo-tree.sources.filesystem") fs.toggle_directory(state, dir_node, nil, true, false)
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
local neotree_execute_bash = function(state)
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
  if not state and not state.tree then return end
  local node = state.tree:get_node()
  if not node then return end

  -- goto parent folder when reach the current root
  if node:get_parent_id() == nil then
    require("neo-tree.sources.filesystem.commands").navigate_up(state)
  end
  if node.type == "directory" and node:is_expanded() then
    require("neo-tree.sources.filesystem").toggle_directory(state, node)
  else
    require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
  end
end

local neotree_navi_l = function(state)
  if not state and not state.tree then return end
  local node = state.tree:get_node()
  if not node then return end

  -- vim.notify(vim.inspect(node.type))
  if node.type == "directory" then
    if not node:is_expanded() then
      require("neo-tree.sources.filesystem").toggle_directory(state, node)
    elseif node:has_children() then
      require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
    end
  elseif node.type == "symbol" then
    if node:has_children() then
      require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
    end
  end
end
-- endregion Navigation with hjkl

-- region open file without losing focus
local neotree_openfile_nojump = function(state)
  local node = state.tree:get_node()
  if require("neo-tree.utils").is_expandable(node) then
    state.commands["toggle_node"](state)
  else
    state.commands["open"](state)
    vim.cmd("Neotree reveal")
  end
end
-- endregion open file without losing focus

-- region toggle follow current file
_G.neotree_follow_current_file_status = true
local neotree_toggle_follow_current_file = function()
  _G.neotree_follow_current_file_status = not _G.neotree_follow_current_file_status
  if _G.neotree_follow_current_file_status == true then
    vim.notify("Neotree follow current file ON", vim.log.levels.WARN)
  else
    vim.notify("Neotree follow current file OFF", vim.log.levels.WARN)
  end
  require("neo-tree").setup({
    filesystem = {
      -- BUG: not working on windows
      follow_current_file = {
        enabled = _G.neotree_follow_current_file_status,
      },
    },
  })
end
-- endregion toggle follow current file

-- region fix file following issue
M.open_tree = function(args)
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

local neotree_reveal = function(use_cwd)
  local bufnr = vim.fn.bufnr("%")
  local abs_file_path = vim.api.nvim_buf_get_name(bufnr)
  abs_file_path = LazyVim.is_win() and abs_file_path:gsub("/", "\\") or abs_file_path
  local abs_dir_path = vim.fn.fnamemodify(abs_file_path, ":p:h")
  abs_dir_path = LazyVim.is_win() and abs_dir_path:gsub("/", "\\") or abs_dir_path
  local smart_path = nil
  if use_cwd then
    smart_path = vim.uv.cwd()
  else
    smart_path = LazyVim.root({
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
    dir = smart_path,
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

M.neotree_reveal_cwd = function()
  neotree_reveal(true)
end
M.neotree_reveal_root = function()
  neotree_reveal(false)
end
-- region fix file following issue

-- region filesystem_window_mappings
M.filesystem_window_mappings = {
  ["<tab>"] = {
    neotree_openfile_nojump,
    desc = "open file (no jump)",
    nowait = true,
  },
  ["g/"] = "fuzzy_finder",
  ["gf"] = {
    neotree_toggle_follow_current_file,
    desc = "toggle folow current file",
    nowait = true,
  },

  -- ['e'] = function() vim.api.nvim_exec('Neotree focus filesystem left', true) end,
  -- ['b'] = function() vim.api.nvim_exec('Neotree focus buffers left', true) end,
  -- ['g'] = function() vim.api.nvim_exec('Neotree focus git_status left', true) end,

  -- region emulating Vim's fold commands
  ["z"] = "none",
  ["zo"] = {
    neotree_zo,
    desc = "folder expand",
    nowait = true,
  },
  ["zO"] = {
    neotree_zO,
    desc = "folder expand recursively",
    nowait = true,
  },
  ["zc"] = {
    neotree_zc,
    desc = "folder collapse",
    nowait = true,
  },
  ["zC"] = {
    neotree_zC,
    desc = "folder collapse recursively",
    nowait = true,
  },
  ["za"] = {
    neotree_za,
    desc = "folder toggle folding with count",
    -- nowait = true
  },
  ["zA"] = {
    neotree_zA,
    desc = "folder toggle folding with count recursively",
    nowait = true,
  },
  ["zx"] = {
    neotree_zx,
    desc = "folder update folding by depth then reveal",
    nowait = true,
  },
  ["zX"] = {
    neotree_zX,
    desc = "folder update folding by depth",
    nowait = true,
  },
  ["zm"] = {
    neotree_zm,
    desc = "folder collapse with count",
    nowait = true,
  },
  ["zM"] = {
    neotree_zM,
    desc = "folder collapse all",
    nowait = true,
  },
  ["zr"] = {
    neotree_zr,
    desc = "folder expand with count",
    nowait = true,
  },
  ["zR"] = {
    neotree_zR,
    desc = "folder expand all",
    nowait = true,
  },
  -- endregion emulating Vim's fold commands
}
-- endregion filesystem_window_mappings

-- region mappings_window
M.window_mappings = {
  ["<space>"] = "none",
  ["/"] = "none",
  ["s"] = "none",
  ["<C-s>"] = "open_vsplit",
  -- region Navigation with hjkl
  ["h"] = {
    neotree_navi_h,
    desc = "navigate h",
    nowait = true,
  },
  ["l"] = {
    neotree_navi_l,
    desc = "navigate l",
    nowait = true,
  },
  -- endregion Navigation with hjkl
}
-- endregion mappings_window

-- region symbol_window_mappings
M.document_symbols_window_mappings = {
  ["<cr>"] = "jump_to_symbol",
  ["o"] = "jump_to_symbol",
  ["A"] = "noop",
  ["d"] = "noop",
  ["y"] = "noop",
  ["x"] = "noop",
  ["p"] = "noop",
  ["c"] = "noop",
  ["m"] = "noop",
  ["a"] = "noop",
  ["/"] = "filter",
  ["f"] = "filter_on_submit",
  ["r"] = "rename",
}
-- endregion symbol_window_mappings

M.neotree_spec = {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    -- {
    --   "<leader>e",
    --   require("plugins.util.neotree").neotree_reveal_root,
    --   -- "<cmd>Neotree toggle show<cr>",
    --   desc = "Explorer NeoTree (root dir)",
    -- },
    -- {
    --   "<leader>E", -- NOTE: fix file following issue
    --   require("plugins.util.neotree").neotree_reveal_cwd,
    --   -- "<cmd>Neotree toggle show<cr>",
    --   desc = "Explorer NeoTree (cwd)",
    -- },
    -- {
    --   -- TODO: not working if already on the neotree window,
    --   -- consider record the last file buffer which needs to be revealed in <leader>e
    --   -- currently stop using auto-follow
    --   "<leader>fe", function ()
    --     -- TODO: quit if not on a realfile or use history
    --     require('neo-tree.command').execute({
    --       action = "show",
    --       source = "filesystem",
    --       position = "left",
    --       -- reveal_file = reveal_file,
    --       dir = LazyVim.root(),
    --       -- reveal_force_cwd = true,
    --       -- toggle = true,
    --     })
    --     -- FIXME: don't close opend folders
    --     -- show_only_explicitly_opened() can be disabled
    --     require("neo-tree.sources.filesystem.init").follow(nil, true)
    --     -- -- FIXME: cannot focus on file
    --     -- vim.cmd([[
    --     --   Neotree reveal
    --     -- ]])
    --     require('neo-tree.command').execute({
    --       action = "reveal",
    --       source = "filesystem",
    --       position = "left",
    --       dir = LazyVim.root(),
    --       -- toggle = true,
    --     })
    --   end,
    --   mode = 'n',
    --   desc="Open neo-tree at current file or working directory"
    -- },
  },
}

return M
