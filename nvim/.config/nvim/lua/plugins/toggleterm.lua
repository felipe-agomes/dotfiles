return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = {
		open_mapping = [[<c-\>]],
		terminal_mappings = true,
	},
	config = function(_, opts)
		local toggleterm = require("toggleterm")
		toggleterm.setup(opts)
		local trim_spaces = true

		vim.keymap.set("n", "<leader>ts", function()
			vim.cmd("TermSelect")
		end, { desc = "Terminal: Select" })

		vim.keymap.set("n", "<leader>tn", function()
			vim.cmd("ToggleTermSetName")
		end, { desc = "Terminal: Set Name" })

		vim.keymap.set("n", "<leader>t1", function()
			vim.cmd("1ToggleTerm")
		end, { desc = "Terminal 1" })
		vim.keymap.set("n", "<leader>t2", function()
			vim.cmd("2ToggleTerm")
		end, { desc = "Terminal 2" })
		vim.keymap.set("n", "<leader>t3", function()
			vim.cmd("3ToggleTerm")
		end, { desc = "Terminal 3" })

		vim.keymap.set("v", "<leader>tl", function()
			toggleterm.send_lines_to_terminal("visual_lines", trim_spaces, { args = vim.v.count })
		end, { desc = "Terminal: Send Visual Lines" })

		vim.keymap.set("v", "<leader>tv", function()
			toggleterm.send_lines_to_terminal("visual_selection", trim_spaces, { args = vim.v.count })
		end, { desc = "Terminal: Send Visual Selection" })

		vim.keymap.set("n", "<leader>gg", function()
			local Terminal = require("toggleterm.terminal").Terminal
			local lazygit = Terminal:new({
				cmd = "lazygit",
				dir = "git_dir",
				direction = "float",
				float_opts = {
					border = "double",
				},
				-- function to run on opening the terminal
				on_open = function(term)
					vim.cmd("startinsert!")
					vim.keymap.set("n", "q", "<cmd>close<CR>", { silent = true, buf = term.bufnr })
				end,
				-- function to run on closing the terminal
				on_close = function(term)
					vim.cmd("startinsert!")
				end,
			})

			lazygit:toggle()
		end, { silent = true, desc = "LazyGit" })

		vim.api.nvim_create_autocmd("TermOpen", {
			pattern = "term://*",
			callback = function(args)
				local map_opts = { buffer = args.buf }
				vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], map_opts)
				vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], map_opts)
				vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], map_opts)
				vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], map_opts)
				vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], map_opts)
				vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], map_opts)
			end,
		})
	end,
}
