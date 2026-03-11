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

			local function apply_local_lsp_config(server)
				local path = vim.fs.joinpath(vim.fn.stdpath("config"), "lsp", server .. ".lua")
				if not vim.uv.fs_stat(path) then
					return
				end

				local ok_loader, loader = pcall(loadfile, path)
				if not ok_loader or type(loader) ~= "function" then
					return
				end

				local ok_config, config = pcall(loader)
				if ok_config and type(config) == "table" then
					vim.lsp.config(server, config)
				end
			end

			for _, server in ipairs({
				"angularls",
				"cssls",
				"emmet_language_server",
				"html",
				"jdtls",
				"lua_ls",
				"ts_ls",
			}) do
				apply_local_lsp_config(server)
			end

			vim.lsp.enable({
				"angularls",
				"cssls",
				"dockerls",
				"emmet_language_server",
				"html",
				"jdtls",
				"jsonls",
				"lua_ls",
				"ts_ls",
				"yamlls",
			})

			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
		end,
	},
}
