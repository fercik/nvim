local jdtls = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "jdtls")
local launcher = vim.fs.joinpath(jdtls, "jdtls")
local lombok = vim.fs.joinpath(jdtls, "lombok.jar")
local workspace_root = vim.fs.joinpath(vim.fn.stdpath("data"), "jdtls-workspaces")
local root_markers = {
	"mvnw",
	"gradlew",
	"settings.gradle",
	"settings.gradle.kts",
	"build.xml",
	"pom.xml",
	"build.gradle",
	"build.gradle.kts",
	".git",
}

---@param root_dir string|nil
---@return string
local function workspace_dir(root_dir)
	local project_root = vim.fs.normalize(root_dir or vim.fn.getcwd())
	local project_name = vim.fs.basename(project_root)
	if project_name == "" then
		project_name = "project"
	end

	vim.fn.mkdir(workspace_root, "p")

	return vim.fs.joinpath(workspace_root, project_name .. "-" .. vim.fn.sha256(project_root):sub(1, 8))
end

---@type vim.lsp.Config
return {
	cmd = function(dispatchers, config)
		local root_dir = (config and config.root_dir) or vim.fn.getcwd()
		local cmd = {
			launcher,
			"--jvm-arg=-javaagent:" .. lombok,
			"--jvm-arg=-Xbootclasspath/a:" .. lombok,
			"-data",
			workspace_dir(root_dir),
		}

		return vim.lsp.rpc.start(cmd, dispatchers, {
			cwd = (config and config.cmd_cwd) or root_dir,
			env = config and config.cmd_env,
			detached = config and config.detached,
		})
	end,
	filetypes = { "java" },
	root_markers = root_markers,
	root_dir = function(bufnr, on_dir)
		local root = vim.fs.root(bufnr, root_markers)
		if root then
			on_dir(root)
			return
		end

		local bufname = vim.api.nvim_buf_get_name(bufnr)
		if bufname ~= "" then
			on_dir(vim.fs.dirname(vim.fs.normalize(bufname)))
			return
		end

		on_dir(vim.fn.getcwd())
	end,
}
