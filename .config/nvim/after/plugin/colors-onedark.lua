-- Colorscheme issues -- likely remove these lines for other colorschemes!
vim.api.nvim_create_autocmd('Colorscheme', {
    group = vim.api.nvim_create_augroup('config_custom_highlights', {}),
    callback = function()
      -- Override onedark default highlighting over barbar's gitsigns
      vim.api.nvim_set_hl(0, 'BufferCurrentADDED',   {bg = '#020508', fg = '#7EA662'})
      vim.api.nvim_set_hl(0, 'BufferCurrentCHANGED', {bg = '#020508', fg = '#4FA6ED'})
      vim.api.nvim_set_hl(0, 'BufferCurrentDELETED', {bg = '#020508', fg = '#E55561'})
    end,
})

require('onedark').setup {
    style = 'darker',
    transparent = true,
    code_style = { comments = 'none' },
}

require('onedark').load()
