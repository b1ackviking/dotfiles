require('plugins')

vim.g.mapleader = ' '
vim.api.nvim_set_keymap('n', '<leader>h', ':set hlsearch!<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<', '<gv', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '>', '>gv', {noremap = true, silent = true})

vim.o.path = vim.o.path..'**'
vim.o.wildmenu = true
-- Ignore compiled files
vim.o.wildignore = '*.o,*~,*.pyc'
if vim.api.nvim_call_function('has', {'win16'}) or
   vim.api.nvim_call_function('has', {'win32'}) then
  vim.o.wildignore = vim.o.wildignore..',.git\\*,.hg\\*,.svn\\*'
else
  vim.o.wildignore = vim.o.wildignore..',*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store'
end

vim.o.updatetime = 300
vim.o.showcmd = true
vim.o.showmode = true
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

vim.api.nvim_create_autocmd({'BufWritePre'}, {
  pattern = {'*.c', '*.cc', '*.cpp', '*.h', '*.hh', '*.hpp', '*.cmake', 'CMakeLists.txt', '*.py'},
  callback = function() vim.lsp.buf.formatting_sync(nil, 1000) end
})

vim.api.nvim_create_autocmd({'InsertEnter'}, {
  pattern = {'*'},
  callback = function() vim.api.nvim_set_option_value('rnu', false, {scope = 'local'}) end
})

vim.api.nvim_create_autocmd({'InsertLeave'}, {
  pattern = {'*'},
  callback = function() vim.api.nvim_set_option_value('rnu', true, {scope = 'local'}) end
})

vim.api.nvim_create_autocmd({'BufLeave'}, {
  pattern = {'*'},
  callback = function() vim.api.nvim_set_option_value('rnu', false, {scope = 'local'}) end
})

vim.api.nvim_create_autocmd({'BufEnter'}, {
  pattern = {'*'},
  callback = function()
    vim.api.nvim_set_option_value('rnu', vim.api.nvim_get_mode()['mode'] ~= 'i', {scope = 'local'})
  end
})

vim.cmd([[
colorscheme codedark
highlight Normal ctermbg=none guibg=none
highlight NonText ctermbg=none guibg=none
highlight EndOfBuffer ctermbg=none guibg=none

if (has("termguicolors"))
  set termguicolors
  hi LineNr ctermbg=none guibg=none
endif
]])
