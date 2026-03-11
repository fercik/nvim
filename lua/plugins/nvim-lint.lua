return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		local eslint_root_markers = {
			"eslint.config.js",
			"eslint.config.mjs",
			"eslint.config.cjs",
			"eslint.config.ts",
			"eslint.config.mts",
			"eslint.config.cts",
			".eslintrc",
			".eslintrc.js",
			".eslintrc.cjs",
			".eslintrc.json",
			".eslintrc.yaml",
			".eslintrc.yml",
		}

		---@param bufnr number
		---@return string
		local function resolve_lint_cwd(bufnr)
			local eslint_root = vim.fs.root(bufnr, eslint_root_markers)
			if eslint_root then
				return eslint_root
			end

			local project_root = vim.fs.root(bufnr, { "package.json", "nx.json", ".git" })
			if project_root then
				return project_root
			end

			local bufname = vim.api.nvim_buf_get_name(bufnr)
			if bufname ~= "" then
				return vim.fs.dirname(vim.fs.normalize(bufname))
			end

			return vim.fn.getcwd()
		end

		-- Nx can print non-JSON warnings before eslint's JSON output, which breaks parsing.
		-- Strip everything before the first JSON token and then let the builtin parser handle it.
		do
			local eslint_d = lint.linters.eslint_d
			if eslint_d and type(eslint_d.parser) == "function" then
				local base_parser = eslint_d.parser
				eslint_d.parser = function(output, bufnr, linter_cwd)
					if type(output) == "string" then
						local json_start = output:find("[%[{]")
						if json_start then
							output = output:sub(json_start)
						end
					end

					local diagnostics = base_parser(output, bufnr, linter_cwd)
					if type(diagnostics) ~= "table" then
						return diagnostics
					end

					return vim.tbl_filter(function(diagnostic)
						local message = diagnostic and diagnostic.message
						if type(message) ~= "string" then
							return true
						end

						return not message:find("File ignored because outside of base path", 1, true)
					end, diagnostics)
				end
			end
		end

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
		}

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			callback = function()
				local bufnr = vim.api.nvim_get_current_buf()
				if vim.bo[bufnr].buftype ~= "" then
					return
				end

				lint.try_lint(nil, { cwd = resolve_lint_cwd(bufnr) })
			end,
		})
	end,
}
