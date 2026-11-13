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
			-- Evita statusline dentro do float do oil e dos pickers.
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
					-- Remove os colchetes: [2/10] -> 2/10.
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
