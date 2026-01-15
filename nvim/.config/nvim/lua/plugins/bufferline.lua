-- Barra de abas/buffers no topo da janela (estilo VSCode).
return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-mini/mini.icons",
	opts = {
		options = {
			mode = "buffers",
			themable = true,
			numbers = "none",
			right_mouse_command = false,
			left_mouse_command = false,
			middle_mouse_command = false,
			show_buffer_close_icons = true,
			show_close_icon = true,
			show_tab_indicators = true,
			show_duplicate_prefix = true,
			separator_style = "thin", -- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
			hover = {
				enabled = true,
				delay = 50,
				reveal = { "close" },
			},
			color_icons = true,
			get_element_icon = function(element)
				local icon, hl = require("mini.icons").get("filetype", element.filetype)
				return icon, hl
			end,
			diagnostics_indicator = function(count, level, diagnostics_dict, context)
				local s = " "
				for e, n in pairs(diagnostics_dict) do
					local sym = e == "error" and " " or (e == "warning" and " " or " ")
					s = s .. n .. sym
				end
				return s
			end,
		},
	},
}
