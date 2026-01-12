return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>hl", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "[H]arpoon [L]ist" },
            { "<leader>ha", function() require("harpoon"):list():add() end, desc = "[H]arpoon [A]dd" },
            { "<leader>hn", function() require("harpoon"):list():next() end, desc = "[H]arpoon [N]ext" },
            { "<leader>hb", function() require("harpoon"):list():prev() end, desc = "[H]arpoon [B]ack" },
        },
        config = function()
            require("harpoon").setup({})
        end,
    },
}
