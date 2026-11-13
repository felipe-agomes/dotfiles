vim.treesitter.language.register("xml", "xhtml")

vim.bo.commentstring = "<!-- %s -->"
vim.bo.comments = "s1:<!--,m:    ,e:-->"
vim.bo.matchpairs = vim.bo.matchpairs .. ",<:>"

local buf = vim.api.nvim_get_current_buf()

vim.schedule(function()
	if vim.api.nvim_buf_is_valid(buf) then
		vim.bo[buf].omnifunc = ""
	end
end)
