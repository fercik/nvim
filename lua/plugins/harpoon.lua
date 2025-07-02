return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon.setup({})

            vim.keymap.set("n", "<leader>fl", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end, { desc = "Harpoon:list" })
            vim.keymap.set("n", "<leader>fi", function()
                harpoon:list():add()
            end, { desc = "Harpoon:add" })
        end,
    },
}
