return {
    "luckasRanarison/tailwind-tools.nvim",
    version = "0.3.2",
    name = "tailwind-tools",
    build = ":UpdateRemotePlugins",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-telescope/telescope.nvim", -- optional
        "neovim/nvim-lspconfig",         -- optional
    },
    opts = {},
}
