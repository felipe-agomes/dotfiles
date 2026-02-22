-- Comandos para inicializar plugins
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"java",
		"lua",
		"javascript",
		"yml",
		"yaml" --[[ , "sql", "plsql" ]],
		"csv",
		"xml",
		"json",
		"http",
		"sh",
		"zsh",
	},
	callback = function()
		vim.treesitter.language.register("sql", "plsql")
		vim.treesitter.language.register("bash", "zsh")
		vim.treesitter.start()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sql", "sh", "zsh" },
	callback = function()
		vim.bo.tabstop = 4
		vim.bo.shiftwidth = 4
		vim.bo.expandtab = true
	end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
	callback = function()
		require("lint").try_lint()
	end,
})
