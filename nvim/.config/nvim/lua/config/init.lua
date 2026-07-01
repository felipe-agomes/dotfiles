require("config.lazy")
require("config.lsp")

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
		"sql",
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

vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.wrap = false
vim.opt.list = true
vim.opt.mousemoveevent = true
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
