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
		float = {
			padding = 2,
			max_width = 0.9,
			max_height = 0.9,
			border = "rounded",
		},
		keymaps = {
			-- Mantém <C-h>/<C-l> para navegação entre janelas.
			["<C-h>"] = false,
			["<C-l>"] = false,
			-- Fechar com q ou <Esc>.
			["q"] = { "actions.close", mode = "n" },
			["<Esc>"] = { "actions.close", mode = "n" },
		},
	},
	config = function(_, opts)
		local oil = require("oil")
		oil.setup(opts)

		vim.keymap.set("n", "<leader>E", function()
			local dir = vim.fn.expand("%:p:h")

			if dir == "" or vim.fn.isdirectory(dir) == 0 then
				dir = vim.fn.getcwd()
			end

			oil.toggle_float(dir)
		end, { desc = "File Explorer (Oil float)" })
	end,
}
