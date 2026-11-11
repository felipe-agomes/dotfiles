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
		"markdown",
		"python",
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

-- O watcher do snacks.explorer só observa `.git/index`, que não muda em um
-- commit. Invalidamos o cache do explorer ao sair do lazygit e ao voltar o
-- foco para o Neovim (commits feitos em terminal externo).
vim.api.nvim_create_autocmd("TermClose", {
	callback = function(ev)
		local term = vim.b[ev.buf].snacks_terminal
		local cmd = term and term.cmd
		local is_lazygit = cmd == "lazygit" or (type(cmd) == "table" and cmd[1] == "lazygit")

		if is_lazygit then
			require("utils.explorer").refresh_git()
		end
	end,
})

vim.api.nvim_create_autocmd("FocusGained", {
	callback = function()
		require("utils.explorer").refresh_git()
	end,
})
