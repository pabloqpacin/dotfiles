vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use ('navarasu/onedark.nvim')
    use ('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use ('nvim-treesitter/playground')
    use ('theprimeagen/harpoon')
    use ('mbbill/undotree')
    use ('tpope/vim-fugitive')
    use ('lewis6991/gitsigns.nvim')

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

--[[
-- HTML/CSS/JS//XML...
    -- use ('mattn/emmet-vim') -- HTML stuff
    -- deno for running JS aka live server ish?
-- use ('tpope/vim-surround')
-- PWSH? SQL?
-- use ('tpope/vim-dadbod') -- MySQL stuff
-- use ('nanotee/sqls.nvim')
-- cpptools, cmake stuff
-- markdown at all
--]]

end)
    
