return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		automatic_enable = false,
		ensure_installed = { "lua_ls", "jdtls", "jsonls", "pylsp", "sqls", "yamlls", "vtsls", "lemminx", "bashls" },
	},
	dependencies = {
		"mason-org/mason.nvim",
	},
}
