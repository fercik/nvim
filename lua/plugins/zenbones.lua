return {
	"zenbones-theme/zenbones.nvim",
	dependencies = "rktjmp/lush.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd("set background=dark")
		vim.g.rosebones_darken_comments = 45
		vim.g.rosebones_darkness = "warm"
        vim.g.rosebones_lightness = "dim"
		vim.cmd.colorscheme("rosebones")
	end,
}
