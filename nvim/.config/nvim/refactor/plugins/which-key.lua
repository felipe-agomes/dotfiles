-- Popup que exibe os atalhos de teclado disponíveis enquanto você digita.return {
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix",
		spec = {
			{
				mode = { "n", "x" },
				{ "<leader><tab>", group = "tabs" },
				{ "<leader>c", group = "code" },
				{ "<leader>d", group = "debug" },
				{ "<leader>f", group = "file/find" },
				{ "<leader>g", group = "git" },
				{ "<leader>i", group = "inspect" },
				{ "<leader>gt", group = "toggles" },
				{ "<leader>gh", group = "hunks" },
				{ "<leader>s", group = "search" },
				{ "<leader>u", group = "ui" },
				{ "<leader>x", group = "diagnostics/quickfix" },
				{ "<leader>r", group = "remove" },
				{ "<leader>y", group = "yank" },
				{ "<leader>q", group = "quit" },
				{ "[", group = "prev" },
				{ "]", group = "next" },
				{ "g", group = "goto" },
				{
					"<leader>b",
					group = "buffer",
					expand = function()
						return require("which-key.extras").expand.buf()
					end,
				},
				{
					"<leader>w",
					group = "windows",
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
		}
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
	end,
}
