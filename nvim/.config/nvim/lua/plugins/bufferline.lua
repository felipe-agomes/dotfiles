local function filename(buf)
	return vim.api.nvim_buf_get_name(buf.id)
end

local test_patterns = {
	"^test_.*%.py$",
	".*_test%.py$",
	"Tests?%.java$",
	"^Test.*%.java$",
	"%.test%.[cm]?[jt]sx?$",
	"%.spec%.[cm]?[jt]sx?$",
}

local function is_test(buf)
	local path = filename(buf)
	if path:match("/__tests__/") or path:match("/src/test/") then
		return true
	end
	local name = path:match("([^/\\]+)$") or path
	for _, pattern in ipairs(test_patterns) do
		if name:match(pattern) then
			return true
		end
	end
	return false
end

return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	opts = {
		options = {
			themable = true,
			diagnostics = "nvim_lsp",
			diagnostics_update_on_event = true,
			diagnostics_indicator = function(count)
				return "(" .. count .. ")"
			end,
			groups = {
				items = {
					{
						name = "Docs",
						icon = "󰈙 ",
						priority = 2,
						matcher = function(buf)
							local name = filename(buf)
							return name:match("%.md$") ~= nil or name:match("%.txt$") ~= nil
						end,
					},
					{
						name = "Tests",
						icon = "󰙨 ",
						priority = 1,
						matcher = is_test,
					},
				},
			},
		},
	},
	config = function(_, opts)
		local bufferline = require("bufferline")
		bufferline.setup(opts)

		vim.keymap.set("n", "<leader>bd", function()
			local buf = vim.api.nvim_get_current_buf()
			vim.cmd("BufferLineCycleNext")
			vim.api.nvim_buf_delete(buf, { force = true })
		end, { desc = "Buffer: Delete current" })

		vim.keymap.set("n", "<leader>bo", function()
			vim.cmd("BufferLineCloseOthers")
		end, { desc = "Buffer: Delete others" })

		vim.keymap.set("n", "<leader>bl", function()
			vim.cmd("BufferLineCloseLeft")
		end, { desc = "Buffer: Delete to the Left" })

		vim.keymap.set("n", "<leader>br", function()
			vim.cmd("BufferLineCloseRight")
		end, { desc = "Buffer: Delete to the Right" })

		vim.keymap.set("n", "H", function()
			vim.cmd("BufferLineCyclePrev")
		end)

		vim.keymap.set("n", "L", function()
			vim.cmd("BufferLineCycleNext")
		end)

		vim.keymap.set("n", "[B", function()
			vim.cmd("BufferLineMovePrev")
		end, { desc = "Buffer: Move prev" })

		vim.keymap.set("n", "]B", function()
			vim.cmd("BufferLineMoveNext")
		end, { desc = "Buffer: Move next" })

		vim.keymap.set("n", "<leader>tp", function()
			vim.cmd("BufferLineTogglePin")
		end, { desc = "Toggle: Pin" })

		vim.keymap.set("n", "<leader>bP", function()
			vim.cmd("BufferLinePick")
		end, { desc = "Buffer: Pick" })

		vim.keymap.set("n", "<leader>bp", function()
			local groups = require("bufferline.groups")
			local elements = require("bufferline").get_elements().elements
			local pinned = vim.tbl_filter(function(element)
				return groups._is_pinned({ id = element.id })
			end, elements)
			if #pinned == 0 then
				return vim.notify("No pinned buffers", vim.log.levels.INFO)
			end
			vim.ui.select(pinned, {
				prompt = "Pinned buffers",
				format_item = function(item)
					return item.name
				end,
			}, function(choice)
				if choice then
					vim.api.nvim_set_current_buf(choice.id)
				end
			end)
		end, { desc = "Buffer: Pinned" })
	end,
}
