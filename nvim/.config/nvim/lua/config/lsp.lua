local map = vim.keymap.set

map("n", "gra", vim.lsp.buf.code_action, {
	desc = "LSP: Code action",
	silent = true,
})

map("n", "grt", vim.lsp.buf.type_definition, {
	desc = "LSP: Go to type definition",
	silent = true,
})

map("n", "grn", vim.lsp.buf.rename, {
	desc = "LSP: Rename symbol",
	silent = true,
})

map("n", "grr", vim.lsp.buf.references, {
	desc = "LSP: Find references",
	silent = true,
})

map("n", "gri", vim.lsp.buf.implementation, {
	desc = "LSP: Go to implementation",
	silent = true,
})

map("n", "grd", vim.lsp.buf.definition, {
	desc = "LSP: Go to definition",
	silent = true,
})

map("n", "grD", vim.lsp.buf.declaration, {
	desc = "LSP: Go to declaration",
	silent = true,
})

map("n", "grS", vim.lsp.buf.document_symbol, {
	desc = "LSP: Document symbols",
	silent = true,
})

map("n", "grci", vim.lsp.buf.incoming_calls, {
	desc = "LSP: Incoming calls (who calls this)",
	silent = true,
})

map("n", "grco", vim.lsp.buf.outgoing_calls, {
	desc = "LSP: Outgoing calls (what this calls)",
	silent = true,
})

vim.lsp.enable("lua_ls")
vim.lsp.enable("vtsls")
