local map = vim.keymap.set

map("n", "gra", vim.lsp.buf.code_action, {
	desc = "LSP: Code Action",
	silent = true,
})

map("n", "grt", vim.lsp.buf.type_definition, {
	desc = "LSP: Go to Type Definition",
	silent = true,
})

map("n", "grn", vim.lsp.buf.rename, {
	desc = "LSP: Rename Symbol",
	silent = true,
})

map("n", "grr", vim.lsp.buf.references, {
	desc = "LSP: Find References",
	silent = true,
})

map("n", "gri", vim.lsp.buf.implementation, {
	desc = "LSP: Go to Implementation",
	silent = true,
})

map("n", "grd", vim.lsp.buf.definition, {
	desc = "LSP: Go to Definition",
	silent = true,
})

map("n", "grD", vim.lsp.buf.declaration, {
	desc = "LSP: Go to Declaration",
	silent = true,
})

map("n", "grS", vim.lsp.buf.document_symbol, {
	desc = "LSP: Document Symbols",
	silent = true,
})

map("n", "grl", function()
	local lsp = vim.lsp.get_clients()[1]
	if not lsp then
		return
	end

	print(lsp.name)
end, {
	desc = "LSP: Get Name LSP Active",
	silent = true,
})

map("n", "grci", vim.lsp.buf.incoming_calls, {
	desc = "LSP: Incoming Calls (who calls this)",
	silent = true,
})

map("n", "grco", vim.lsp.buf.outgoing_calls, {
	desc = "LSP: Outgoing Calls (what this calls)",
	silent = true,
})

vim.lsp.enable("lua_ls")
vim.lsp.enable("vtsls")
