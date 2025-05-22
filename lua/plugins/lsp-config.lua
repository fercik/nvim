return {
	{
		"williamboman/mason.nvim",
		opts = {
			PATH = "prepend",
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"angularls",
					"html",
					"cssls",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig.html.setup({
				capabilities = capabilities,
			})

			lspconfig.cssls.setup({
				capabilities = capabilities,
			})

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})

			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})

			local function is_eslint_project()
				if vim.fn.filereadable("package.json") == 1 then
					local file_content = vim.fn.readfile("package.json")
					local ok, pkg = pcall(vim.fn.json_decode, table.concat(file_content, "\n"))
					return ok and pkg["eslintConfig"] ~= nil
				end
				return false
			end

			if is_eslint_project() then
				lspconfig.eslint.setup({
					on_attach = function(client, bufnr)
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							command = "EslintFixAll",
						})
						print("ESLint LSP attached!")
					end,
				})
			end

			if vim.fn.filereadable("angular.json") == 1 then
				lspconfig.angularls.setup({
					capabilities = capabilities,
					root_dir = function(fname)
						return require("lspconfig.util").root_pattern(
							"angular.json",
							"tsconfig.json",
							"workspace.json",
							"nx.json"
						)(fname)
					end,
					settings = {
						angular = {
							strictTemplates = true,
						},
					},
				})
			end

			lspconfig.emmet_language_server.setup({
				capabilities = capabilities,
				filetypes = {
					"css",
					"html",
					"javascript",
					"scss",
					"typescript",
				},
				init_options = {
					---@type table<string, string>
					includeLanguages = {},
					--- @type string[]
					excludeLanguages = {},
					--- @type string[]
					extensionsPath = {},
					--- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
					preferences = {},
					--- @type boolean Defaults to `true`
					showAbbreviationSuggestions = true,
					--- @type "always" | "never" Defaults to `"always"`
					showExpandedAbbreviation = "always",
					--- @type boolean Defaults to `false`
					showSuggestionsAsSnippets = false,
					--- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
					syntaxProfiles = {},
					--- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
					variables = {},
				},
			})

			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
