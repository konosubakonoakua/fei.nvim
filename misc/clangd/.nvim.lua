require("lspconfig").clangd.setup({
	cmd = {
		"clangd",

		-- speed
		"-j=8",
		"--malloc-trim",
		"--background-index",
		"--pch-storage=memory",
		"--clang-tidy",

		-- style
		"--header-insertion=iwyu",
		"--completion-style=detailed",
		"--function-arg-placeholders",
		"--fallback-style=llvm",

		-- cross-compile
		-- "--query-driver=/usr/bin/c++",
		-- "--query-driver=arm-none-eabi-*",
		"--query-driver=arm-none-linux-gnueabihf-*",
	},
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
})
