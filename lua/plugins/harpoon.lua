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

            vim.keymap.set("n", "<leader>hl", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end, { desc = "[H]arpoon [L]ist" })
            vim.keymap.set("n", "<leader>ha", function()
                harpoon:list():add()
            end, { desc = "[H]arpoon [A]dd" })
            vim.keymap.set("n", "<leader>hn", function()
                harpoon:list():next()
            end, { desc = "[H]arpoon [N]ext" })
            vim.keymap.set("n", "<leader>hb", function()
                harpoon:list():prev()
            end, { desc = "[H]arpoon [B]ack" })
        end,
    },
}
