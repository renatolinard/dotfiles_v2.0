return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()

        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, {desc = "[A]dd Harpoon"})
        vim.keymap.set("n", "<leader>pv", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, {desc = "[L]ist Harpoons"})

        -- targets
        vim.keymap.set("n", "1", function() harpoon:list():select(1) end, {desc = "[1] to harpoon 1"})
        vim.keymap.set("n", "2", function() harpoon:list():select(2) end, {desc = "[2] to harpoon 2"})
        vim.keymap.set("n", "3", function() harpoon:list():select(3) end, {desc = "[3] to harpoon 3"})
        vim.keymap.set("n", "4", function() harpoon:list():select(4) end, {desc = "[4] to harpoon 4"})

        -- Toggle next buffers stored within Harpoon list
        vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end, {desc = "[P]revious harpoon"})
        vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end, {desc = "[N]ext harpoon"})
    end,
}
