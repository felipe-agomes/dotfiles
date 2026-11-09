local M = {}

--- Invalida o cache de git status do snacks.explorer e redesenha os
--- explorers abertos. Necessário porque o watcher do Snacks só observa
--- `.git/index`, e `git commit` não altera esse arquivo.
function M.refresh_git()
	if not package.loaded["snacks.explorer.watch"] then
		return
	end

	local Git = require("snacks.explorer.git")
	local Watch = require("snacks.explorer.watch")
	local GitUtil = require("snacks.git")

	for _, picker in ipairs(require("snacks.picker").get({ source = "explorer", tab = false })) do
		local root = GitUtil.get_root(picker:cwd())
		if root then
			Git.refresh(root)
		end
	end

	Watch.refresh()
end

return M
