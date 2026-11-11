local M = {}

local function mason_bundles(pattern)
	return vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/" .. pattern, false, true)
end

local function java_test_bundles()
	local excluded = {
		"com.microsoft.java.test.runner-jar-with-dependencies.jar",
		"jacocoagent.jar",
	}

	local bundles = mason_bundles("java-test/extension/server/*.jar")

	return vim.tbl_filter(function(jar)
		local name = vim.fn.fnamemodify(jar, ":t")

		return not vim.tbl_contains(excluded, name) and not name:match("^org%.objectweb%.asm")
	end, bundles)
end

function M.setup()
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
	local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. project_name
	local test_bundles = java_test_bundles()
	local bundles = mason_bundles("java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar")

	vim.list_extend(bundles, test_bundles)

	local config = {
		name = "jdtls",
		cmd = { "jdtls", "-data", workspace_dir },
		root_dir = vim.fs.root(0, {
			"pom.xml",
			"build.gradle",
			"build.gradle.kts",
			"gradlew",
			".git",
		}),
		init_options = {
			bundles = bundles,
		},
		on_attach = function(client, _)
			if client.server_capabilities then
				client.server_capabilities.semanticTokensProvider = nil
			end

			if #test_bundles == 0 then
				return
			end

			vim.keymap.set("n", "<leader>djt", function()
				require("jdtls").test_nearest_method()
			end, { buffer = true, desc = "Debug: Java test method" })

			vim.keymap.set("n", "<leader>djc", function()
				require("jdtls").test_class()
			end, { buffer = true, desc = "Debug: Java test class" })
		end,
	}

	require("jdtls").start_or_attach(config)
end

return M
