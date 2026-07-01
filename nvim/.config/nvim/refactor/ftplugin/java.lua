if vim.b.did_jdtls then
	return
end
vim.b.did_jdtls = true

local jdtls = require("jdtls")
local jdtls_setup = require("jdtls.setup")
local lsp_config = require("config.lsp")

local root_dir = jdtls_setup.find_root({ ".git", "pom.xml" })

local workspace_dir = vim.fn.stdpath("data") .. "/jdtls/workspaces/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

jdtls.start_or_attach({
	cmd = { "jdtls", "-data", workspace_dir },
	root_dir = root_dir,
	capabilities = lsp_config.capabilities,
	on_attach = lsp_config.on_attach,
})
