local M = {}

local function wrap_long_lines()
	local cc = vim.wo.colorcolumn
	if cc == "" then
		vim.notify("colorcolumn não está definido", vim.log.levels.WARN)
		return
	end

	local limit = tonumber(cc:match("%d+"))
	if not limit then
		vim.notify("Não consegui extrair um número do colorcolumn: " .. cc, vim.log.levels.WARN)
		return
	end

	local i = 1
	while true do
		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		if i > #lines then
			break
		end

		local line = lines[i]
		if #line > limit then
			local pos
			for p = limit, 1, -1 do
				if line:sub(p, p) == " " then
					pos = p
					break
				end
			end

			pos = pos or limit

			local before = line:sub(1, pos - 1)
			local after = line:sub(pos + 1)

			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { before, after })
		else
			i = i + 1
		end
	end
end

function M.setup()
	vim.opt_local.colorcolumn = "120"

	vim.keymap.set("n", "grf", function()
		wrap_long_lines()
	end, { desc = "Format Buffer", buffer = true })
end

return M
