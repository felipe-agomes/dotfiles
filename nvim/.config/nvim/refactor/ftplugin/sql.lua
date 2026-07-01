local function extract_procedure_name()
	local lines = vim.api.nvim_buf_get_lines(0, 0, 1, false)
	local first_line = lines[1]

	if not first_line then
		return
	end

	local regex_procedure_name = [[\v:?(trigger|function|procedure|body|package)\s+(\w+)]]

	local matches = vim.fn.matchlist(first_line, regex_procedure_name)

	if matches[3] then
		return matches[3]
	end
end

local function extract_variables(lines)
	local variables = {}
	for _, line in ipairs(lines) do
		local match = vim.fn.matchlist(line, [[\v^\s*(\S+)(\s|$)]])

		if match and match[2] then
			table.insert(variables, match[2])
		end
	end

	return variables
end

local function generate_variables_lines(lines)
	local variables = extract_variables(lines)

	local var_lines = {}
	for i, variable in ipairs(variables) do
		local line = "    '" .. variable .. ": ' || " .. variable .. " || CHR(10)"

		if i < #variables then
			line = line .. " ||"
		end

		table.insert(var_lines, line)
	end

	return var_lines
end

local function generate_dbms_output(lines)
	local variables = generate_variables_lines(lines)

	local dbms_lines = { "dbms_output.put_line(" }

	for _, variable in ipairs(variables) do
		table.insert(dbms_lines, variable)
	end

	table.insert(dbms_lines, ");")

	return dbms_lines
end

local function generate_prc_xcp_debug(lines)
	local procedure_name = extract_procedure_name()

	if not procedure_name then
		return
	end

	local variables = generate_variables_lines(lines)

	local prc_lines = { "prc_xcp_debug('" .. procedure_name .. "', $$plsqlline," }

	for _, variable in ipairs(variables) do
		table.insert(prc_lines, variable)
	end

	table.insert(prc_lines, ");")

	return prc_lines
end

vim.keymap.set("v", "<leader>dp", function()
	vim.cmd("noau normal! \27")

	local start_row = vim.api.nvim_buf_get_mark(0, "<")[1] - 1
	local end_row = vim.api.nvim_buf_get_mark(0, ">")[1]

	local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row, false)

	local prc_xcp_debug = generate_prc_xcp_debug(lines)

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

	local dbms_debug = generate_dbms_output(lines)

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

	local prc_xcp_debug = generate_prc_xcp_debug(lines)

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

	local dbms_debug = generate_dbms_output(lines)

	if not dbms_debug then
		return
	end

	vim.api.nvim_buf_set_lines(0, start_row, end_row, false, dbms_debug)
end, { buffer = true, desc = "dbms_output replace" })

vim.keymap.set("n", "<leader>yt", function()
	local procedure_name = extract_procedure_name()

	vim.fn.setreg("+", procedure_name)
end, { buffer = true, desc = "Yank Procedure Name" })
