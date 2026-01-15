-- Explorador de arquivos que permite editar o diretório como se fosse um buffer de texto.
return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		default_file_explorer = false,
		columns = {
			"icon",
			"permissions",
			"size",
			"mtime",
		},
	},
	dependencies = { "nvim-mini/mini.icons" },
	lazy = false,
}
