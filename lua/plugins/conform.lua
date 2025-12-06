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
			htmlangular = {  "prettier", stop_after_first = true },
			json = { "prettier", stop_after_first = true },
		},
	},
}
