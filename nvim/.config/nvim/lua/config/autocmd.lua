vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"java",
		"lua",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"yml",
		"yaml",
		"csv",
		"xml",
		"json",
		"http",
		"sh",
		"zsh",
	},
	callback = function()
		vim.treesitter.language.register("bash", "zsh")
		vim.treesitter.language.register("javascript", "javascriptreact")
		vim.treesitter.language.register("typescript", "typescriptreact")

		vim.treesitter.start()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sql" },
	callback = function()
		vim.cmd("SQLSetType plsql.vim")
	end,
})
