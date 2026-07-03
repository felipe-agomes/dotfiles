-- Yank
vim.keymap.set("n", "<leader>yf", function()
	local filename = vim.fn.expand("%:t")

	vim.fn.setreg("+", filename)
end, { desc = "Yank Filename" })

vim.keymap.set("n", "<leader>yp", function()
	local path = vim.fn.expand("%:p:h")

	vim.fn.setreg("+", path)
end, { desc = "Yank Path" })

vim.keymap.set("n", "<leader>yP", function()
	local path = vim.fn.expand("%:p:h")
	local windows_path = "\\\\wsl.localhost\\Ubuntu-22.04" .. string.gsub(path, "/", "\\")

	vim.fn.setreg("+", windows_path)
end, { desc = "Yank Windows Path in WSL" })
-- Yank

-- Remove
vim.keymap.set("n", "<leader>rc", function()
	local save_cursor = vim.fn.winsaveview()
	vim.cmd([[keeppatterns %s/\r//e]])
	vim.fn.winrestview(save_cursor)
end, { desc = "Remove Carriage Return" })

vim.keymap.set("n", "<leader>rw", function()
	local save_cursor = vim.fn.winsaveview()
	vim.cmd([[keeppatterns %s/\s\+$//e]])
	vim.fn.winrestview(save_cursor)
end, { desc = "Remover trailing whitespaces" })

vim.keymap.set("n", "<leader>rh", function()
	vim.cmd("nohlsearch")
end)
-- Remove
