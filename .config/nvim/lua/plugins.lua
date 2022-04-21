local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) then
  vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.api.nvim_command 'packadd packer.nvim'
end

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use {'tzachar/cmp-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-cmp', config = function()
    local tabnine = require('cmp_tabnine.config')
    tabnine:setup({
      max_lines = 1000;
      max_num_results = 20;
      sort = true;
      run_on_every_keystroke = true;
      snippet_placeholder = '..';
    })
  end}
  use {
    'hrsh7th/vim-vsnip',
    config = function()
      vim.cmd([[
        " Jump forward or backward
        imap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
        smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
        imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
        smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
      ]])
    end
  }
  use {
    'hrsh7th/nvim-cmp',
    requires = {'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-vsnip'},
    config = function()
      local cmp = require'cmp'
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
          { name = 'buffer' },
          { name = 'cmp_tabnine' },
        })
      })
    end
  }
  use {
    'neovim/nvim-lspconfig',
    config = function()
      local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
      local lspconfig = require'lspconfig'
      lspconfig.clangd.setup{
        cmd = { 'clangd',
                '--background-index',
                '--compile-commands-dir=build',
                '--clang-tidy', '--cross-file-rename',
                '--header-insertion=iwyu',
                '--header-insertion-decorators'
              },
        filetypes = { 'c', 'cc', 'cpp', 'h', 'hpp' },
        root_dir = lspconfig.util.root_pattern('compile_commands.json',
                                               'compile_flags.txt',
                                               '.git',
                                               'build'),
        capabilities = capabilities
      }

      lspconfig.cmake.setup{}
      lspconfig.pylsp.setup{}
      lspconfig.dockerls.setup{}

      vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', 'gR', '<cmd>lua vim.lsp.buf.references()<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.rename()<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<C-n>', '<cmd>lua vim.diagnostic.goto_next()<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<C-p>', '<cmd>lua vim.diagnostic.goto_prev()<CR>', {noremap = true, silent = true})
    end
  }
  use {
    'APZelos/blamer.nvim',
    config = function()
      vim.g.blamer_enabled = true
      vim.g.blamer_delay = 300
      vim.g.blamer_date_format = '%d %b %Y %H:%M'
    end
  }
  use {
    'mhinz/vim-signify',
    config = function()
      vim.g.signify_sign_add = '+'
      vim.g.signify_sign_delete = '_'
      vim.g.signify_sign_delete_first_line = '-'
      vim.g.signify_sign_change = '~'
      vim.g.signify_sign_show_count = 0
      vim.g.signify_sign_show_text = 1
    end
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'},
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>lua require(\'telescope.builtin\').find_files()<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>lua require(\'telescope.builtin\').live_grep()<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>lua require(\'telescope.builtin\').buffers()<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>lua require(\'telescope.builtin\').help_tags()<CR>', {noremap = true, silent = true})
    end
  }
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require'colorizer'.setup()
    end
  }
  use 'tpope/vim-fugitive'
  use 'Yggdroot/indentLine'
  use 'itchyny/lightline.vim'
  use 'rakr/vim-one'
  use 'tomasiser/vim-code-dark'
  use 'kyazdani42/nvim-web-devicons'
end)
