return {
	"folke/todo-comments.nvim",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {},
	keys = {
		{
			"<leader>sT",
			"<cmd>TodoFzfLua<cr>",
			desc = "Search: TODO/FIXME",
		},
	},
}
