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
		opts = {
			autoformat = false,
		},
		config = function()
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				require("cmp_nvim_lsp").default_capabilities()
			)

			vim.lsp.enable("angularls", {
				capabilities = capabilities,
			})
			vim.lsp.enable("ts_ls", {
				capabilities = capabilities,
			})
			vim.lsp.enable("lua_ls", {
				capabilities = capabilities,
			})
			vim.lsp.enable("emmet_language_server", {
				capabilities = capabilities,
			})
			vim.lsp.enable("html", {
				capabilities = capabilities,
			})
			vim.lsp.enable("cssls", {
				capabilities = capabilities,
			})
			vim.lsp.enable("tailwindcss", {
				capabilities = capabilities,
			})

			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]utocomplete" })
		end,
	},
}
