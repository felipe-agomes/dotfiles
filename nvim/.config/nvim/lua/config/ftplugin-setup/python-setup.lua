local M = {}

local function debugpy_python()
	local adapter = vim.fn.exepath("debugpy-adapter")

	if adapter ~= "" then
		return adapter
	end

	return vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
end

function M.setup_dap()
	local dap_python = require("dap-python")

	dap_python.setup(debugpy_python())
	dap_python.test_runner = "pytest"

	vim.keymap.set("n", "<leader>dpt", function()
		dap_python.test_method()
	end, { buffer = true, desc = "Debug: Python test method" })

	vim.keymap.set("n", "<leader>dpc", function()
		dap_python.test_class()
	end, { buffer = true, desc = "Debug: Python test class" })

	vim.keymap.set("v", "<leader>dps", function()
		dap_python.debug_selection()
	end, { buffer = true, desc = "Debug: Python selection" })
end

return M
