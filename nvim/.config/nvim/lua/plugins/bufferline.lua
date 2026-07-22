return {
	"akinsho/bufferline.nvim",
	cwrsion = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	opts = {},
	config = function(_, opts)
		local bufferline = require("bufferline")
		bufferline.setup(opts)

		vim.keymap.set("n", "<leader>bd", function()
			local buf = vim.api.nvim_get_current_buf()
			vim.cmd("BufferLineCycleNext")
			vim.api.nvim_buf_delete(buf, { force = true })
		end, { desc = "Buffer: Delete current" })

		vim.keymap.set("n", "<leader>bo", function()
			vim.cmd("BufferLineCloseOthers")
		end, { desc = "Buffer: Delete others" })

		vim.keymap.set("n", "<leader>bl", function()
			vim.cmd("BufferLineCloseLeft")
		end, { desc = "Buffer: Delete to the Left" })

		vim.keymap.set("n", "<leader>br", function()
			vim.cmd("BufferLineCloseRight")
		end, { desc = "Buffer: Delete to the Right" })

		vim.keymap.set("n", "H", function()
			vim.cmd("BufferLineCyclePrev")
		end)

		vim.keymap.set("n", "L", function()
			vim.cmd("BufferLineCycleNext")
		end)

		vim.keymap.set("n", "[B", function()
			vim.cmd("BufferLineMovePrev")
		end, { desc = "Buffer: Move prev" })

		vim.keymap.set("n", "]B", function()
			vim.cmd("BufferLineMoveNext")
		end, { desc = "Buffer: Move next" })
	end,
}
