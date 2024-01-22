local OS = package.config:sub(1,1) == "\\" and "Windows" or "Linux"


vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
if OS == "Linux" then
    vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
else vim.opt.undodir = os.getenv("LOCALAPPDATA") .. "/nvim-data/undodir"
end
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = '80,115'

vim.opt.clipboard = 'unnamedplus'
