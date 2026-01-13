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
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"angularls",
					"html",
					"cssls",
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

			vim.lsp.enable("angularls")
			vim.lsp.enable("ts_ls")
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("emmet_language_server")
			vim.lsp.enable("html")
			vim.lsp.enable("cssls")
			vim.lsp.enable("jdtls")
			vim.lsp.enable("yamlls")
			vim.lsp.enable("dockerls")
			vim.lsp.enable("jsonls")

			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
		end,
	},
}
