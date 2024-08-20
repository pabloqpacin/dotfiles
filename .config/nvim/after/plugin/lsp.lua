local lsp = require('lsp-zero')

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

lsp.preset('recommended')

lsp.ensure_installed ({
--  'ansiblels',
--  'arduino_language_server',
    'bashls',
--  'bash-debug-adapter',       -- works alright
--  'clangd',
--  'cpptools',                 -- requires DAP bs
    'cssls',
--  'denols',
    'dockerls',
    'docker_compose_language_service',
    'emmet_ls',                 -- provides :html:5
--  'gopls',
    'html',
    'lua_ls',
    'marksman',                 -- provides :vws :vca=>TOC
--  'phpactor',                 -- requires composer pkg
--  'phpstan',                  -- requires manual Mason installation
    'powershell_es',
--  'pylsp',
    'rust_analyzer',
--  'sqlls',                    -- https://github.com/joe-re/sql-language-server
    'tsserver',
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
})

lsp.set_preferences({
    sign_icons = { }
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.on_attach(function(client, bufnr)
        print("help")
    local opts = { buffer = bufnr, remap = false }

    -- <C-o> goes back to file from definition
    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set('n', '<leader>vca', function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end, opts)
    vim.keymap.set('n', '<leader>vrn', function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
end)


lsp.setup()

