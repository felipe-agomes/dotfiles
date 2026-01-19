-- Configurações do seu Repo
local cheat_config = {
	user = "felipe-agomes",
	repo = "cheat_sheet",
	branch = "master", -- Verifique se é 'main' ou 'master'
}

-- Cache para não chamar a API toda hora
local cheat_cache = nil

-- Função auxiliar para buscar os arquivos
local function get_cheat_files()
	-- Se já temos no cache, retorna ele
	if cheat_cache then
		return cheat_cache
	end

	print("🔄 Buscando lista de cheats no GitHub...")

	-- Monta o comando para pegar a árvore de arquivos recursivamente
	-- O '?recursive=1' é a mágica que pega arquivos dentro de subpastas (ex: bash/loops.sh)
	local cmd = string.format(
		'gh api "/repos/%s/%s/git/trees/%s?recursive=1"',
		cheat_config.user,
		cheat_config.repo,
		cheat_config.branch
	)

	-- Executa o comando e pega o JSON
	local output = vim.fn.system(cmd)

	-- Proteção contra falhas (ex: sem internet ou token inválido)
	if vim.v.shell_error ~= 0 then
		print("❌ Erro ao buscar cheats. Verifique o 'gh auth login' ou o nome do repo.")
		return {}
	end

	-- Decodifica o JSON
	local json = vim.fn.json_decode(output)
	local files = {}

	-- Filtra apenas o que é arquivo (blob), ignorando pastas (tree)
	if json and json.tree then
		for _, item in ipairs(json.tree) do
			if item.type == "blob" then
				table.insert(files, item.path)
			end
		end
	end

	cheat_cache = files
	return files
end

-- O Comando :Cheat
vim.api.nvim_create_user_command("Cheat", function(opts)
	local file_path = opts.args

	if file_path == "" then
		print("❌ Uso: :Cheat <TAB>")
		return
	end

	-- Comando para pegar o conteúdo do arquivo (Raw)
	local cmd = string.format(
		'gh api -H "Accept: application/vnd.github.raw" /repos/%s/%s/contents/%s',
		cheat_config.user,
		cheat_config.repo,
		file_path
	)

	-- Abre split vertical e configura o buffer
	vim.cmd("vnew")
	vim.cmd("read !" .. cmd)
	vim.cmd("normal! ggdd") -- Remove a linha vazia do topo

	-- Configurações visuais do buffer temporário
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe"
	vim.bo.swapfile = false
	vim.bo.readonly = true

	-- CORREÇÃO AQUI:
	-- Usamos a API do Neovim para descobrir o filetype baseada no NOME original
	-- passamos 'buf = 0' para ele analisar também o conteúdo (shebangs, etc) se precisar
	local ft = vim.filetype.match({ filename = file_path, buf = 0 })
	if ft then
		vim.bo.filetype = ft
	end

	-- Se for Markdown, ativa o wrap para não cortar texto
	if file_path:match("%.md$") then
		vim.wo.wrap = true
	end
end, {
	nargs = 1,
	-- A Mágica do Autocomplete
	complete = function(arg_lead, cmd_line, cursor_pos)
		local files = get_cheat_files()
		local matches = {}

		-- Filtra os arquivos que começam com o que você digitou
		for _, file in ipairs(files) do
			if file:match("^" .. arg_lead) then
				table.insert(matches, file)
			end
		end

		return matches
	end,
})
