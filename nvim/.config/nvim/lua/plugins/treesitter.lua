-- Engine de parsing para highlight de sintaxe avançado e indentação.
return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	version = false, -- sempre usa a versão mais recente
	build = ":TSUpdate", -- atualiza os parsers
	opts = {
		ensure_installed = { "json", "java", "lua", "sql", "yaml", "csv", "xml", "javascript", "typescript" },
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
	},
}
