return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	keys = {
		{ "<leader>kk", function() require("conform").format({ lsp_format = "fallback" }) end, desc = "Format current file" },
	},
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
			markdown = { "markdownlint", "prettier", stop_after_first = true },
		},
	},
}
