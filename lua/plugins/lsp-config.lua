return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "angularls",
                    "cssls",
                    "dockerls",
                    "groovyls",
                    "html",
                    "jdtls",
                    "eslint",
                    "ts_ls",
                    "jsonls",
                    "yamlls",
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
        end,
    }
}
