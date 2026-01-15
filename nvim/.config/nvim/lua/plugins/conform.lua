-- Motor de formatação de código (Formatters).
local config = vim.fn.stdpath("config")

return {
	"stevearc/conform.nvim",
	opts = {
		formatters = {
			xmlformat = {
				command = "xmlformat",
				args = { "-" },
				stdin = true,
			},
			google_java_format = {
				command = "google-java-format",
				args = { "-" },
				stdin = true,
			},
			sql_formatter = {
				command = "sql-formatter",
				args = { "-c", config .. "/configs/.sql-formatter.json" },

				stdin = true,
			},
		},
		formatters_by_ft = {
			lua = { "stylua" },
			java = { "google_java_format" },
			sql = { "sql_formatter" },
			xml = { "xmlformat" },
			json = { "fixjson" },
			jsonc = { "fixjson" },
		},
	},
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ bufnr = 0 })
			end,
			desc = "Format buffer",
		},
	},
}
