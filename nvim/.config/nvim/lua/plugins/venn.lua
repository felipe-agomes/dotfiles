return {
	"jbyuki/venn.nvim",
	config = function()
		local function toggle_venn()
			if not vim.b.venn_enabled then
				vim.b.venn_enabled = true
        vim.o.virtualedit = "all"

				vim.keymap.set("n", "J", "<C-v>j:VBox<CR>", { buffer = true, silent = true })
				vim.keymap.set("n", "K", "<C-v>k:VBox<CR>", { buffer = true, silent = true })
				vim.keymap.set("n", "L", "<C-v>l:VBox<CR>", { buffer = true, silent = true })
				vim.keymap.set("n", "H", "<C-v>h:VBox<CR>", { buffer = true, silent = true })
				vim.keymap.set("v", "f", ":VBox<CR>", { buffer = true, silent = true })

				print("Venn Diagram: ON")
			else
        vim.o.virtualedit = "block"

				vim.keymap.del("n", "J", { buffer = true })
				vim.keymap.del("n", "K", { buffer = true })
				vim.keymap.del("n", "L", { buffer = true })
				vim.keymap.del("n", "H", { buffer = true })
				vim.keymap.del("v", "f", { buffer = true })

				vim.b.venn_enabled = nil

				print("Venn Diagram: OFF")
			end
		end

		vim.keymap.set("n", "<leader>tv", toggle_venn, { desc = "Toggle: Venn Diagram" })
	end,
}
