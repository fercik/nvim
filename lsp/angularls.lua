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

-- Angular requires a node_modules directory to probe for @angular/language-service and typescript
-- in order to use your projects configured versions.
local root_dir = vim.fn.getcwd()
local node_modules_dir = vim.fs.find("node_modules", { path = root_dir, upward = true })[1]
local project_root = node_modules_dir and vim.fs.dirname(node_modules_dir) or "?"

local function get_probe_dir()
	return project_root and (project_root .. "/node_modules") or ""
end

local function get_angular_core_version()
	if not project_root then
		return ""
	end

	local package_json = project_root .. "/package.json"
	if not vim.uv.fs_stat(package_json) then
		return ""
	end

	local contents = io.open(package_json):read("*a")
	local json = vim.json.decode(contents)
	if not json.dependencies then
		return ""
	end

	local angular_core_version = json.dependencies["@angular/core"]

	angular_core_version = angular_core_version and angular_core_version:match("%d+%.%d+%.%d+")

	return angular_core_version
end

local default_probe_dir = get_probe_dir()
local default_angular_core_version = get_angular_core_version()

-- structure should be like
-- - $EXTENSION_PATH
--   - @angular
--     - language-server
--       - bin
--         - ngserver
--   - typescript

--- Find ngserver executable, checking PATH first then falling back to Mason's bin directory
---@return string|nil path to ngserver executable, or nil if not found
local function find_ngserver()
	-- First, try to find ngserver in PATH
	local ngserver_exe = vim.fn.exepath("ngserver")
	if ngserver_exe and #ngserver_exe > 0 then
		return ngserver_exe
	end

	-- Fallback: check Mason's bin directory
	local mason_bin = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin", "ngserver")
	if vim.uv.fs_stat(mason_bin) then
		return mason_bin
	end

	return nil
end

local ngserver_exe = find_ngserver()

--- Get the extension path from the ngserver executable location
---@param exe string|nil path to ngserver executable
---@return string|nil normalized extension path, or nil if invalid
local function get_extension_path(exe)
	if not exe then
		return nil
	end

	local real_path = vim.uv.fs_realpath(exe)
	if not real_path then
		return nil
	end

	local ngserver_dir = vim.fs.dirname(real_path)
	if not ngserver_dir then
		return nil
	end

	-- Navigate up from .../bin/ngserver to the extension root
	local ext_path = vim.fs.normalize(vim.fs.joinpath(ngserver_dir, "../../../"))
	-- Validate the extension path exists
	if vim.uv.fs_stat(ext_path) then
		return ext_path
	end

	return nil
end

local extension_path = get_extension_path(ngserver_exe)

-- angularls will get module by `require.resolve(PROBE_PATH, MODULE_NAME)` of nodejs
-- Filter out nil values to avoid invalid probe paths
local ts_probe_locations = vim.tbl_filter(function(p)
	return p ~= nil and p ~= ""
end, { extension_path, default_probe_dir })

local ts_probe_dirs = vim.iter(ts_probe_locations):join(",")

local ng_probe_dirs = vim.iter(ts_probe_locations)
	:map(function(p)
		return vim.fs.joinpath(p, "@angular/language-server/node_modules")
	end)
	:join(",")

---@type vim.lsp.Config
return {
	cmd = {
		"ngserver",
		"--stdio",
		"--tsProbeLocations",
		ts_probe_dirs,
		"--ngProbeLocations",
		ng_probe_dirs,
		"--angularCoreVersion",
		default_angular_core_version,
	},
	filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" },
	root_markers = { "angular.json", "nx.json" },
}
