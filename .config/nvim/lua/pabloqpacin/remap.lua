vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

vim.keymap.set({'i','v'}, 'kj', '<Esc>', { noremap = true })
vim.keymap.set('n', '<leader>vb', '<C-v>')  -- VISUAL BLOCK else incompatible WSL & TMUX

-- Move selected lines up & down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Keep cursosr mid-screen during C-d & C-u
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Keep cursor mid-screen for next search-terms (/foo)
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Paste selected A into selected B and preserve A
vim.keymap.set('x', '<leader>p', "\"_dP")

-- Prompt for 'chmod 111'
vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true })

-- Word under cursosr is picked for substitution-global
vim.keymap.set('n', '<leader>s', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>')

-- ...

-- Unhighlight search matches -- mind set.lua!
vim.keymap.set('n', '<leader>/', vim.cmd.nohlsearch)

-- Open split terminal
vim.keymap.set('n', '<leader>t', ':lua OpenTerminal()<CR>')
function OpenTerminal()
    vim.cmd('split term://$SHELL')
    vim.cmd('startinsert')
end

-- Exit terminal mode (ie. for debugging)
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })

--[[
-- Build and run C++ file
vim.api.nvim_set_keymap('n', '<leader>br',
    ':!g++ % -o %< && chmod +x %< && ./%<<CR>',
    { noremap = true, silent = true })
    -- not quite OK, doesn't allow user input or such
--]]