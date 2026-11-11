return {
	"mfussenegger/nvim-dap-python",
	ft = "python",
	dependencies = { "mfussenegger/nvim-dap" },
	config = function()
		require("config.ftplugin-setup.python-setup").setup_dap()
	end,
}
