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
-- Remove

-- Window
vim.keymap.set("n", "<C-l>", "<C-W>l")
vim.keymap.set("n", "<C-h>", "<C-W>h")
vim.keymap.set("n", "<C-k>", "<C-W>k")
vim.keymap.set("n", "<C-j>", "<C-W>j")
-- Window

-- Resize
vim.keymap.set("n", "<C-Left>", function()
	vim.cmd("vertical resize -5")
end)
vim.keymap.set("n", "<C-Right>", function()
	vim.cmd("vertical resize +5")
end)
vim.keymap.set("n", "<C-Down>", function()
	vim.cmd("horizontal resize -5")
end)
vim.keymap.set("n", "<C-Up>", function()
	vim.cmd("horizontal resize +5")
end)
-- Resize

-- General
vim.keymap.set("n", "<Esc>", function()
	vim.cmd("nohlsearch")
end)
-- General
