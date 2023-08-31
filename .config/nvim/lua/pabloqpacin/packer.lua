vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use ('navarasu/onedark.nvim')
    -- use  {'rose-pine/neovim', as = 'rose-pine',
    --     config = function() vim.cmd('colorscheme rose-pine') end }
    use ('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use ('nvim-treesitter/playground')
    use ('theprimeagen/harpoon')
    use ('mbbill/undotree')
    use ('tpope/vim-fugitive')
    use {'lewis6991/gitsigns.nvim', config = function() require('gitsigns').setup() end }

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {                                      -- Optional
            'williamboman/mason.nvim',
            run = function()
                pcall(vim.cmd, 'MasonUpdate')
            end,
            },
            {'williamboman/mason-lspconfig.nvim'}, -- Optional

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},     -- Required
            {'hrsh7th/cmp-nvim-lsp'}, -- Required
            {'L3MON4D3/LuaSnip'},     -- Required
        }
    }

    -- use { 'toppair/peek.nvim', run = 'deno task --quiet build:fast' }
    -- use { 'manzeloth/live-server' }
    use { 'windwp/nvim-autopairs', config = function() require('nvim-autopairs').setup() end }
    use { 'norcalli/nvim-colorizer.lua', config = function() require('colorizer').setup() end }
    use { 'nvim-tree/nvim-web-devicons' }
    use { 'nvim-tree/nvim-tree.lua' }
    use { 'romgrk/barbar.nvim' }
    use {
        'rcarriga/nvim-dap-ui',
        requires = { 'mfussenegger/nvim-dap' }
    }
    use { 'elkowar/yuck.vim' }


--[[
    -- DAP: debuggin and compilin -- cpptools cmake rust
    -- XML/JS_html_css: ...live-server -- deno?
    -- PWSH? SQL?: use ('tpope/vim-dadbod'); use ('nanotee/sqls.nvim')
--]]

end)
