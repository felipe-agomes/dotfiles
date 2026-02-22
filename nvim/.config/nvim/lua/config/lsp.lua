local on_attach = function(_, bufnr)
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
		"<leader>ci",
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
	vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { desc = "LSP: Signature Hellp", buffer = bufnr })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp = pcall(require, "cmp_nvim_lsp")
if ok then
	capabilities = cmp.default_capabilities(capabilities)
end

local root_dir = vim.fs.root(0, {
	"pom.xml",
	"build.gradle",
	"build.gradle.kts",
	"settings.gradle",
	"settings.gradle.kts",
	".git",
})

local workspace_dir = vim.fn.stdpath("data") .. "/jdtls/workspaces/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

vim.lsp.config("java_ls", {
	cmd = {
		"jdtls",
		"-data",
		workspace_dir,
	},
	root_dir = root_dir,
	filetypes = { "java" },
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.lsp.config("sql_ls", {
	cmd = { "sqls" },
	filetypes = { "sql" },
	single_file_support = true,
	on_attach = on_attach,
})

vim.lsp.config("yaml_ls", {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yml", "yaml" },
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.lsp.config("vtsls", {
	cmd = { "vtsls", "--stdio" },
	filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
	single_file_support = true,
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.lsp.config("xml_ls", {
	cmd = { "lemminx" },
	filetypes = { "xml" },
	single_file_support = true,
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.lsp.config("json_ls", {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json" },
	single_file_support = true,
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.lsp.config("dart_ls", {
	cmd = { "dcm", "start-server", "--client=neovim" },
	filetypes = { "dart" },
	root_markers = { "pubspec.yaml" },
	capabilities = capabilities,
	on_attach = on_attach,
})

vim.lsp.config("sh_ls", {
	cmd = { "bash-language-server", "start" },
	filetypes = { "bash", "sh", "zsh" },
})

vim.lsp.enable({
	"java_ls",
	"sql_ls",
	"lua_ls",
	"yaml_ls",
	"vtsls",
	"xml_ls",
	"json_ls",
	"dart_ls",
	"sh_ls",
})
