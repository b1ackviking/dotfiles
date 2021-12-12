require('plugins')

vim.g.mapleader = ' '
vim.api.nvim_set_keymap('n', '<leader>h', ':set hlsearch!<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<', '<gv', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '>', '>gv', {noremap = true, silent = true})

vim.o.wildmenu = true

vim.o.updatetime = 300
vim.o.showcmd = true
vim.o.showmode = true
vim.o.ruler = true
vim.o.cursorline = true
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

vim.o.guifont='JetBrainsMono Nerd Font:h10'
vim.o.mouse='a'

vim.cmd([[

set path+=**

colorscheme codedark

autocmd BufWritePre *.c,*.cc,*.cpp,*.h,*.hh,*.hpp lua vim.lsp.buf.formatting_sync(nil, 1000)

" checks if your terminal has 24-bit color support
if (has("termguicolors"))
    set termguicolors
    hi LineNr ctermbg=NONE guibg=NONE
endif

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Toggle relative numbering, and set to absolute on loss of focus or insert mode
autocmd InsertEnter * :set nornu
autocmd InsertLeave * :set rnu
" we don't want to see relative numbering while debugging
" debugger uses its own window, so we can disable rnu when source window loses
" focus
autocmd BufLeave * :set nornu
autocmd BufEnter * call SetRNU()
function! SetRNU()
  if (mode() != 'i')
    set rnu 
  endif
endfunction
]])
