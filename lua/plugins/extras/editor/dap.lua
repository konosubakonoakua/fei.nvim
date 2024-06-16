local map = vim.keymap.set

-- TODO: restore keymaps after quiting DAP-UI
local M = {
  "mfussenegger/nvim-dap",
  optional = true,
  keys = { "<F5>", "<F8>", "<F9>" },
}

-- map `<C-Fx>` is equal to map `<Fy>` where y = x + 24.
-- map `<S-Fx>` is equal to map `<Fy>` where y = x + 12.
M.keys = {
  { "<F4>", "<cmd>lua require'dap'.terminate()<CR>",          silent = true, desc = "Terminate" },
  { "<F5>", "<cmd>lua require'dap'.continue()<CR>",           silent = true, desc = "DAP launch or continue" },
  { "<F8>", "<cmd>lua require'dapui'.toggle()<CR>",           silent = true, desc = "DAP toggle UI" },
  { "<F9>", "<cmd>lua require'dap'.toggle_breakpoint()<CR>",  silent = true, desc = "DAP toggle breakpoint" },
  { "<F10>", "<cmd>lua require'dap'.step_over()<CR>",         silent = true, desc = "DAP step over" },
  { "<F11>", "<cmd>lua require'dap'.step_into()<CR>",         silent = true, desc = "DAP step into" },
  { "<F12>", "<cmd>lua require'dap'.step_out()<CR>",          silent = true, desc = "DAP step out" },
  { "<F17>", "<cmd>lua require'dap'.terminate()<CR>",         silent = true, desc = "Terminate" }, -- <S-F5>
  -- { "<leader>dc", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", silent = true, desc = "set breakpoint with condition" },
  { "<leader>dP", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", silent = true, desc = "set breakpoint with log point message" },
  -- { "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<CR>", silent = true, desc = "toggle debugger REPL" },
}

if LazyVim.has("fzf-lua") == 1 then
  local function fzf_lua(cmd) require("fzf-lua")[cmd]() end
  M.fzf_keys = {
    { "<leader>d?", function() fzf_lua("dap_commands") end,       silent = true, desc = "DAP FZF builtin commands" },
    { "<leader>db", function() fzf_lua("dap_breakpoints") end,    silent = true, desc = "DAP FZF breakpoint list" },
    { "<leader>df", function() fzf_lua("dap_frames") end,         silent = true, desc = "DAP FZF frames" },
    { "<leader>dv", function() fzf_lua("dap_variables") end,      silent = true, desc = "DAP FZF variables" },
    { "<leader>dx", function() fzf_lua("dap_configurations") end, silent = true, desc = "DAP FZF configurations" },
  }
  M.keys = vim.tbl_deep_extend("keep", M.keys, M.fzf_keys)
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
