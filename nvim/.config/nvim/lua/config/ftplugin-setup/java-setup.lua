local M = {}

local admrh = require("config.ftplugin-setup.java-admrh-setup")

local function is_jdt_resource(bufnr)
	local name = vim.api.nvim_buf_get_name(bufnr or 0)

	return name:match("^jdt://") ~= nil or name:match("%.class$") ~= nil
end

local function is_real_java_source(bufnr)
	local buf = bufnr or 0
	local name = vim.api.nvim_buf_get_name(buf)

	return name ~= ""
		and vim.startswith(name, "/")
		and vim.bo[buf].buftype == ""
		and not is_jdt_resource(buf)
end

local guard_group = vim.api.nvim_create_augroup("config_jdtls_buffer_guard", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = guard_group,
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client or client.name ~= "jdtls" then
			return
		end

		local filetype = vim.bo[args.buf].filetype
		if filetype ~= "" and filetype ~= "java" and not is_jdt_resource(args.buf) then
			local buf = args.buf
			local client_id = client.id

			vim.schedule(function()
				if vim.api.nvim_buf_is_valid(buf) then
					vim.lsp.buf_detach_client(buf, client_id)
				end
			end)
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = guard_group,
	callback = function(args)
		if vim.bo[args.buf].filetype == "java" or is_jdt_resource(args.buf) then
			return
		end

		for _, client in ipairs(vim.lsp.get_clients({ name = "jdtls", bufnr = args.buf })) do
			vim.lsp.buf_detach_client(args.buf, client.id)
		end
	end,
})

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
	if not is_real_java_source(0) then
		return
	end

	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
	local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. project_name
	local test_bundles = java_test_bundles()
	local bundles = mason_bundles("java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar")

	vim.list_extend(bundles, test_bundles)

	local admrh_config = admrh.config(0)

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

			if admrh_config then
				admrh.on_attach(client)
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

	if admrh_config then
		config.root_dir = admrh_config.root_dir
		config.cmd = admrh_config.cmd
		config.settings = vim.tbl_deep_extend("force", config.settings or {}, admrh_config.settings or {})
		admrh.setup_command()
	end

	require("jdtls").start_or_attach(config)
end

return M
