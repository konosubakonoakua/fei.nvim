return {
    "NStefan002/screenkey.nvim",
    cmd = "Screenkey",
    version = "*",
    desc = "on-screen key display",
    config = true,
    keys = {
        {"<leader>;S", "<cmd>Screenkey<cr>", mode = "n", desc = "Toggle Screenkey"}
    },
}
