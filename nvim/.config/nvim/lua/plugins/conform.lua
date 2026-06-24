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
			beautysh = {
				command = "beautysh",
			},
		},
		formatters_by_ft = {
			lua = { "stylua" },
			java = { "google_java_format" },
      javascript = { "prettierd"},
      typescript = { "prettierd"},
      javascriptreact = { "prettierd"},
      typescriptreact = { "prettierd"},
      markdown = { "prettierd"},
			sql = { "sql_formatter" },
			xml = { "xmlformat" },
			json = { "prettierd" },
			jsonc = { "prettierd" },
			sh = { "beautysh" },
			zsh = { "beautysh" },
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
