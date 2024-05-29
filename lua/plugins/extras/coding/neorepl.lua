-- https://github.com/ii14/neorepl.nvim
-- local cmd_neorepl_quit = [[
-- <cmd>lua << EOF
-- local repl_bufnr = vim.api.nvim_get_current_buf()
-- vim.cmd('stopinsert')
-- require('neorepl.bufs')[repl_bufnr] = nil
-- vim.api.nvim_buf_delete(repl_bufnr, { force = true })
-- EOF
-- <cr>
-- ]]

return {
  {
    "ii14/neorepl.nvim",
    lazy = true,
    -- event = "WinEnter",
    init = function ()
      vim.api.nvim_create_user_command('NeoreplQuit', function ()
      end, {desc = "Neorepl Quit"})

      -- NOTE: q to close REPL instance in norm mode
      vim.keymap.set('n', 'g:', function()
        -- get current buffer and window
        local buf = vim.api.nvim_get_current_buf()
        local win = vim.api.nvim_get_current_win()
        -- create a new split for the repl
        vim.cmd('split')
        -- spawn repl and set the context to our buffer
        require('neorepl').new{
          lang = 'lua',
          buffer = buf,
          window = win,
        }

        if vim.bo.ft == "neorepl" then
          -- vim.api.nvim_buf_set_keymap(0, "n", 'q', cmd_neorepl_quit, {desc = "Quit Neorepl"})
          vim.keymap.set("n", 'q', function ()
            local repl_bufnr = vim.api.nvim_get_current_buf()
            vim.cmd('stopinsert')
            require('neorepl.bufs')[repl_bufnr] = nil
            vim.api.nvim_buf_delete(repl_bufnr, { force = true })
          end, { buffer = true, desc = "Quit Neorepl" })
        end

        -- resize repl window and make it fixed height
        vim.cmd('resize 10 | setl winfixheight')
      end)
    end
  }
}
