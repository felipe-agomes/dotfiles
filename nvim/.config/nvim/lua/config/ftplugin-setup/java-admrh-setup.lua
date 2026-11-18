-- Comandos úteis no workspace ADMRH (jdtls):
--
-- :JdtCompile
--   Build incremental manual. Use em um buffer Java depois de alterar código,
--   para validar erros de compilação sem esperar build automático (o autobuild
--   está desligado neste workspace).
--
-- :JdtCompile full
--   Build completo do workspace. Use apenas quando o classpath/projeto mudou,
--   quando muitos arquivos foram alterados ou quando o build incremental não
--   resolveu. É caro em um projeto legado grande.
--
-- :JdtRestart
--   Reinicia o jdtls mantendo índice/cache. Use após mudar configurações
--   (autobuild, encoding, runtime) ou se o LSP travar.
--
-- :JdtRegenerateWorkspace
--   Recria o projeto shadow e apaga o data dir do jdtls. Use ao trocar entre
--   workspace de teste e real, ao mudar source links/jars, ou se o projeto
--   importado ficou inconsistente. É mais pesado que :JdtRestart.
--
-- :JdtWipeDataAndRestart
--   Apaga o data dir do jdtls e reinicia. Use se o índice/cache estiver
--   corrompido. Não recria o projeto shadow.
--
-- :JdtShowLogs
--   Abre o log do jdtls. Use para investigar problemas de import, classpath,
--   encoding, JDK ou inicialização.
--
-- :JdtSetRuntime
--   Troca o runtime Java do projeto. No ADMRH o padrão é JavaSE-11; use apenas
--   se precisar testar outro JDK.
--
-- :JdtUpdateConfig
--   Atualiza configuração Maven/Gradle. Não é necessário no ADMRH, pois Maven
--   e Gradle estão desabilitados.
--
-- Outros comandos avançados do nvim-jdtls em buffers Java:
-- :JdtBytecode, :JdtJol, :JdtJshell, :JdtUpdateHotcode,
-- :JdtShowMavenActiveProfiles, :JdtUpdateMavenActiveProfiles.
-- Use apenas quando precisar dessas funcionalidades específicas.

local M = {}

local shadow_name = "admrh-workspace"
local project_name = "admrh-workspace"
local required_projects = {
	"rhsysweb",
	"rhsysejb",
	"rhsysutil",
}
local source_links = {
	{ name = "rhsysweb-src", path = "rhsysweb/src" },
	{ name = "rhsysejb-src", path = "rhsysejb/ejbModule" },
	{ name = "rhsysutil-src", path = "rhsysutil/src" },
}
local jar_globs = {
	"rhsysinstall/wildfly20/**/*.jar",
	"rhsysinstall/lib/**/*.jar",
	"rhsysinstall/lib-jasper/**/*.jar",
	"rhsysinstall/wildfly81/modules/com/**/*.jar",
	"rhsysinstall/wildfly81/modules/oracle/**/*.jar",
	"rhsysinstall/wildfly81/modules/org/**/*.jar",
	"rhsysinstall/lib-opensaml3/**/*.jar",
	"rhsysweb/WebContent/WEB-INF/lib/**/*.jar",
}
local server_lib = "/home/fagomes/admrh_docker_project/source/rhsysinstall/wildfly81/modules/system/layers/base"
local m2_lib = vim.fn.expand("~/.m2/repository/com/adm")
local vendor_jars = {
	{
		name = "activation-1.1.1.jar",
		sources = {
			server_lib .. "/javax/activation/api/main/activation-1.1.1.jar",
			m2_lib .. "/activation/1.0/activation-1.0.jar",
		},
	},
	{
		name = "jboss-ejb3-ext-api-2.1.0.jar",
		sources = {
			server_lib .. "/org/jboss/ejb3/main/jboss-ejb3-ext-api-2.1.0.jar",
			m2_lib .. "/jboss-ejb3-ext/2.1.0/jboss-ejb3-ext-2.1.0.jar",
		},
	},
	{
		name = "picketbox-4.0.21.Beta1.jar",
		sources = {
			server_lib .. "/org/picketbox/main/picketbox-4.0.21.Beta1.jar",
			m2_lib .. "/picketbox/4.0.21/picketbox-4.0.21.jar",
		},
	},
	{
		name = "resteasy-multipart-provider-3.0.8.Final.jar",
		sources = {
			server_lib .. "/org/jboss/resteasy/resteasy-multipart-provider/main/resteasy-multipart-provider-3.0.8.Final.jar",
		},
	},
	{
		name = "resteasy-jaxrs-3.0.8.Final.jar",
		sources = {
			server_lib .. "/org/jboss/resteasy/resteasy-jaxrs/main/resteasy-jaxrs-3.0.8.Final.jar",
		},
	},
}

