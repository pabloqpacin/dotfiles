local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local telescope = require('telescope')

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})

vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input('Grep > ') })
end)

telescope.setup {
    defaults = {mappings = {i = {
        ['<C-j>']=actions.move_selection_next,
        ['<C-k>']=actions.move_selection_previous}
}}}
