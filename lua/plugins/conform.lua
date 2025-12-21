return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			scss = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
			htmlangular = { "prettierd", "prettier", stop_after_first = true },
			json = { "prettierd", "prettier", stop_after_first = true },
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
