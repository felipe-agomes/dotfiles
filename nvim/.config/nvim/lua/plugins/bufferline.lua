return {
	"akinsho/bufferline.nvim",
	cwrsion = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	opts = {},
	config = function(_, opts)
		require("bufferline").setup(opts)

		vim.keymap.set("n", "<leader>bd", function()
			vim.api.nvim_buf_delete(0, { force = false })
		end, { desc = "Delete Buffer" })

		vim.keymap.set("n", "<leader>bo", function()
			vim.cmd("BufferLineCloseOthers")
		end, { desc = "Delete Buffers others" })

		vim.keymap.set("n", "<leader>bl", function()
			vim.cmd("BufferLineCloseLeft")
		end, { desc = "Delete Buffers to the Left" })

		vim.keymap.set("n", "<leader>br", function()
			vim.cmd("BufferLineCloseRight")
		end, { desc = "Delete Buffers to the Right" })

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
