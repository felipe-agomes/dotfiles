local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. project_name
local config = {
	name = "jdtls",
	cmd = { "jdtls", "-data", workspace_dir },
	root_dir = vim.fs.root(0, { "gradlew", ".git", "mvnw" }),
	init_options = {
		bundles = {},
	},
}
require("jdtls").start_or_attach(config)
