return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettier", stop_after_first = true },
			typescript = { "prettier", stop_after_first = true },
			css = { "prettier", stop_after_first = true },
			scss = { "prettier", stop_after_first = true },
			html = { "prettier", stop_after_first = true },
			htmlangular = { "prettier", stop_after_first = true },
			json = { "prettier", stop_after_first = true },
		},
	},
	config = function(_, opts)
		require("conform").setup(opts)

		vim.keymap.set("n", "<leader>kk", function()
			require("conform").format({
				lsp_format = "fallback",
			})
		end, { desc = "Format current file" })
	end,
}
