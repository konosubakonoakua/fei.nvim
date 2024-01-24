-- function copy(sel)
--   return function(lines, _)
--     local data = vim.fn.system([[base64 | tr -d '\n']], lines)
--     io.stdout:write('\027]52;'..sel..';'..data..'\a')
--   end
-- end

-- vim.g.clipboard = {name='OSC-52', copy={['*']=copy's', ['+']=copy'c'}}
----------------------------------------------------------------------
return {
  "amitds1997/remote-nvim.nvim",
  version = "*", -- This keeps it pinned to semantic releases
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
    -- This would be an optional dependency eventually
    "nvim-telescope/telescope.nvim",
  },
  config = true, -- This calls the default setup(); make sure to call it
}

-- https://github.com/amitds1997/remote-nvim.nvim
