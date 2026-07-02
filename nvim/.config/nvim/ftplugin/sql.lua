vim.opt.shiftwidth = 4

local admrh = require("utils.admrh")

vim.keymap.set("v", "<leader>dp", function()
	vim.cmd("noau normal! \27")

	local start_row = vim.api.nvim_buf_get_mark(0, "<")[1] - 1
	local end_row = vim.api.nvim_buf_get_mark(0, ">")[1]

	local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row, false)

	local prc_xcp_debug = admrh.generate_prc_xcp_debug(lines)

	if not prc_xcp_debug then
		return
	end

	vim.api.nvim_buf_set_lines(0, end_row, end_row, false, prc_xcp_debug)
end, { buffer = true, desc = "prc_xcp_debug concat" })

vim.keymap.set("v", "<leader>dd", function()
	vim.cmd("noau normal! \27")

	local start_row = vim.api.nvim_buf_get_mark(0, "<")[1] - 1
	local end_row = vim.api.nvim_buf_get_mark(0, ">")[1]

	local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row, false)

	local dbms_debug = admrh.generate_dbms_output(lines)

	if not dbms_debug then
		return
	end

	vim.api.nvim_buf_set_lines(0, end_row, end_row, false, dbms_debug)
end, { buffer = true, desc = "dbms_output concat" })

vim.keymap.set("v", "<leader>dP", function()
	vim.cmd("noau normal! \27")

	local start_row = vim.api.nvim_buf_get_mark(0, "<")[1] - 1
	local end_row = vim.api.nvim_buf_get_mark(0, ">")[1]

	local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row, false)

	local prc_xcp_debug = admrh.generate_prc_xcp_debug(lines)

	if not prc_xcp_debug then
		return
	end

	vim.api.nvim_buf_set_lines(0, start_row, end_row, false, prc_xcp_debug)
end, { buffer = true, desc = "prc_xcp_debug replace" })

vim.keymap.set("v", "<leader>dD", function()
	vim.cmd("noau normal! \27")

	local start_row = vim.api.nvim_buf_get_mark(0, "<")[1] - 1
	local end_row = vim.api.nvim_buf_get_mark(0, ">")[1]

	local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row, false)

	local dbms_debug = admrh.generate_dbms_output(lines)

	if not dbms_debug then
		return
	end

	vim.api.nvim_buf_set_lines(0, start_row, end_row, false, dbms_debug)
end, { buffer = true, desc = "dbms_output replace" })

vim.keymap.set("n", "<leader>yt", function()
	local procedure_name = admrh.extract_procedure_name()

	vim.fn.setreg("+", procedure_name)
end, { buffer = true, desc = "Yank Procedure Name" })
