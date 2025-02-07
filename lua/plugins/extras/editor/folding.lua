--[[ Summary
  -- "kevinhwang91/nvim-ufo"
]]

local icons = require("util.icons").fold

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
  vim = { "treesitter", "indent" },
  git = { "treesitter", "indent" },
  python = { "indent" },
  lua = { "lsp", "treesitter" },
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
  vim.o.foldcolumn = "0" -- indicate folds and their nesting levels
  vim.o.foldlevel = 99 -- Feel free to decrease the value
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true
  vim.cmd[[
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
  local suffix = (" " .. icons.fold .. " %d "):format(endLnum - lnum)
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
-- region enhanceAction
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
-- endregion enhanceAction

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
}
