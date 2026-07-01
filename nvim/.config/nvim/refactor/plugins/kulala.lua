-- Cliente HTTP REST minimalista (tipo Postman/Insomnia) via arquivos .http.
return { -- TODO: Concluir configuração
	"mistweaverco/kulala.nvim",
	keys = {
		{ "<leader>hs", desc = "Send request" },
		{ "<leader>ha", desc = "Send all requests" },
		{ "<leader>hb", desc = "Open scratchpad" },
	},
	ft = { "http", "rest" },
	opts = {
		global_keymaps = false,
	},
}
