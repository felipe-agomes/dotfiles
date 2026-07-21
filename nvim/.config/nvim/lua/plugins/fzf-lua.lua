return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	---@module "fzf-lua"
	---@type fzf-lua.Config|{}
	---@diagnostic disable: missing-fields
	opts = {
		keymap = {
			builtin = {
				["<A-l>"] = "focus-preview",
			},
		},
	},
	---@diagnostic enable: missing-fields
	config = function(_, opts)
		local fzf_lua = require("fzf-lua")

		fzf_lua.setup(opts)

		fzf_lua.register_ui_select()

		-- SEARCH
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

		vim.keymap.set("n", "<leader>sH", function()
			fzf_lua.highlights()
		end, { desc = "Search: Highlights" })

		vim.keymap.set("n", "<leader>sh", function()
			fzf_lua.helptags()
		end, { desc = "Search: Help Tags" })

		vim.keymap.set("n", "<leader>sc", function()
			fzf_lua.commands()
		end, { desc = "Search: Commands" })

		vim.keymap.set("n", "<leader>sC", function()
			fzf_lua.command_history()
		end, { desc = "Search: Command History" })

		vim.keymap.set("n", "<leader>sS", function()
			fzf_lua.command_history()
		end, { desc = "Search: Search History" })

		vim.keymap.set("n", "<leader>sm", function()
			fzf_lua.marks()
		end, { desc = "Search: Marks" })

		vim.keymap.set("n", "<leader>sj", function()
			fzf_lua.jumps()
		end, { desc = "Search: Jumps" })

		vim.keymap.set("n", "<leader>sa", function()
			fzf_lua.autocmds()
		end, { desc = "Search: Autocmds" })

		vim.keymap.set("n", "<leader>so", function()
			fzf_lua.nvim_options()
		end, { desc = "Search: Neovim Options" })

		vim.keymap.set("n", "<leader>sk", function()
			fzf_lua.keymaps()
		end, { desc = "Search: Keymaps" })

		vim.keymap.set("n", "<leader>su", function()
			fzf_lua.undotree()
		end, { desc = "Search: Undotree History" })

		vim.keymap.set("n", "<leader>sd", function()
			fzf_lua.live_grep({ cwd = vim.fn.expand("%:p:h") })
		end, { desc = "Search: Grep (Current Dir)" })

		vim.keymap.set("n", "<leader>sr", function()
			fzf_lua.resume()
		end, { desc = "Search: Resume" })

		vim.keymap.set("n", "<leader>sM", function()
			fzf_lua.manpages()
		end, { desc = "Search: Man mapges" })
		-- SEARCH

		-- FIND
		vim.keymap.set("n", "<leader><space>", function()
			fzf_lua.files()
		end, { desc = "File: Files (Project)" })

		vim.keymap.set("n", "<leader>fb", function()
			fzf_lua.buffers()
		end, { desc = "Find: Buffers" })

		vim.keymap.set("n", "<leader>fp", function()
			fzf_lua.files({ cwd = vim.fn.stdpath("config") .. "/lua/plugins" })
		end, { desc = "Find: Neovim Plugins" })

		vim.keymap.set("n", "<leader>fc", function()
			fzf_lua.files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "Find: Neovim Root" })

		vim.keymap.set("n", "<leader>fd", function()
			fzf_lua.files({ cwd = vim.fn.expand("%:p:h") })
		end, { desc = "Find: Files (Current Dir)" })
		-- FIND

		-- UI
		vim.keymap.set("n", "<leader>uc", function()
			fzf_lua.colorschemes()
		end, { desc = "UI: Colorschemes" })
		-- UI
	end,
}
