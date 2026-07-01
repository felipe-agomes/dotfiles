-- Renderiza elementos Markdown (tabelas, headers, checkbox) visualmente no editor.
return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {},
}
