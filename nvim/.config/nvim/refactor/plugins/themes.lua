-- Configuração do esquema de cores (Colorscheme).
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
