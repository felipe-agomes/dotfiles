local M = {}

function M.extract_procedure_name()
	local lines = vim.api.nvim_buf_get_lines(0, 0, 1, false)
	local first_line = lines[1]

	if not first_line then
		return
	end

	local regex_procedure_name = [[\v:?(trigger|function|procedure|package body|package)\s+(\w+)]]
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

function M.generate_dbms_output(selection)
	local variables = generate_variables_lines(selection.selected_lines)

	local indent = #(selection.selected_lines[1]:match("^ *"))
	local dbms_lines = { string.rep(" ", indent) .. "dbms_output.put_line(" }

	for _, variable in ipairs(variables) do
		table.insert(dbms_lines, string.rep(" ", indent) .. variable)
	end

	table.insert(dbms_lines, string.rep(" ", indent) .. ");")

	return dbms_lines
end

function M.generate_prc_xcp_debug(selection)
	local procedure_name = M.extract_procedure_name()
	if not procedure_name then
		return
	end

	local variables = generate_variables_lines(selection.selected_lines)
	local indent = #(selection.selected_lines[1]:match("^ *"))
	local prc_lines = { string.rep(" ", indent) .. "prc_xcp_debug('" .. procedure_name .. "', $$plsqlline," }

	for _, variable in ipairs(variables) do
		table.insert(prc_lines, string.rep(" ", indent) .. variable)
	end

	table.insert(prc_lines, string.rep(" ", indent) .. ");")

	return prc_lines
end

return M