local function exists(path)
	return vim.uv.fs_stat(path) ~= nil
end

local function path_join(...)
	return table.concat({ ... }, "/")
end

local function xml_escape(value)
	return value:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;")
end

local function write_if_changed(path, content)
	if exists(path) and table.concat(vim.fn.readfile(path), "\n") == content then
		return
	end

	vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
	vim.fn.writefile(vim.split(content, "\n", { plain = true }), path)
end

local function is_admrh_root(root)
	for _, project in ipairs(required_projects) do
		if not exists(path_join(root, project, ".project")) then
			return false
		end
	end

	return true
end

function M.workspace_root(bufnr)
	local name = vim.api.nvim_buf_get_name(bufnr or 0)
	if name == "" then
		return nil
	end

	local dir = vim.fn.fnamemodify(name, ":p:h")
	while dir and dir ~= "/" do
		if is_admrh_root(dir) then
			return dir
		end

		local parent = vim.fn.fnamemodify(dir, ":h")
		if parent == dir then
			break
		end
		dir = parent
	end

	return nil
end

function M.shadow_dir()
	return path_join(vim.fn.stdpath("cache"), "jdtls-shadow", shadow_name)
end

function M.project_name()
	return project_name
end

function M.data_dir()
	return path_join(vim.fn.stdpath("cache"), "jdtls-workspace", shadow_name .. "-shadow")
end

function M.vendor_dir()
	return path_join(vim.fn.stdpath("data"), "jdtls-vendor", shadow_name)
end

local function find_java_11()
	local candidates = {
		"/usr/lib/jvm/java-11-openjdk-amd64",
		vim.fn.expand("~/.local/share/jdks/temurin-11"),
		vim.env.JAVA_HOME_11,
	}

	for _, candidate in ipairs(candidates) do
		if candidate and vim.fn.executable(path_join(candidate, "bin", "java")) == 1 then
			return candidate
		end
	end

	for _, candidate in ipairs(vim.fn.glob(vim.fn.expand("~/.sdkman/candidates/java/11*"), false, true)) do
		if vim.fn.executable(path_join(candidate, "bin", "java")) == 1 then
			return candidate
		end
	end

	return nil
end

local function find_java_21()
	local candidates = {
		"/usr/lib/jvm/java-21-openjdk-amd64",
		vim.fn.expand("~/.sdkman/candidates/java/21.0.2-graal"),
		vim.env.JAVA_HOME,
	}

	for _, candidate in ipairs(candidates) do
		if candidate and vim.fn.executable(path_join(candidate, "bin", "java")) == 1 then
			return candidate
		end
	end

	return nil
end

local function ensure_vendor()
	local vendor = M.vendor_dir()
	vim.fn.mkdir(vendor, "p")

	for _, jar in ipairs(vendor_jars) do
		local target = path_join(vendor, jar.name)
		if not exists(target) then
			for _, source in ipairs(jar.sources) do
				if exists(source) then
					vim.uv.fs_copyfile(source, target)
					break
				end
			end
		end

		if not exists(target) and not vim.g.admrh_vendor_warned then
			vim.g.admrh_vendor_warned = true
			vim.notify("jdtls: jar ausente no vendor: " .. jar.name, vim.log.levels.WARN)
		end
	end

	return vendor
