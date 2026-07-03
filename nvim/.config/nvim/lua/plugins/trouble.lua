return {
	"folke/trouble.nvim",
	opts = {},
	cmd = "Trouble",
	keys = {
		{
			"<leader>ci",
			"<cmd>Trouble lsp_implementations<cr>",
			desc = "LSP: Go to implementation",
		},
		{
			"<leader>cd",
			"<cmd>Trouble lsp_definitions<cr>",
			desc = "LSP: Go to type definition",
		},
		{
			"<leader>cD",
			"<cmd>Trouble lsp_declarations<cr>",
			desc = "LSP: Go to declaration",
		},
		{
			"<leader>cl",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "LSP: References / Definitions / Implementations",
		},
		{
			"<leader>cS",
			"<cmd>Trouble symbols toggle focus=false win.position=right<cr>",
			desc = "LSP: Document symbols",
		},
		{
			"<leader>cr",
			"<cmd>Trouble lsp_references toggle focus=false win.position=right<cr>",
			desc = "LSP: Find references",
		},
		{
			"<leader>cx",
			"<cmd>Trouble lsp_command toggle focus=false<cr>",
			desc = "LSP: Code Lens / Commands",
		},
		{
			"<leader>cci",
			"<cmd>Trouble lsp_incoming_calls toggle focus=false win.position=right<cr>",
			desc = "LSP: Incoming calls (who calls this)",
		},
		{
			"<leader>cco",
			"<cmd>Trouble lsp_outgoing_calls toggle focus=false win.position=right<cr>",
			desc = "LSP: Outgoing calls (what this calls)",
		},
		{
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle focus=false<cr>",
			desc = "Workspace Diagnostics (all errors)",
		},
		{
			"<leader>xd",
			"<cmd>Trouble diagnostics toggle filter.buf=0 focus=false<cr>",
			desc = "Document Diagnostics (current file)",
		},
		{
			"<leader>xq",
			"<cmd>Trouble qflist toggle focus=false<cr>",
			desc = "Quickfix List",
		},
		{
			"<leader>xl",
			"<cmd>Trouble loclist toggle focus=false<cr>",
			desc = "Location List",
		},
	},
}
