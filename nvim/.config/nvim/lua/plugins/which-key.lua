return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix",
		spec = {
			{
				mode = { "n", "x" },
				{ "<leader><tab>", group = "Tabs" },
				{ "<leader>c", group = "Code" },
				{ "<leader>d", group = "Debug" },
				{ "<leader>f", group = "File/Find" },
				{ "<leader>t", group = "Terminal" },
				{ "<leader>g", group = "Git" },
				{ "<leader>i", group = "Inspect" },
				{ "<leader>gt", group = "Toggles" },
				{ "<leader>gh", group = "Hunks" },
				{ "<leader>s", group = "Search" },
				{ "<leader>u", group = "UI" },
				{ "<leader>x", group = "Diagnostics/Quickfix" },
				{ "<leader>r", group = "Remove" },
				{ "<leader>y", group = "Yank" },
				{ "<leader>q", group = "Quit" },
				{ "[", group = "Prev" },
				{ "]", group = "Next" },
				{ "g", group = "Goto" },
				{
					"<leader>b",
					group = "Buffer",
					expand = function()
						return require("which-key.extras").expand.buf()
					end,
				},
				{
					"<leader>w",
					group = "Windows",
					proxy = "<c-w>",
					expand = function()
						return require("which-key.extras").expand.win()
					end,
				},
			},
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Keymaps (which-key)",
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
	end,
}
