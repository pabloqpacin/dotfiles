vim.api.nvim_set_keymap('n', '<leader>nt', ':NvimTreeToggle<CR>', { noremap=true, silent=true })

require('nvim-tree').setup {
    -- hijack_netrw = false,
    view = {
        width = 32,
        side = 'right' },
    renderer = {icons = { git_placement = 'after' }},
    git = { ignore = false },
    filters = {
        dotfiles = false,
        custom = { "^\\.git$" }},
    -- actions = { open_file = { quit_on_open = true }},
}


--[[
https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt
    `<C-]>`     CD
    `<C-e>`     Open: In Place
    `<C-k>`     Info
    `<C-r>`     Rename: Omit Filename
    `<C-t>`     Open: New Tab
    `<C-v>`     Open: Vertical Split
    `<C-x>`     Open: Horizontal Split
    `<BS>`      Close Directory
    `<CR>`      Open
    `<Tab>`     Open Preview
    `>`         Next Sibling
    `<`         Previous Sibling
    `.`         Run Command
    `-`         Up
    `a`         Create
    `bmv`       Move Bookmarked
    `B`         Toggle No Buffer
    `c`         Copy
    `C`         Toggle Git Clean
    `[c`        Prev Git
    `]c`        Next Git
    `d`         Delete
    `D`         Trash
    `E`         Expand All
    `e`         Rename: Basename
    `]e`        Next Diagnostic
    `[e`        Prev Diagnostic
    `F`         Clean Filter
    `f`         Filter
    `g?`        Help
    `gy`        Copy Absolute Path
    `H`         Toggle Dotfiles
    `I`         Toggle Git Ignore
    `J`         Last Sibling
    `K`         First Sibling
    `m`         Toggle Bookmark
    `o`         Open
    `O`         Open: No Window Picker
    `p`         Paste
    `P`         Parent Directory
    `q`         Close
    `r`         Rename
    `R`         Refresh
    `s`         Run System
    `S`         Search
    `U`         Toggle Hidden
    `W`         Collapse
    `x`         Cut
    `y`         Copy Name
    `Y`             Copy Relative Path
    `<2-LeftMouse>`   Open
    `<2-RightMouse>`  CD
--]]
