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
vim.keymap.set("n", "<leader>yP", function()
	local path = vim.fn.expand("%")
	local windows_path = "\\\\wsl.localhost\\Ubuntu-22.04" .. string.gsub(path, "/", "\\")

	vim.fn.setreg("+", windows_path)
end, { desc = "Yank Windows Path in WSL" })
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

-- Debug
vim.keymap.set("n", "<Up>", function()
	require("dap").continue()
end, { desc = "Debug: Continuar/Iniciar" })
vim.keymap.set("n", "<Down>", function()
	require("dap").step_over()
end, { desc = "Debug: Step Over (Pular)" })
vim.keymap.set("n", "<Right>", function()
	require("dap").step_into()
end, { desc = "Debug: Step Into (Entrar)" })
vim.keymap.set("n", "<Left>", function()
	require("dap").step_out()
end, { desc = "Debug: Step Out (Sair)" })

vim.keymap.set("n", "<Leader>db", function()
	require("dap").toggle_breakpoint()
end, { desc = "Debug: Alternar Breakpoint" })
vim.keymap.set("n", "<Leader>dB", function()
	require("dap").set_breakpoint()
end, { desc = "Debug: Definir Breakpoint" })
vim.keymap.set("n", "<Leader>dlp", function()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, { desc = "Debug: Log Point" })

vim.keymap.set("n", "<Leader>dr", function()
	require("dap").repl.open()
end, { desc = "Debug: Abrir REPL" })
vim.keymap.set("n", "<Leader>dl", function()
	require("dap").run_last()
end, { desc = "Debug: Rodar Último" })

vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
	require("dap.ui.widgets").hover()
end, { desc = "Debug: Hover (Inspecionar)" })

vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
	require("dap.ui.widgets").preview()
end, { desc = "Debug: Preview (Janela flutuante)" })

vim.keymap.set("n", "<Leader>df", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.frames)
end, { desc = "Debug: Mostrar Frames (Stack)" })

vim.keymap.set("n", "<Leader>ds", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.scopes)
end, { desc = "Debug: Mostrar Scopes (Variáveis)" })
-- Debug

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
