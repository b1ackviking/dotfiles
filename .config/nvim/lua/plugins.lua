local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) then
  vim.fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
  vim.api.nvim_command 'packadd packer.nvim'
end

local packer = require('packer')
packer.startup(function()
  -- Packer can manage itself
  packer.use 'wbthomason/packer.nvim'
  packer.use {
    'tzachar/cmp-tabnine',
    run = './install.sh',
    requires = 'hrsh7th/nvim-cmp',
    config = function()
      local tabnine = require('cmp_tabnine.config')
      tabnine:setup({
        max_lines = 1000;
        max_num_results = 20;
        sort = true;
        run_on_every_keystroke = true;
        snippet_placeholder = '..';
      })
    end
  }
  packer.use {
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
  packer.use {
    'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-vsnip' },
    config = function()
      local cmp = require 'cmp'
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
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
  packer.use {
    'neovim/nvim-lspconfig',
    config = function()
      local capabilities = require('cmp_nvim_lsp').update_capabilities(
        vim.lsp.protocol.make_client_capabilities())
      local lspconfig = require 'lspconfig'
      lspconfig.clangd.setup {
        cmd = {
          'clangd',
          '--enable-config',
          '--background-index',
          '--compile-commands-dir=build',
          '--clang-tidy',
          '--header-insertion=iwyu',
          '--header-insertion-decorators',
          '--query-driver="/**/*"'
        },
        filetypes = { 'c', 'cc', 'cpp', 'h', 'hpp' },
        root_dir = lspconfig.util.root_pattern(
          '.clangd',
          '.clang-format',
          '.clang-tidy',
          'compile_commands.json',
          'compile_flags.txt',
          '.git',
          'build'),
        capabilities = capabilities
      }

      lspconfig.cmake.setup {}
      lspconfig.pylsp.setup {}
      lspconfig.dockerls.setup {}
      lspconfig.sumneko_lua.setup {
        settings = {
          Lua = {
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
            },
          }
        }
      }
      vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { silent = true })
      vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { silent = true })
      vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { silent = true })
      vim.keymap.set('n', 'gR', '<cmd>lua vim.lsp.buf.references()<CR>', { silent = true })
      vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.rename()<CR>', { silent = true })
      vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', { silent = true })
      vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { silent = true })
      vim.keymap.set('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { silent = true })
      vim.keymap.set('n', '<C-n>', '<cmd>lua vim.diagnostic.goto_next()<CR>', { silent = true })
      vim.keymap.set('n', '<C-p>', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { silent = true })
    end
  }
  packer.use {
    'APZelos/blamer.nvim',
    config = function()
      vim.g.blamer_enabled = true
      vim.g.blamer_delay = 300
      vim.g.blamer_date_format = '%d %b %Y %H:%M'
    end
  }
  packer.use {
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
  packer.use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
    config = function()
      vim.keymap.set(
        'n', '<leader>ff', '<cmd>lua require(\'telescope.builtin\').find_files()<CR>',
        { silent = true })
      vim.keymap.set(
        'n', '<leader>fg', '<cmd>lua require(\'telescope.builtin\').live_grep()<CR>',
        { silent = true })
      vim.keymap.set(
        'n', '<leader>fb', '<cmd>lua require(\'telescope.builtin\').buffers()<CR>',
        { silent = true })
      vim.keymap.set(
        'n', '<leader>fh', '<cmd>lua require(\'telescope.builtin\').help_tags()<CR>',
        { silent = true })
    end
  }
  packer.use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require 'colorizer'.setup()
    end
  }
  packer.use 'Yggdroot/indentLine'
  packer.use {
    'Mofiqul/vscode.nvim',
    config = function()
      require 'vscode'.setup {
        transparent = true,
        disable_nvimtree_bg = true
      }
    end
  }
  packer.use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require 'lualine'.setup {
        options = {
          theme = 'codedark'
        }
      }
    end
  }
  packer.use 'kyazdani42/nvim-web-devicons'
  packer.use {
    'kyazdani42/nvim-tree.lua',
    config = function()
      require 'nvim-tree'.setup {}
    end
  }
  packer.use {
    'ilyachur/cmake4vim',
    config = function()
      vim.g.cmake_build_dir = 'build'
      vim.g.cmake_ctest_args = '--progress --output-on-failure'
    end
  }
  packer.use 'alepez/vim-gtest'
  packer.use 'editorconfig/editorconfig-vim'
end)
