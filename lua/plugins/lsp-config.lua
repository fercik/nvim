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
		dependencies = {
			"nvim-java/nvim-java",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			local default_node_modules = vim.fn.getcwd() .. "/node_modules"
			--local tsconfig = vim.fn.getcwd() .. "/tsconfig.app.json"
			local ngls_cmd = {
				"ngserver",
				"--stdio",
				"--tsProbeLocations",
				default_node_modules,
				"--ngProbeLocations",
				default_node_modules,
			}
			require("java").setup({
				jdk = {
					auto_install = false,
				},
			})

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
			lspconfig.jdtls.setup({
				capabilities = capabilities,
			})
			lspconfig.angularls.setup({
				cmd = ngls_cmd,
				capabilities = capabilities,
				root_dir = require("lspconfig").util.root_pattern("nx.json"),
				on_new_config = function(new_config, new_root_dir)
					new_config.cmd = ngls_cmd
					new_config.root_dir = new_root_dir
				end,
			})
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
