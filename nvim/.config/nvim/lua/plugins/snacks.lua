return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		-- image = { enabled = true },
		-- bigfile = { enabled = true },
		-- dashboard = { enabled = true },
		indent = {
			enabled = true,
			priority = 1,
			char = "│",
			only_scope = false,
			only_current = false,
			hl = "SnacksIndent",
			animate = {
				enabled = true,
				style = "out",
				easing = "linear",
				duration = {
					step = 20,
					total = 300,
				},
			},
			chunk = {
				enabled = true,
				only_current = false,
				priority = 200,
				hl = "SnacksIndentChunk",
				char = {
					corner_top = "╭",
					corner_bottom = "╰",
					horizontal = "─",
					vertical = "│",
					arrow = ">",
				},
			},
		},
		explorer = { enabled = true },
		input = { enabled = true },
		picker = { enabled = true },
		notifier = { enabled = true },
		lazygit = { enabled = true },
		scope = {
			enabled = true,
			priority = 200,
			char = "│",
			underline = true,
			only_current = false,
			hl = "SnacksIndentScope",
		},
		statuscolumn = { enabled = true },
		words = { enabled = true },
	},
	keys = {
		{
			"<leader>e",
			function()
				Snacks.explorer()
			end,
			desc = "File Explorer",
		},
		{
			"<leader>n",
			function()
				Snacks.picker.notifications()
			end,
			desc = "Notification History",
		},
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>tz",
			function()
				Snacks.zen()
			end,
			desc = "Toggle: Zen Mode",
		},
		{
			"<leader>tZ",
			function()
				Snacks.zen.zoom()
			end,
			desc = "Toggle: Zen Mode Zoom",
		},
		{
			"]]",
			function()
				Snacks.words.jump(1, true)
			end,
			desc = "Próxima referência",
		},
		{
			"[[",
			function()
				Snacks.words.jump(-1, true)
			end,
			desc = "Referência anterior",
		},
		{
			"<leader>tw",
			function()
				if Snacks.words.is_enabled() then
					Snacks.words.disable()
				else
					Snacks.words.enable()
				end
			end,
			desc = "Toggle: Words",
		},
	},
}
