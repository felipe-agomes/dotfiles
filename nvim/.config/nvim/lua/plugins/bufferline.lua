return {
	"akinsho/bufferline.nvim",
	cwrsion = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	opts = {},
	config = function(_, opts)
		require("bufferline").setup(opts)

		vim.keymap.set("n", "H", function()
			vim.cmd("BufferLineCyclePrev")
		end)

		vim.keymap.set("n", "L", function()
			vim.cmd("BufferLineCycleNext")
		end)

		vim.keymap.set("n", "[B", function()
			vim.cmd("BufferLineMovePrev")
		end, { desc = "Move buffer prev" })

		vim.keymap.set("n", "]B", function()
			vim.cmd("BufferLineMoveNext")
		end, { desc = "Move buffer next" })
	end,
}
