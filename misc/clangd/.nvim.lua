require("lspconfig").clangd.setup({
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--completion-style=detailed",
		"--function-arg-placeholders",
		"--fallback-style=llvm",
		-- "--query-driver=/usr/bin/c++",
		-- "--query-driver=arm-none-eabi-*",
		"--query-driver=arm-none-linux-gnueabihf-*",
	},
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
})
