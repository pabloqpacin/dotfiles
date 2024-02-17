require 'nvim-treesitter.configs'.setup {
    -- ...
    ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query' },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        -- additional_vim_regex_highlighting = 'php',
    },
}

-- https://marioyepes.com/blog/neovim-ide-with-lua-for-web-development/
