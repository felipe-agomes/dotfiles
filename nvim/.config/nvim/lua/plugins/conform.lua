return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettierd" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			java = { "google-java-format" },
		},
	},
	config = function(_, opts)
		local conform = require("conform")
		conform.setup(opts)

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("format-ft", { clear = true }),
			pattern = vim.tbl_keys(opts.formatters_by_ft),
			callback = function(_)
				vim.keymap.set("n", "grf", function()
					conform.format()
				end, { desc = "Format Buffer" })
			end,
		})
	end,
}
