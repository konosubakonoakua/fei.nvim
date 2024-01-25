return {
  'glepnir/nerdicons.nvim',
  cmd = 'NerdIcons',
  config = function()
    require('nerdicons').setup({
      border = 'rounded',         -- Border
      prompt = '󰨭 ',           -- Prompt Icon
      preview_prompt = ' ',   -- Preview Prompt Icon
      width = 0.5              -- flaot window width
      down = '<C-j>',          -- Move down in preview
      up = '<C-k>',            -- Move up in preview
      copy = '<C-y>',          -- Copy to the clipboard
    })
  end
}
