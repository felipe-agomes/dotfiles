return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettierd" },
		},
	},
	config = function(_, opts)
		local conform = require("conform")
		conform.setup(opts)

		vim.keymap.set("n", "<leader>cf", function()
			conform.format()
		end, { desc = "Format" })
	end,
}
