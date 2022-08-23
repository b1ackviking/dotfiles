require('plugins')

vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>h', ':set hlsearch!<CR>', { silent = true })
vim.keymap.set('v', '<', '<gv', { silent = true })
vim.keymap.set('v', '>', '>gv', { silent = true })

vim.o.path = vim.o.path .. '**'
vim.o.wildmenu = true
-- Ignore compiled files
vim.o.wildignore = '*.o,*~,*.pyc'
if vim.fn['has']('win16') or vim.fn['has']('win32') then
  vim.o.wildignore = vim.o.wildignore .. ',.git\\*,.hg\\*,.svn\\*'
else
  vim.o.wildignore = vim.o.wildignore .. ',*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store'
end

vim.o.splitright = false
vim.o.splitbelow = false
vim.o.laststatus = 3
vim.o.updatetime = 300
vim.o.showcmd = true
vim.o.showmode = false
vim.o.ruler = true
vim.o.cursorline = false
vim.o.scrolloff = 8

vim.o.autoindent = true
vim.o.smartindent = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.number = true

vim.o.incsearch = true
vim.o.smartcase = true
vim.o.hlsearch = true

vim.o.foldmethod = 'syntax'
vim.o.foldenable = false

vim.o.wrap = true
vim.o.linebreak = true

vim.o.guifont = 'JetBrainsMono Nerd Font:h10'
vim.o.mouse = 'a'

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = { '*.c', '*.cc', '*.cpp', '*.h', '*.hh', '*.hpp', '*.cmake', 'CMakeLists.txt',
    '*.py', '*.lua' },
  callback = function() vim.lsp.buf.formatting_sync(nil, 1000) end
})

vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
  pattern = { '*' },
  callback = function() vim.api.nvim_set_option_value('rnu', false, { scope = 'local' }) end
})

vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
  pattern = { '*' },
  callback = function() vim.api.nvim_set_option_value('rnu', true, { scope = 'local' }) end
})

vim.api.nvim_create_autocmd({ 'BufLeave' }, {
  pattern = { '*' },
  callback = function() vim.api.nvim_set_option_value('rnu', false, { scope = 'local' }) end
})

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  pattern = { '*' },
  callback = function()
    vim.api.nvim_set_option_value(
      'rnu', vim.api.nvim_get_mode()['mode'] ~= 'i', { scope = 'local' })
  end
})

vim.o.termguicolors = true
vim.o.background = 'dark'
vim.cmd('colorscheme vscode')
