return {
	"stevearc/oil.nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		-- O snacks.explorer já é o file explorer padrão (e substitui o netrw).
		-- O oil fica acessível por keymap para editar o filesystem como buffer.
		default_file_explorer = false,
		columns = { "icon" },
		view_options = { show_hidden = true },
		keymaps = {
			-- Mantém <C-h>/<C-l> para navegação entre janelas.
			["<C-h>"] = false,
			["<C-l>"] = false,
		},
	},
	config = function(_, opts)
		require("oil").setup(opts)

		vim.keymap.set("n", "<leader>E", "<cmd>Oil<cr>", { desc = "File Explorer (Oil)" })
	end,
}
