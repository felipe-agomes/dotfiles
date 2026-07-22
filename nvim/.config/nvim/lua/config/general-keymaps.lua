local map = vim.keymap.set

-- Yank
map("n", "<leader>yf", function()
	local filename = vim.fn.expand("%:t")

	vim.fn.setreg("+", filename)
end, { desc = "Yank Filename" })

map("n", "<leader>yp", function()
	local path = vim.fn.expand("%:p")

	vim.fn.setreg("+", path)
end, { desc = "Yank Path" })

map("n", "<leader>yP", function()
	local path = vim.fn.expand("%:p")
	local windows_path = "\\\\wsl.localhost\\Ubuntu-22.04" .. string.gsub(path, "/", "\\")

	vim.fn.setreg("+", windows_path)
end, { desc = "Yank Windows Path in WSL" })
-- Yank

-- Remove
map("n", "<leader>rc", function()
	local save_cursor = vim.fn.winsaveview()
	vim.cmd([[keeppatterns %s/\r//e]])
	vim.fn.winrestview(save_cursor)
end, { desc = "Remove Carriage Return" })

map("n", "<leader>rw", function()
	local save_cursor = vim.fn.winsaveview()
	vim.cmd([[keeppatterns %s/\s\+$//e]])
	vim.fn.winrestview(save_cursor)
end, { desc = "Remover trailing whitespaces" })
-- Remove

-- Window
map("n", "<C-l>", "<C-W>l")
map("n", "<C-h>", "<C-W>h")
map("n", "<C-k>", "<C-W>k")
map("n", "<C-j>", "<C-W>j")
-- Window

-- Resize
map("n", "<C-Left>", function()
	vim.cmd("vertical resize -5")
end)
map("n", "<C-Right>", function()
	vim.cmd("vertical resize +5")
end)
map("n", "<C-Down>", function()
	vim.cmd("horizontal resize -5")
end)
map("n", "<C-Up>", function()
	vim.cmd("horizontal resize +5")
end)
-- Resize

-- TOGGLE
map("n", "<leader>te", function()
	if vim.o.virtualedit == "all" then
		vim.o.virtualedit = "block"

		print("Virtualedit: OFF")
	else
		vim.o.virtualedit = "all"

		print("Virtualedit: ON")
	end
end, { desc = "Toggle: Virtualedit" })
map("n", "<leader>tc", function()
	if vim.wo.colorcolumn ~= "" then
		vim.wo.colorcolumn = ""

		print("Colorcolumn: OFF")
	else
		vim.wo.colorcolumn = "120"

		print("Colorcolumn: ON")
	end
end, { desc = "Toggle: Colorcolumn" })
-- TOGGLE

-- General
map("n", "<Esc>", function()
	vim.cmd("nohlsearch")
end)
map("n", "<C-z>", "<Nop>")
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down + center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up + center" })
map("n", "n", "nzz", { desc = "Next search result + center" })
map("n", "N", "Nzz", { desc = "Previous search result + center" })
map("n", "*", "*zz", { desc = "Search word forward + center" })
map("n", "#", "#zz", { desc = "Search word backward + center" })
-- General
