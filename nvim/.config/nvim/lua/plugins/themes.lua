return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"catppuccin/nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd("colorscheme catppuccin-frappe")

			vim.api.nvim_set_hl(0, "Changed", { fg = "#e5c07b" })
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"rose-pine/neovim",
		lazy = false,
		priority = 1000,
	},
	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
	},
	{
		"ribru17/bamboo.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"Rigellute/shades-of-purple.vim",
		lazy = false,
		priority = 1000,
	},
}
