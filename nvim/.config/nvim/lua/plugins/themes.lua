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
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			keywordStyle = { italic = false, bold = false },
			statementStyle = { italic = false, bold = false },
			overrides = function(colors)
				return {
					Boolean = { fg = "#ff7733", bold = false },
					SnacksPickerFile = { fg = "#dcd7ba" },
					DiagnosticWarn = { fg = "#ff7733" },
					Operator = { fg = "#957fb8" },
					Special = { fg = "#5bbbd5" },
					Type = { fg = "#5bbbd5" },
					Function = { fg = "#7e8fff" },
				}
			end,
		},
		config = function(_, opts)
			require("kanagawa").setup(opts)
			vim.cmd("colorscheme kanagawa-wave")
		end,
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
	{ "dracula/vim", lazy = false, priority = 1000 },
}
