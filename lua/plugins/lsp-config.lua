return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {
			PATH = "prepend",
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				automatic_enable = false,
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"angularls",
					"html",
					"cssls",
					"tailwindcss",
					"yamlls",
					"emmet_language_server",
					"dockerls",
					"jsonls",
					"jdtls",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "williamboman/mason-lspconfig.nvim", "saghen/blink.cmp" },
		config = function()
			vim.lsp.config("*", {
				capabilities = vim.tbl_deep_extend(
					"force",
					vim.lsp.protocol.make_client_capabilities(),
					require("blink.cmp").get_lsp_capabilities()
				),
			})

			vim.lsp.enable({
				"angularls",
				"cssls",
				"dockerls",
				"emmet_language_server",
				"html",
				"jdtls",
				"jsonls",
				"lua_ls",
				"tailwindcss",
				"ts_ls",
				"yamlls",
			})

			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
		end,
	},
}
