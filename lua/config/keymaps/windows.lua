-- Window navigation / resizing / management.
local keymap = vim.keymap.set

-- navigate
keymap("n", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
keymap("n", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
keymap("n", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
keymap("n", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })

-- resize
keymap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
keymap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- manage
keymap("n", "<leader>wo", "<cmd>wincmd o<cr>", { desc = "Only Window" })
keymap("n", "<leader>ws", "<cmd>wincmd s<cr>", { desc = "Split Below" })
keymap("n", "<leader>wv", "<cmd>wincmd v<cr>", { desc = "Split Right" })
keymap("n", "<leader>wx", "<cmd>wincmd x<cr>", { desc = "Swap Windows (stay)" })
keymap("n", "<leader>wr", "<cmd>wincmd r<cr>", { desc = "Rotate Windows" })
keymap("n", "<leader>wc", "<cmd>close<cr>", { desc = "Close Window" })
