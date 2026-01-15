vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.cmdheight = 0

vim.g.maplocalleader = "\\"
vim.g.mapleader = " "

require("config")

vim.diagnostic.config({
	virtual_text = true, -- Ativa o texto ao lado do erro
	signs = true, -- Mostra ícones na lateral (gutter)
	underline = true, -- Sublinha o código com erro
})
