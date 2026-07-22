local M = {}

function M.setup()
	vim.bo.shiftwidth = 4

	local admrh = require("utils.admrh")

	vim.keymap.set("v", "<leader>dp", function()
		local selection = require("utils.util").get_line_selection("visual")

		local prc_xcp_debug = admrh.generate_prc_xcp_debug(selection)

		if not prc_xcp_debug then
			return
		end

		vim.api.nvim_buf_set_lines(0, selection.end_pos[1], selection.end_pos[1], false, prc_xcp_debug)
	end, { buffer = true, desc = "prc_xcp_debug concat" })

	vim.keymap.set("v", "<leader>dd", function()
		local selection = require("utils.util").get_line_selection("visual")

		local dbms_debug = admrh.generate_dbms_output(selection)

		if not dbms_debug then
			return
		end

		vim.api.nvim_buf_set_lines(0, selection.end_pos[1], selection.end_pos[1], false, dbms_debug)
	end, { buffer = true, desc = "dbms_output concat" })

	vim.keymap.set("v", "<leader>dP", function()
		local selection = require("utils.util").get_line_selection("visual")

		local prc_xcp_debug = admrh.generate_prc_xcp_debug(selection)

		if not prc_xcp_debug then
			return
		end

		vim.api.nvim_buf_set_lines(0, selection.start_pos[1] - 1, selection.end_pos[1], false, prc_xcp_debug)
	end, { buffer = true, desc = "prc_xcp_debug replace" })

	vim.keymap.set("v", "<leader>dD", function()
		local selection = require("utils.util").get_line_selection("visual")

		local dbms_debug = admrh.generate_dbms_output(selection)

		if not dbms_debug then
			return
		end

		vim.api.nvim_buf_set_lines(0, selection.start_pos[1] - 1, selection.end_pos[1], false, dbms_debug)
	end, { buffer = true, desc = "dbms_output replace" })

	vim.keymap.set("n", "<leader>yt", function()
		local procedure_name = admrh.extract_procedure_name()

		vim.fn.setreg("+", procedure_name)
	end, { buffer = true, desc = "Yank Procedure Name" })
end

return M
