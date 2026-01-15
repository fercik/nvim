return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

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
					return base_parser(output, bufnr, linter_cwd)
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
				lint.try_lint()
			end,
		})
	end,
}

