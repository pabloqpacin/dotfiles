-- vim.keymap.set("n", "<leader>gh", require("gitsigns").stage_hunk, { noremap = true, silent = true, desc = "Stage Git hunk" })
vim.keymap.set("n", "<leader>sh", require("gitsigns").stage_hunk, {
    noremap = true, silent = true, desc = "Stage Git hunk"
})

vim.keymap.set("n", "<leader>ush", require("gitsigns").undo_stage_hunk, {
    noremap = true, silent = true, desc = "Stage Git hunk"
})
