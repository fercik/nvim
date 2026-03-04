local uv = vim.uv

local M = {}

---@param path string
---@return table|nil
local function read_json(path)
	if not uv.fs_stat(path) then
		return nil
	end

	local ok, content = pcall(vim.fn.readblob, path)
	if not ok or not content then
		return nil
	end

	local decoded_ok, decoded = pcall(vim.json.decode, content)
	if not decoded_ok or type(decoded) ~= "table" then
		return nil
	end

	return decoded
end

---@param package_json table|nil
---@return boolean
local function has_angular_dependencies(package_json)
	if type(package_json) ~= "table" then
		return false
	end

	for _, deps in ipairs({
		package_json.dependencies,
		package_json.devDependencies,
		package_json.peerDependencies,
		package_json.optionalDependencies,
	}) do
		if type(deps) == "table" then
			for name, _ in pairs(deps) do
				if type(name) == "string" then
					if vim.startswith(name, "@angular/") or name == "@nx/angular" or name == "@nrwl/angular" then
						return true
					end
				end
			end
		end
	end

	return false
end

---@param nx_json table|nil
---@return boolean
local function has_nx_angular_plugin(nx_json)
	if type(nx_json) ~= "table" or type(nx_json.plugins) ~= "table" then
		return false
	end

	for _, plugin in ipairs(nx_json.plugins) do
		if type(plugin) == "string" then
			if plugin == "@nx/angular" or plugin == "@nrwl/angular" then
				return true
			end
		elseif type(plugin) == "table" then
			local plugin_name = plugin.plugin or plugin.name or plugin[1]
			if plugin_name == "@nx/angular" or plugin_name == "@nrwl/angular" then
				return true
			end
		end
	end

	return false
end

---@param path string
---@return boolean
local function is_absolute_path(path)
	return vim.startswith(path, "/") or path:match("^%a:[/\\]") ~= nil
end

---@param path string
---@param root string
---@return boolean
local function is_path_inside_root(path, root)
	local normalized_path = vim.fs.normalize(path)
	local normalized_root = vim.fs.normalize(root)
	if normalized_path == normalized_root then
		return true
	end

	return vim.startswith(normalized_path, normalized_root .. "/")
end

---@param base_path string
---@param extends_value string
---@return string|nil
local function resolve_extends_path(base_path, extends_value)
	if type(extends_value) ~= "string" then
		return nil
	end

	if not vim.startswith(extends_value, ".") and not is_absolute_path(extends_value) then
		return nil
	end

	local resolved = extends_value
	if not is_absolute_path(resolved) then
		resolved = vim.fs.joinpath(vim.fs.dirname(base_path), resolved)
	end

	if not resolved:match("%.json$") then
		resolved = resolved .. ".json"
	end

	return vim.fs.normalize(resolved)
end

---@param tsconfig_path string
---@param seen table<string, boolean>
---@return boolean
local function has_angular_compiler_options(tsconfig_path, seen)
	tsconfig_path = vim.fs.normalize(tsconfig_path)
	if seen[tsconfig_path] then
		return false
	end
	seen[tsconfig_path] = true

	local tsconfig = read_json(tsconfig_path)
	if type(tsconfig) ~= "table" then
		return false
	end

	if type(tsconfig.angularCompilerOptions) == "table" then
		return true
	end

	local extended_path = resolve_extends_path(tsconfig_path, tsconfig.extends)
	if not extended_path then
		return false
	end

	return has_angular_compiler_options(extended_path, seen)
end

---@param project_json table|nil
---@return boolean
local function project_uses_angular(project_json)
	if type(project_json) ~= "table" or type(project_json.targets) ~= "table" then
		return false
	end

	for _, target in pairs(project_json.targets) do
		local executor = type(target) == "table" and target.executor or nil
		if type(executor) == "string" then
			if vim.startswith(executor, "@angular/") then
				return true
			end
			if vim.startswith(executor, "@nx/angular:") or vim.startswith(executor, "@nrwl/angular:") then
				return true
			end
		end
	end

	return false
end

---@param bufnr number
---@return string|nil
function M.find_root(bufnr)
	local angular_root = vim.fs.root(bufnr, { "angular.json" })
	if angular_root then
		return angular_root
	end

	local nx_root = vim.fs.root(bufnr, { "nx.json" })
	if not nx_root then
		return nil
	end

	local package_json = read_json(vim.fs.joinpath(nx_root, "package.json"))
	if has_angular_dependencies(package_json) then
		return nx_root
	end

	local nx_json = read_json(vim.fs.joinpath(nx_root, "nx.json"))
	if has_nx_angular_plugin(nx_json) then
		return nx_root
	end

	return nil
end

---@param bufnr number
---@return boolean
function M.is_workspace(bufnr)
	return M.find_root(bufnr) ~= nil
end

---@param bufnr number
---@return boolean
function M.is_angular_buffer(bufnr)
	local root = M.find_root(bufnr)
	if not root then
		return false
	end

	local file_path = vim.api.nvim_buf_get_name(bufnr)
	if file_path == "" then
		return false
	end
	file_path = vim.fs.normalize(file_path)

	if not is_path_inside_root(file_path, root) then
		return false
	end

	local search_from = vim.fs.dirname(file_path)
	local tsconfig_candidates = vim.fs.find(
		{ "tsconfig.json", "tsconfig.app.json", "tsconfig.lib.json" },
		{ path = search_from, upward = true, stop = root }
	)
	for _, tsconfig_path in ipairs(tsconfig_candidates) do
		if has_angular_compiler_options(tsconfig_path, {}) then
			return true
		end
	end

	for _, name in ipairs({ "tsconfig.json", "tsconfig.app.json", "tsconfig.lib.json" }) do
		local root_tsconfig = vim.fs.joinpath(root, name)
		if has_angular_compiler_options(root_tsconfig, {}) then
			return true
		end
	end

	local project_candidates = vim.fs.find("project.json", { path = search_from, upward = true, stop = root })
	for _, project_path in ipairs(project_candidates) do
		if project_uses_angular(read_json(project_path)) then
			return true
		end
	end

	if project_uses_angular(read_json(vim.fs.joinpath(root, "project.json"))) then
		return true
	end

	return uv.fs_stat(vim.fs.joinpath(root, "angular.json")) ~= nil
end

return M
