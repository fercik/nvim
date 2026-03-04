---@brief
---
--- https://github.com/angular/vscode-ng-language-service
--- `angular-language-server` can be installed via npm `npm install -g @angular/language-server`.
---
--- ```lua
--- local project_library_path = "/path/to/project/lib"
--- local cmd = {"ngserver", "--stdio", "--tsProbeLocations", project_library_path , "--ngProbeLocations", project_library_path}
---
--- vim.lsp.config('angularls', {
---   cmd = cmd,
--- })
--- ```

local angular_workspace = require("angular_workspace")

local fn = vim.fn
local fs = vim.fs
local uv = vim.uv

---@param path string
---@return table|nil
local function read_json(path)
	if not uv.fs_stat(path) then
		return nil
	end

	local ok, content = pcall(fn.readblob, path)
	if not ok or not content then
		return nil
	end

	local decoded_ok, decoded = pcall(vim.json.decode, content)
	if not decoded_ok or type(decoded) ~= "table" then
		return nil
	end

	return decoded
end

---@param project_root string|nil
---@return string|nil
local function get_probe_dir(project_root)
	if not project_root then
		return nil
	end

	local probe_dir = fs.joinpath(project_root, "node_modules")
	if uv.fs_stat(probe_dir) then
		return probe_dir
	end

	return nil
end

---@param project_root string|nil
---@return string|nil
local function get_angular_core_version(project_root)
	if not project_root then
		return nil
	end

	local package_json = read_json(fs.joinpath(project_root, "package.json"))
	if not package_json then
		return nil
	end

	local dependencies = package_json.dependencies or {}
	local dev_dependencies = package_json.devDependencies or {}
	local version = dependencies["@angular/core"] or dev_dependencies["@angular/core"]
	if type(version) ~= "string" then
		return nil
	end

	return version:match("%d+%.%d+%.%d+")
end

---@return string|nil
local function find_ngserver()
	local ngserver_exe = fn.exepath("ngserver")
	if ngserver_exe and #ngserver_exe > 0 then
		return ngserver_exe
	end

	local mason_bin = fs.joinpath(fn.stdpath("data"), "mason", "bin", "ngserver")
	if uv.fs_stat(mason_bin) then
		return mason_bin
	end

	return nil
end

---@param exe string|nil
---@return string|nil
local function get_extension_path(exe)
	if not exe then
		return nil
	end

	local real_path = uv.fs_realpath(exe)
	if not real_path then
		return nil
	end

	local ngserver_dir = fs.dirname(real_path)
	if not ngserver_dir then
		return nil
	end

	local extension_path = fs.normalize(fs.joinpath(ngserver_dir, "../../../"))
	if uv.fs_stat(extension_path) then
		return extension_path
	end

	return nil
end

local extension_path = get_extension_path(find_ngserver())

---@type vim.lsp.Config
return {
	cmd = function(dispatchers, config)
		local project_root = (config and config.root_dir) or fn.getcwd()
		local probe_dir = get_probe_dir(project_root)
		local angular_core_version = get_angular_core_version(project_root)

		local ts_probe_locations = vim.tbl_filter(function(path)
			return path ~= nil and path ~= ""
		end, { extension_path, probe_dir })
		if #ts_probe_locations == 0 then
			return nil
		end

		local ng_probe_locations = {}
		if extension_path then
			table.insert(ng_probe_locations, fs.joinpath(extension_path, "@angular/language-server/node_modules"))
		end
		if probe_dir then
			table.insert(ng_probe_locations, probe_dir)
		end

		local cmd = {
			"ngserver",
			"--stdio",
			"--tsProbeLocations",
			table.concat(ts_probe_locations, ","),
			"--ngProbeLocations",
			table.concat(ng_probe_locations, ","),
			"--angularCoreVersion",
			angular_core_version or "",
		}

		return vim.lsp.rpc.start(cmd, dispatchers, {
			cwd = config and config.cmd_cwd,
			env = config and config.cmd_env,
			detached = config and config.detached,
		})
	end,
	filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" },
	root_dir = function(bufnr, on_dir)
		local root = angular_workspace.find_root(bufnr)
		if root and angular_workspace.is_angular_buffer(bufnr) then
			on_dir(root)
		end
	end,
}
