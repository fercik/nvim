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

local function get_probe_dir(project_root)
	if not project_root then
		return nil
	end

	local probe_dir = vim.fs.joinpath(project_root, "node_modules")
	return vim.uv.fs_stat(probe_dir) and probe_dir or nil
end

local function get_angular_core_version(project_root)
	if not project_root then
		return nil
	end

	local package_json = project_root .. "/package.json"
	if not vim.uv.fs_stat(package_json) then
		return nil
	end

	local contents = io.open(package_json):read("*a")
	local json = vim.json.decode(contents)
	if not json.dependencies then
		return nil
	end

	local angular_core_version = json.dependencies["@angular/core"]

	angular_core_version = angular_core_version and angular_core_version:match("%d+%.%d+%.%d+")

	return angular_core_version or nil
end

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

---@type vim.lsp.Config
return {
	-- Compute probe paths when the server starts so opening Neovim outside the
	-- project still resolves the correct Angular workspace.
	cmd = function(_, bufnr)
		local root = vim.fs.root(bufnr, { "angular.json", "nx.json" }) or vim.fn.getcwd()
		if not root then
			return nil
		end

		-- Resolve the project root that actually contains node_modules.
		local node_modules_dir = vim.fs.find("node_modules", { path = root, upward = true })[1]
		local project_root = node_modules_dir and vim.fs.dirname(node_modules_dir) or root

		local probe_dir = get_probe_dir(project_root)
		local angular_core_version = get_angular_core_version(project_root)

		-- angularls will get module by `require.resolve(PROBE_PATH, MODULE_NAME)` of nodejs
		-- Filter out nil values to avoid invalid probe paths
		local ts_probe_locations = vim.tbl_filter(function(p)
			return p ~= nil and p ~= ""
		end, { extension_path, probe_dir })

		-- If no probe locations are available, abort starting the server to avoid a broken instance.
		if #ts_probe_locations == 0 then
			return nil
		end

		local ts_probe_dirs = vim.iter(ts_probe_locations):join(",")

		-- For ngProbeLocations:
		-- - Mason's extension path needs @angular/language-server/node_modules (language-service is bundled there)
		-- - Project's node_modules should be used directly (language-service is a direct dependency)
		local ng_probe_locations = {}
		if extension_path then
			table.insert(ng_probe_locations, vim.fs.joinpath(extension_path, "@angular/language-server/node_modules"))
		end
		if probe_dir then
			-- Add project's node_modules directly - @angular/language-service lives here
			table.insert(ng_probe_locations, probe_dir)
		end
		local ng_probe_dirs = vim.iter(ng_probe_locations):join(",")

		return {
			"ngserver",
			"--stdio",
			"--tsProbeLocations",
			ts_probe_dirs,
			"--ngProbeLocations",
			ng_probe_dirs,
			"--angularCoreVersion",
			angular_core_version or "",
		}
	end,
	filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" },
	root_markers = { "angular.json", "nx.json" },
}
