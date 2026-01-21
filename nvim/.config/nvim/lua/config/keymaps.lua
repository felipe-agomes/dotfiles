vim.keymap.set("n", "<leader>cl", function()
	vim.cmd("lua print(vim.inspect(vim.lsp.get_clients({ bufnr = 0 })))")
end, { desc = "LSP info" })

vim.keymap.set("n", "<C-l>", "<C-W>l")
vim.keymap.set("n", "<C-h>", "<C-W>h")
vim.keymap.set("n", "<C-k>", "<C-W>k")
vim.keymap.set("n", "<C-j>", "<C-W>j")

-- Bufferline
vim.keymap.set("n", "H", function()
	vim.cmd("BufferLineCyclePrev")
end)
vim.keymap.set("n", "L", function()
	vim.cmd("BufferLineCycleNext")
end)
vim.keymap.set("n", "<leader>br", function()
	vim.cmd("BufferLineCloseRight")
end, { desc = "Delete Buffers to the Right" })
vim.keymap.set("n", "<leader>bl", function()
	vim.cmd("BufferLineCloseLeft")
end, { desc = "Delete Buffers to the Left" })
vim.keymap.set("n", "<leader>bo", function()
	vim.cmd("BufferLineCloseLeft")
	vim.cmd("BufferLineCloseRight")
end, { desc = "Delete Buffers others" })
-- Bufferline

-- Yank
vim.keymap.set("n", "<leader>yf", function()
	local filename = vim.fn.expand("%:t")
	vim.fn.setreg("+", filename)
end, { desc = "Yank Filename" })
vim.keymap.set("n", "<leader>yp", function()
	local path = vim.fn.expand("%")
	vim.fn.setreg("+", path)
end, { desc = "Yank Path" })
-- Yank

-- Next and previous
vim.keymap.set("n", "[b", function()
	vim.cmd("BufferLineCyclePrev")
end, { desc = "Prev Buffer" })
vim.keymap.set("n", "]b", function()
	vim.cmd("BufferLineCycleNext")
end, { desc = "Next Buffer" })
vim.keymap.set("n", "[B", function()
	vim.cmd("BufferLineMovePrev")
end, { desc = "Move buffer prev" })
vim.keymap.set("n", "]B", function()
	vim.cmd("BufferLineMoveNext")
end, { desc = "Move buffer next" })

vim.keymap.set("n", "]t", function()
	require("todo-comments").jump_next()
end, { desc = "Next todo comment" })
vim.keymap.set("n", "[t", function()
	require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })
-- Next and previous

-- Search
vim.keymap.set("n", "<leader>st", function()
	vim.cmd("TodoTrouble")
end, { desc = "Search all todos" })
-- Search

-- Inspect
-- :lua for _, map in ipairs(vim.api.nvim_buf_get_keymap(0, 'n')) do print(vim.inspect(map)) end
-- Inspect

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

vim.keymap.set("n", "-", function()
	vim.cmd("Oil --float")
end, { desc = "Open parent directory" })

-- General
vim.keymap.set("n", "<Esc>", function()
	vim.cmd("nohlsearch")
end)
-- General
