--[[ Summary
  -- "kevinhwang91/nvim-ufo"
]]

-- TODO: format tabwidth

-- stylua: ignore start
local keyremappings = {
  { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds", },
  { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds", },
  { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Open folds expect kinds", },
  { "zm", function() require("ufo").closeFoldsWith() end, desc = "Close folds with", },
  { "zp", function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "Peek folded lines under cursor", },
  -- TODO: maybe add hover
  -- FIXME: fold hover not working
  { "K", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end,
  },
}
-- stylua: ignore end

-- TODO: decide folding source for filetypes
local ftMap = {
  vim = { "indent" },
  git = {},
  python = { "indent" },
}

local setVimFoldOptions = function()
  vim.opt.fillchars = {
    foldopen = "",
    foldclose = "",
    fold = " ",
    foldsep = " ",
    diff = "╱",
    eob = " ",
  }
  vim.o.foldcolumn = "0" -- '0' is not bad
  vim.o.foldlevel = 99 -- Feel free to decrease the value
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true
  -- FIXME: hilight group not working
  --
  --[[vim.cmd[[
    hi default UfoFoldedFg guifg=Normal.foreground
    hi default UfoFoldedBg guibg=Folded.background
    hi default link UfoPreviewSbar PmenuSbar
    hi default link UfoPreviewThumb PmenuThumb
    hi default link UfoPreviewWinBar UfoFoldedBg
    hi default link UfoPreviewCursorLine Visual
    hi default link UfoFoldedEllipsis Comment
    hi default link UfoCursorFoldedLine CursorLine
  ]]
end

local function selectProviderWithChainByDefault(bufnr, filetype, buftype)
  local function customizeSelector(bufnr)
    local function handleFallbackException(err, providerName)
      if type(err) == "string" and err:match("UfoFallbackException") then
        return require("ufo").getFolds(bufnr, providerName)
      else
        return require("promise").reject(err)
      end
    end

    return require("ufo")
      .getFolds(bufnr, "lsp")
      :catch(function(err)
        return handleFallbackException(err, "treesitter")
      end)
      :catch(function(err)
        return handleFallbackException(err, "indent")
      end)
  end

  return ftMap[filetype] or customizeSelector
end

local fold_virt_text_handler_ver1 = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = ("  %d "):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end

-- local fold_virt_text_handler_ver2 = function(text, lnum, endLnum, width)
--   local suffix = "  "
--   local lines = ("[ %dL] "):format(endLnum - lnum)
--
--   local cur_width = 0
--   for _, section in ipairs(text) do
--     cur_width = cur_width + vim.fn.strdisplaywidth(section[1])
--   end
--
--   suffix = suffix .. (" "):rep(width - cur_width - vim.fn.strdisplaywidth(lines) - 3)
--
--   table.insert(text, { suffix, "Comment" })
--   table.insert(text, { lines, "Todo" })
--   return text
-- end

-- TODO: use enhanceAction or not
--
-- #region enhanceAction
--
-- ------------------------------------------enhanceAction---------------------------------------------
-- local function peekOrHover()
--     local winid = require('ufo').peekFoldedLinesUnderCursor()
--     if winid then
--         local bufnr = vim.api.nvim_win_get_buf(winid)
--         local keys = {'a', 'i', 'o', 'A', 'I', 'O', 'gd', 'gr'}
--         for _, k in ipairs(keys) do
--             -- Add a prefix key to fire `trace` action,
--             -- if Neovim is 0.8.0 before, remap yourself
--             vim.keymap.set('n', k, '<CR>' .. k, {noremap = false, buffer = bufnr})
--         end
--     else
--         -- -- coc.nvim
--         -- vim.fn.CocActionAsync('definitionHover')
--         -- nvimlsp
--         vim.lsp.buf.hover()
--     end
-- end
--
-- local function goPreviousClosedAndPeek()
--     require('ufo').goPreviousClosedFold()
--     require('ufo').peekFoldedLinesUnderCursor()
-- end
--
-- local function goNextClosedAndPeek()
--     require('ufo').goNextClosedFold()
--     require('ufo').peekFoldedLinesUnderCursor()
-- end
--
-- local function applyFoldsAndThenCloseAllFolds(providerName)
--     require('async')(function()
--         local bufnr = vim.api.nvim_get_current_buf()
--         -- make sure buffer is attached
--         require('ufo').attach(bufnr)
--         -- getFolds return Promise if providerName == 'lsp'
--         local ranges = await(require('ufo').getFolds(bufnr, providerName))
--         local ok = require('ufo').applyFolds(bufnr, ranges)
--         if ok then
--             require('ufo').closeAllFolds()
--         end
--     end)
-- end
--
-- ------------------------------------------enhanceAction---------------------------------------------
-- #endregion enhanceAction

return {
  {
    "kevinhwang91/nvim-ufo",
    version = false,
    dependencies = { "kevinhwang91/promise-async" },
    event = { "BufReadPost", "BufNewFile" },
    keys = keyremappings,
    init = setVimFoldOptions,
    opts = {
      open_fold_hl_timeout = 0,
      provider_selector = selectProviderWithChainByDefault,
      fold_virt_text_handler = fold_virt_text_handler_ver1,
    },
  },

  -- TODO: need to set statuscol colors
  -- https://github.com/luukvbaal/statuscol.nvim/issues/74
  {
    "luukvbaal/statuscol.nvim",
    config = function()
      local builtin = require("statuscol.builtin")
      local cfg = {
        setopt = true, -- Whether to set the 'statuscolumn' option, may be set to false for those who
        -- want to use the click handlers in their own 'statuscolumn': _G.Sc[SFL]a().
        -- Although I recommend just using the segments field below to build your
        -- statuscolumn to benefit from the performance optimizations in this plugin.
        -- builtin.lnumfunc number string options
        thousands = false, -- or line number thousands separator string ("." / ",")
        relculright = false, -- whether to right-align the cursor line number with 'relativenumber' set
        -- Builtin 'statuscolumn' options
        ft_ignore = nil, -- lua table with filetypes for which 'statuscolumn' will be unset
        bt_ignore = nil, -- lua table with 'buftype' values for which 'statuscolumn' will be unset
        -- Default segments (fold -> sign -> line number + separator), explained below
        segments = {
          { text = { "%C" }, click = "v:lua.ScFa" },
          { text = { "%s" }, click = "v:lua.ScSa" },
          {
            text = { builtin.lnumfunc, " " },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          },
        },
        clickmod = "c", -- modifier used for certain actions in the builtin clickhandlers:
        -- "a" for Alt, "c" for Ctrl and "m" for Meta.
        clickhandlers = { -- builtin click handlers
          Lnum = builtin.lnum_click,
          FoldClose = builtin.foldclose_click,
          FoldOpen = builtin.foldopen_click,
          FoldOther = builtin.foldother_click,
          DapBreakpointRejected = builtin.toggle_breakpoint,
          DapBreakpoint = builtin.toggle_breakpoint,
          DapBreakpointCondition = builtin.toggle_breakpoint,
          DiagnosticSignError = builtin.diagnostic_click,
          DiagnosticSignHint = builtin.diagnostic_click,
          DiagnosticSignInfo = builtin.diagnostic_click,
          DiagnosticSignWarn = builtin.diagnostic_click,
          GitSignsTopdelete = builtin.gitsigns_click,
          GitSignsUntracked = builtin.gitsigns_click,
          GitSignsAdd = builtin.gitsigns_click,
          GitSignsChange = builtin.gitsigns_click,
          GitSignsChangedelete = builtin.gitsigns_click,
          GitSignsDelete = builtin.gitsigns_click,
          gitsigns_extmark_signs_ = builtin.gitsigns_click,
        },
      }
      require("statuscol").setup(cfg)
    end,
  },
}
