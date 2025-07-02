return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		local eslint_config_files = {
			"eslint.config.mjs",
			".eslintrc",
			".eslintrc.js",
			".eslintrc.cjs",
			".eslintrc.json",
			".eslintrc.yaml",
			".eslintrc.yml",
		}

		null_ls.setup({
			debug = true,
			ensure_installed = { "eslint_d", "stylua", "prettierd", "emmet_language_server" },
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettierd,
				require("none-ls.diagnostics.eslint_d").with({
					condition = function(utils)
						return utils.root_has_file(eslint_config_files)
					end,
				}),
				require("none-ls.code_actions.eslint_d").with({
					condition = function(utils)
						return utils.root_has_file(eslint_config_files)
					end,
				}),
			},
		})

		vim.keymap.set("n", "<leader>kk", vim.lsp.buf.format, { desc = "Format code" })
	end,
}
