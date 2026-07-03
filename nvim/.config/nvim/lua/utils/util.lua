local M = {}

function M.get_line_selection(mode)
	local start_char, end_char = unpack(({
		visual = { "'<", "'>" },
		motion = { "'[", "']" },
	})[mode])
	-- '< marks are only updated when one leaves visual mode.
	-- When calling lua functions directly from a mapping, need to
	-- explicitly exit visual with the escape key to ensure those marks are
	-- accurate.
	vim.cmd("normal! ")

	-- Get the start and the end of the selection
	local start_line, start_col = unpack(vim.fn.getpos(start_char), 2, 3)
	local end_line, end_col = unpack(vim.fn.getpos(end_char), 2, 3)
	local selected_lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
	return {
		start_pos = { start_line, start_col },
		end_pos = { end_line, end_col },
		selected_lines = selected_lines,
	}
end

return M
