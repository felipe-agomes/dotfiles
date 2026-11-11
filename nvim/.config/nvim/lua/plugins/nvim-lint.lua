return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		linters_by_ft = {
			python = { "ruff" },
		},
	},
	config = function(_, opts)
		local lint = require("lint")

		lint.linters_by_ft = opts.linters_by_ft

		vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
