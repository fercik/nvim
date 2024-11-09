return {
    "nvim-treesitter/nvim-treesitter", 
    build = ":TSUpdate",
    config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            ensure_installed = { "lua", "javascript", "java", "groovy", "html", "jsdoc", "typescript", "angular" },
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}
