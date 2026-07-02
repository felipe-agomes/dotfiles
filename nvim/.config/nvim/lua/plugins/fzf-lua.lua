return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	---@module "fzf-lua"
	---@type fzf-lua.Config|{}
	---@diagnostic disable: missing-fields
	opts = {},
	---@diagnostic enable: missing-fields
	config = function(_, opts)
		local fzf_lua = require("fzf-lua")

		fzf_lua.setup(opts)

		vim.keymap.set("n", "<leader><space>", function()
			fzf_lua.files()
		end, { desc = "File: Files (Project)" })

		vim.keymap.set("n", "<leader>st", function()
			fzf_lua.treesitter()
		end, { desc = "Search: Treesitter Symbols" })

		vim.keymap.set("n", "<leader>sg", function()
			fzf_lua.live_grep()
		end, { desc = "Search: Grep (Project)" })

		vim.keymap.set("n", "<leader>sw", function()
			fzf_lua.grep_cword()
		end, { desc = "Search: Word Under Cursor" })

		vim.keymap.set("n", "<leader>sW", function()
			fzf_lua.grep_cWORD()
		end, { desc = "Search: WORD Under Cursor" })

		vim.keymap.set("v", "<leader>sv", function()
			fzf_lua.grep_visual()
		end, { desc = "Search: Visual Selection" })

		vim.keymap.set("n", "<leader>sG", function()
			fzf_lua.live_grep_glob()
		end, { desc = "Search: Grep with Glob Filter" })
	end,
}
