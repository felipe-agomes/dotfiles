---@diagnostic disable: undefined-field
return {
	"saghen/blink.cmp",
	dependencies = {
		"saghen/blink.lib",
		"rafamadriz/friendly-snippets",
	},

	build = function()
		require("blink.cmp").build():pwait()
	end,

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		cmdline = {
			keymap = {
				preset = "super-tab",
			},
		},
		keymap = { preset = "super-tab" },
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			per_filetype = {
				sql = { "snippets", "buffer" },
				plsql = { "snippets", "buffer" },
			},
		},
	},
}
