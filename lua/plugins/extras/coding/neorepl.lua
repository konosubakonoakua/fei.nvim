-- https://github.com/ii14/neorepl.nvim
return {
  {
    "ii14/neorepl.nvim",
    lazy = true,
    -- event = "WinEnter",
    init = function ()
      -- NOTE: type /q to close REPL instance
      vim.keymap.set('n', 'g:', function()
        -- get current buffer and window
        local buf = vim.api.nvim_get_current_buf()
        local win = vim.api.nvim_get_current_win()
        -- create a new split for the repl
        vim.cmd('split')
        -- spawn repl and set the context to our buffer
        require('neorepl').new{
          lang = 'vim',
          buffer = buf,
          window = win,
        }

        local repl_bufnr = vim.api.nvim_get_current_buf()
        if vim.bo.ft == "neorepl" then
          vim.keymap.set("n", 'q', function ()
            vim.cmd('stopinsert')
            require('neorepl.bufs')[repl_bufnr] = nil
            vim.api.nvim_buf_delete(repl_bufnr, { force = true })
            return false
          end)
        end

        -- resize repl window and make it fixed height
        vim.cmd('resize 10 | setl winfixheight')
      end)
    end
  }
}
