return {
	"lewis6991/gitsigns.nvim",
	opts = {
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map("n", "]g", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]g", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end, { desc = "Next Git hunk" })

			map("n", "[g", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[g", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end, { desc = "Previous Git hunk" })

			-- Actions
			map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Git stage hunk" })
			map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Git reset hunk" })

			map("v", "<leader>gs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Git stage selection" })

			map("v", "<leader>gr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Git reset selection" })

			map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Git stage buffer" })
			map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Git reset buffer" })
			map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Git preview hunk" })
			map("n", "<leader>gi", gitsigns.preview_hunk_inline, { desc = "Git preview hunk inline" })

			map("n", "<leader>gb", function()
				gitsigns.blame_line({ full = true })
			end, { desc = "Git blame line" })

			map("n", "<leader>gd", gitsigns.diffthis, { desc = "Git diff against index" })

			map("n", "<leader>gD", function()
				gitsigns.diffthis("~")
			end, { desc = "Git diff against HEAD~" })

			map("n", "<leader>gQ", function()
				gitsigns.setqflist("all")
			end, { desc = "Git hunks to quickfix (all)" })

			map("n", "<leader>gq", gitsigns.setqflist, { desc = "Git hunks to quickfix" })

			-- Toggles
			map("n", "<leader>gtb", gitsigns.toggle_current_line_blame, {
				desc = "Toggle current line blame",
			})

			map("n", "<leader>gtw", gitsigns.toggle_word_diff, {
				desc = "Toggle word diff",
			})

			-- Text object
			map({ "o", "x" }, "gih", gitsigns.select_hunk, {
				desc = "Select Git hunk",
			})
		end,
	},
}
