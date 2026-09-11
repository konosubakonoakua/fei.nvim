-- TODO: restore keymaps after quitting DAP-UI
-- map `<C-Fx>` is equal to map `<Fy>` where y = x + 24.
-- map `<S-Fx>` is equal to map `<Fy>` where y = x + 12.
local M = {
  "mfussenegger/nvim-dap",
  optional = true,
  desc = "DAP keymaps (F4-F12), signs and virtual text",
  keys = {
    { "<F4>", "<cmd>lua require'dap'.terminate()<CR>", silent = true, desc = "Terminate" },
    { "<F5>", "<cmd>lua require'dap'.continue()<CR>", silent = true, desc = "DAP launch or continue" },
    { "<F8>", "<cmd>lua require'dapui'.toggle()<CR>", silent = true, desc = "DAP toggle UI" },
    { "<F9>", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", silent = true, desc = "DAP toggle breakpoint" },
    { "<F10>", "<cmd>lua require'dap'.step_over()<CR>", silent = true, desc = "DAP step over" },
    { "<F11>", "<cmd>lua require'dap'.step_into()<CR>", silent = true, desc = "DAP step into" },
    { "<F12>", "<cmd>lua require'dap'.step_out()<CR>", silent = true, desc = "DAP step out" },
    { "<F17>", "<cmd>lua require'dap'.terminate()<CR>", silent = true, desc = "Terminate" }, -- <S-F5>
    { "<leader>dP", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", silent = true, desc = "Set breakpoint with log point message" },
  },
}

if LazyVim.has("fzf-lua") then
  local function fzf_lua(cmd)
    require("fzf-lua")[cmd]()
  end
  vim.list_extend(M.keys, {
    { "<leader>d?", function() fzf_lua("dap_commands") end, silent = true, desc = "DAP FZF builtin commands" },
    { "<leader>db", function() fzf_lua("dap_breakpoints") end, silent = true, desc = "DAP FZF breakpoint list" },
    { "<leader>df", function() fzf_lua("dap_frames") end, silent = true, desc = "DAP FZF frames" },
    { "<leader>dv", function() fzf_lua("dap_variables") end, silent = true, desc = "DAP FZF variables" },
    { "<leader>dx", function() fzf_lua("dap_configurations") end, silent = true, desc = "DAP FZF configurations" },
  })
end

M.config = function()
  vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

  for name, sign in pairs(LazyVim.config.icons.dap) do
    sign = type(sign) == "table" and sign or { sign }
    vim.fn.sign_define(
      "Dap" .. name,
      { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
    )
  end
  -- configure nvim-dap-virtual-text
  local ok, dapvt = pcall(require, "nvim-dap-virtual-text")
  if ok and dapvt then
    dapvt.setup({
      -- "inline" is also possible with nvim-0.10, IMHO is confusing
      virt_text_pos = "eol",
    })
  end
end

return M