end

function M.classpath_mirror_dir()
	return path_join(vim.fn.stdpath("data"), "jdtls-vendor", shadow_name .. "-classpath")
end

local function mirror_jar(root, jar)
	local mirror = M.classpath_mirror_dir()
	local target = path_join(mirror, jar:sub(#root + 2))
	local source_stat = vim.uv.fs_stat(jar)
	if not source_stat then
		return jar
	end

	local target_stat = vim.uv.fs_stat(target)
	if target_stat and target_stat.size == source_stat.size and target_stat.mtime.sec >= source_stat.mtime.sec then
		return target
	end

	vim.fn.mkdir(vim.fn.fnamemodify(target, ":h"), "p")
	if vim.uv.fs_copyfile(jar, target) then
		return target
	end

	return jar
end

local function project_xml(root)
	local lines = {
		'<?xml version="1.0" encoding="UTF-8"?>',
		"<projectDescription>",
		"  <name>" .. project_name .. "</name>",
		"  <comment></comment>",
		"  <projects></projects>",
		"  <buildSpec>",
		"    <buildCommand>",
		"      <name>org.eclipse.jdt.core.javabuilder</name>",
		"      <arguments></arguments>",
		"    </buildCommand>",
		"  </buildSpec>",
		"  <natures>",
		"    <nature>org.eclipse.jdt.core.javanature</nature>",
		"  </natures>",
		"  <linkedResources>",
	}

	for _, link in ipairs(source_links) do
		local source = path_join(root, link.path)
		if exists(source) then
			table.insert(lines, "    <link>")
			table.insert(lines, "      <name>" .. link.name .. "</name>")
			table.insert(lines, "      <type>2</type>")
			table.insert(lines, "      <locationURI>" .. xml_escape("file:" .. source) .. "</locationURI>")
			table.insert(lines, "    </link>")
		end
	end

	table.insert(lines, "  </linkedResources>")
	table.insert(lines, "</projectDescription>")

	return table.concat(lines, "\n") .. "\n"
end

local function classpath_xml(root, vendor)
	local lines = {
		'<?xml version="1.0" encoding="UTF-8"?>',
		"<classpath>",
	}

	for _, link in ipairs(source_links) do
		if exists(path_join(root, link.path)) then
			table.insert(lines, '  <classpathentry kind="src" path="' .. link.name .. '"/>')
		end
	end

	table.insert(
		lines,
		'  <classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-11"/>'
	)

	local seen = {}
	for _, pattern in ipairs(jar_globs) do
		local jars = vim.fn.glob(path_join(root, pattern), false, true)
		table.sort(jars)
		for _, jar in ipairs(jars) do
			if not seen[jar] then
				seen[jar] = true
				table.insert(lines, '  <classpathentry kind="lib" path="' .. xml_escape(mirror_jar(root, jar)) .. '"/>')
			end
		end
	end

	for _, jar in ipairs(vendor_jars) do
		local path = path_join(vendor, jar.name)
		if not seen[path] and exists(path) then
			seen[path] = true
			table.insert(lines, '  <classpathentry kind="lib" path="' .. xml_escape(path) .. '"/>')
		end
	end

	table.insert(lines, '  <classpathentry kind="output" path="bin"/>')
	table.insert(lines, "</classpath>")

	return table.concat(lines, "\n") .. "\n"
end

local function jdt_prefs()
	return table.concat({
		"eclipse.preferences.version=1",
		"org.eclipse.jdt.core.compiler.codegen.inlineJsrBytecode=enabled",
		"org.eclipse.jdt.core.compiler.codegen.targetPlatform=11",
		"org.eclipse.jdt.core.compiler.compliance=11",
		"org.eclipse.jdt.core.compiler.problem.assertIdentifier=error",
		"org.eclipse.jdt.core.compiler.problem.enablePreviewFeatures=disabled",
		"org.eclipse.jdt.core.compiler.problem.enumIdentifier=error",
		"org.eclipse.jdt.core.compiler.release=enabled",
		"org.eclipse.jdt.core.compiler.source=11",
	}, "\n") .. "\n"
end

local function resource_prefs()
	return table.concat({
		"eclipse.preferences.version=1",
		"encoding/" .. project_name .. "=ISO-8859-1",
	}, "\n") .. "\n"
end

function M.ensure_shadow(root, force)
	local shadow = M.shadow_dir()
	local vendor = ensure_vendor()
	local project = path_join(shadow, ".project")
	local classpath = path_join(shadow, ".classpath")

	if not force and exists(project) and exists(classpath) then
		return shadow
	end

	vim.fn.mkdir(shadow, "p")
	write_if_changed(project, project_xml(root))
	write_if_changed(classpath, classpath_xml(root, vendor))
	write_if_changed(path_join(shadow, ".settings", "org.eclipse.jdt.core.prefs"), jdt_prefs())
	write_if_changed(path_join(shadow, ".settings", "org.eclipse.core.resources.prefs"), resource_prefs())

	return shadow
end

local function jdtls_cmd()
	local launcher = "/opt/jdt-language-server/bin/jdtls"
	local cmd = { launcher }

	if vim.fn.executable(launcher) == 0 then
		cmd = { "jdtls" }
	else
		local java = find_java_21()
		if java then
			table.insert(cmd, "--java-executable")
			table.insert(cmd, path_join(java, "bin", "java"))
		end
		table.insert(cmd, "--jvm-arg=-Xms256m")
		table.insert(cmd, "--jvm-arg=-Xmx1536m")
		table.insert(cmd, "--jvm-arg=-XX:MaxMetaspaceSize=512m")
	end

	table.insert(cmd, "-data")
	table.insert(cmd, M.data_dir())

	return cmd
end

function M.config(bufnr)
	local root = M.workspace_root(bufnr)
	if not root then
		return nil
	end

	local shadow = M.ensure_shadow(root)
	local jdk11 = find_java_11()
	local runtime = jdk11 or find_java_21()

	if not jdk11 and not vim.g.admrh_jdk11_warned then
		vim.g.admrh_jdk11_warned = true
		vim.notify("JavaSE-11: JDK 11 não encontrado, usando JDK 21 como fallback", vim.log.levels.WARN)
	end

	return {
		root_dir = shadow,
		cmd = jdtls_cmd(),
		settings = {
			java = {
				configuration = {
					runtimes = {
						{
							name = "JavaSE-11",
							path = runtime,
							default = true,
						},
					},
				},
				autobuild = {
					enabled = false,
				},
				compile = {
					nullAnalysis = {
						mode = "disabled",
					},
				},
				maxConcurrentBuilds = 1,
				import = {
					exclusions = {
						"**/bin/**",
						"**/.svn/**",
						"xcape/**",
					},
					gradle = {
						enabled = false,
					},
					maven = {
						enabled = false,
					},
				},
				project = {
					encoding = "ignore",
				},
			},
		},
	}
end

function M.regenerate()
	local root = M.workspace_root(0)
	if not root then
		return
	end

	for _, client in ipairs(vim.lsp.get_clients({ name = "jdtls" })) do
		client:stop()
	end

	vim.wait(5000, function()
		return #vim.lsp.get_clients({ name = "jdtls" }) == 0
	end, 100)

	vim.fn.delete(M.data_dir(), "rf")
	M.ensure_shadow(root, true)
	require("config.ftplugin-setup.java-setup").setup()
	vim.notify("jdtls: workspace regenerado", vim.log.levels.INFO)
end

function M.on_attach(client)
	local namespace = vim.lsp.diagnostic.get_namespace(client.id)

	vim.diagnostic.config({
		severity = {
			min = vim.diagnostic.severity.ERROR,
		},
	}, namespace)
end

function M.setup_command()
	if vim.g.admrh_jdtls_command then
		return
	end

	vim.g.admrh_jdtls_command = true
	vim.api.nvim_create_user_command("JdtRegenerateWorkspace", M.regenerate, {
		desc = "Java: regenerate jdtls workspace",
	})
end

return M
