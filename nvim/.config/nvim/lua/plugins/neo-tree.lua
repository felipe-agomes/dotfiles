return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	lazy = false,
	---@module 'neo-tree'
	---@type neotree.Config
	opts = {
		filesystem = {
			follow_current_file = {
				enabled = true,
				leave_dirs_open = true,
			},
		},
		window = {
			mappings = {
				["<space>"] = "",
				["z"] = "",
				["<BS>"] = "close_all_nodes",
				["l"] = "open",
				["h"] = "close_node",
			},
		},
	},
	config = function(_, opts)
		require("neo-tree").setup(opts)

		vim.keymap.set("n", "<leader>e", function()
			vim.cmd("Neotree toggle")
		end)
	end,
}
