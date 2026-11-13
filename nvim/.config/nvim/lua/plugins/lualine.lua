local function recording()
	local reg = vim.fn.reg_recording()
	if reg == "" then
		return ""
	end
	return "● REC @" .. reg
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			theme = "auto",
			disabled_filetypes = {
				statusline = { "oil", "snacks_picker_list", "snacks_explorer", "help" },
			},
		},
		sections = {
			lualine_x = {
				"encoding",
				"fileformat",
				"filetype",
			},
			lualine_y = {
				{
					"searchcount",
					fmt = function(str)
						return (str:gsub("[%[%]]", ""))
					end,
				},
				{
					"selectioncount",
					fmt = function(str)
						return str ~= "" and ("Sel " .. str) or ""
					end,
				},
				{
					recording,
					color = { fg = "#ff5555", gui = "bold" },
					padding = { left = 1, right = 1 },
				},
				{ "lsp_status", show_name = false },
			},
			lualine_z = { "location" },
		},
	},
}
