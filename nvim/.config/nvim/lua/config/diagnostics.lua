vim.diagnostic.config({
	virtual_text = {
		spacing = 2,
		source = "if_many",
		prefix = "●",
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
})

-- Abrir detalhes manualmente
vim.keymap.set("n", "gl", vim.diagnostic.open_float, {
	desc = "Diagnostics: Show line details",
})
