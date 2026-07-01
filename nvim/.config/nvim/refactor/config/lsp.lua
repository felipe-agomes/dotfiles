local M = {}

M.on_attach = function(_, bufnr)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Goto Definition", buffer = bufnr })
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: Goto Declaration", buffer = bufnr })
	vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "LSP: Goto Implementation", buffer = bufnr })
	vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { desc = "LSP: Goto Type Definition", buffer = bufnr })
	vim.keymap.set(
		"n",
		"<leader>cS",
		vim.lsp.buf.references,
		{ desc = "LSP: References", buffer = bufnr, nowait = true }
	)
	vim.keymap.set(
		"n",
		"<leader>cs",
		vim.lsp.buf.document_symbol,
		{ desc = "LSP: Symbols", buffer = bufnr, nowait = true }
	)
	vim.keymap.set(
		"n",
		"<leader>ci",
		vim.lsp.buf.incoming_calls,
		{ desc = "LSP: Calls Incoming", buffer = bufnr, nowait = true }
	)
	vim.keymap.set(
		"n",
		"<leader>co",
		vim.lsp.buf.outgoing_calls,
		{ desc = "LSP: Calls Outgoing", buffer = bufnr, nowait = true }
	)
	vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "LSP: Rename Symbol", buffer = bufnr })
	vim.keymap.set("n", "<leader>cy", vim.lsp.buf.typehierarchy, { desc = "LSP: Type Hierarchy", buffer = bufnr })
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code Action", buffer = bufnr })
	vim.keymap.set("n", "<leader>cA", function()
		vim.lsp.buf.code_action({
			context = {
				only = { "source" },
				diagnostics = vim.diagnostic.get(0),
			},
		})
	end, { desc = "LSP: Source Action", buffer = bufnr })
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover", buffer = bufnr })
	vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { desc = "LSP: Signature Help", buffer = bufnr })
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp = pcall(require, "cmp_nvim_lsp")
if ok then
	M.capabilities = cmp.default_capabilities(M.capabilities)
end

vim.lsp.config("sqlls", {
	cmd = { "sqls" },
	filetypes = { "sql" },
	single_file_support = true,
	capabilities = M.capabilities,
	on_attach = M.on_attach,
})

vim.lsp.config("yamlls", {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yml", "yaml" },
	capabilities = M.capabilities,
	on_attach = M.on_attach,
})

vim.lsp.config("luals", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	capabilities = M.capabilities,
	on_attach = M.on_attach,
})

vim.lsp.config("vtsls", {
	cmd = { "vtsls", "--stdio" },
	filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
	single_file_support = true,
	capabilities = M.capabilities,
	on_attach = M.on_attach,
})

vim.lsp.config("xmlls", {
	cmd = { "lemminx" },
	filetypes = { "xml", "xhtml" },
	single_file_support = true,
	capabilities = M.capabilities,
	on_attach = M.on_attach,
})

vim.lsp.config("jsonls", {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json" },
	single_file_support = true,
	capabilities = M.capabilities,
	on_attach = M.on_attach,
})

vim.lsp.config("dartls", {
	cmd = { "dcm", "start-server", "--client=neovim" },
	filetypes = { "dart" },
	root_markers = { "pubspec.yaml" },
	capabilities = M.capabilities,
	on_attach = M.on_attach,
})

vim.lsp.config("bashls", {
	cmd = { "bash-language-server", "start" },
	filetypes = { "bash", "sh", "zsh" },
})

vim.lsp.config("markdownls", {
	cmd = { "marksman" },
	filetypes = { "markdown" },
	on_attach = M.on_attach,
})

vim.lsp.enable({
	"sqlls",
	"luals",
	"yamlls",
	"vtsls",
	"xmlls",
	"jsonls",
	"dartls",
	"bashls",
	"markdownls",
})

return M
