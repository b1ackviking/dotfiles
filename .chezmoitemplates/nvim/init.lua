vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>h', ':set hlsearch!<CR>', {})
vim.keymap.set('v', '<', '<gv', {})
vim.keymap.set('v', '>', '>gv', {})

vim.o.winborder = 'rounded'
vim.o.path = vim.o.path .. '**'
vim.o.wildmenu = true
-- Ignore compiled files
vim.o.wildignore = '*.o,*~,*.pyc'
if (vim.fn.has('win16') or vim.fn.has('win32')) ~= 0 then
  vim.o.wildignore = vim.o.wildignore .. ',.git\\*,.hg\\*,.svn\\*'
else
  vim.o.wildignore = vim.o.wildignore .. ',*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store'
end

vim.o.splitright    = false
vim.o.splitbelow    = false
vim.o.laststatus    = 3
vim.o.updatetime    = 300
vim.o.showcmd       = true
vim.o.showmode      = false
vim.o.ruler         = true
vim.o.cursorline    = false
vim.o.scrolloff     = 8

vim.o.autoindent    = true
vim.o.smartindent   = true
vim.o.shiftwidth    = 2
vim.o.tabstop       = 2
vim.o.smarttab      = true
vim.o.expandtab     = true
vim.o.number        = true

vim.o.incsearch     = true
vim.o.smartcase     = true
vim.o.hlsearch      = true

vim.o.foldmethod    = 'expr'
vim.o.foldexpr      = 'nvim_treesitter#foldexpr()'
vim.o.foldenable    = false

vim.o.wrap          = true
vim.o.linebreak     = true
vim.o.smoothscroll  = true

vim.o.guifont       = 'JetBrainsMono Nerd Font:h12'
vim.o.mouse         = 'a'

vim.o.spelllang     = 'en_us'
vim.o.spell         = true

vim.o.background    = 'dark'
vim.o.termguicolors = true

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = { '*.c', '*.cc', '*.cpp', '*.h', '*.hh', '*.hpp', '*.cmake', 'CMakeLists.txt',
    '*.py', '*.lua', '*.luau', '*.rs', '*.js', '*.ts' },
  callback = function() vim.lsp.buf.format() end
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

-- Snippets
vim.keymap.set({ 'i', 's' }, '<Tab>', function()
  if vim.snippet.active({ direction = 1 }) then
    vim.schedule(function()
      vim.snippet.jump(1)
    end)
  else
    return '<Tab>'
  end
end, { expr = true, silent = true })
vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
  if vim.snippet.active({ direction = -1 }) then
    vim.schedule(function()
      vim.snippet.jump(-1)
    end)
  else
    return '<S-Tab>'
  end
end, { expr = true, silent = true })

-- LSP
vim.diagnostic.config({
  virtual_lines = {
    current_line = true,
  },
})

vim.lsp.config('*', {
  root_markers = {
    '.git', '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json',
    'compile_flags.txt', 'configure.ac', 'pyproject.toml', 'setup.py',
    'setup.cfg', 'requirements.txt', 'Pipfile', '.luarc.json', '.luarc.jsonc',
    '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml',
  }
})

{{ if eq .chezmoi.os "darwin" -}}
local brew_llvm_path = vim.fn.system('brew --prefix llvm'):gsub('%s+', '')
{{- end }}
local clangd_path = brew_llvm_path and (brew_llvm_path .. '/bin/clangd') or 'clangd'
vim.lsp.config.clangd = {
  cmd = {
    clangd_path,
    '--enable-config',
    '--background-index',
    '--clang-tidy',
    '--header-insertion=iwyu',
    '--header-insertion-decorators',
    '--query-driver="/**/*"',
    '--completion-style=bundled',
  },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto', 'javascript' },
}
vim.lsp.config.cmake = {
  cmd = { 'cmake-language-server' },
  filetypes = { 'cmake' },
  init_options = { buildDirectory = 'build' },
}
vim.lsp.config.pylsp = {
  cmd = { 'pylsp' },
  filetypes = { 'python' },
}
vim.lsp.config.luals = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT', },
      diagnostics = { globals = { 'vim' }, },
      workspace = { library = vim.api.nvim_get_runtime_file('', true), },
      telemetry = { enable = false, },
    }
  },
}
vim.lsp.enable({ 'clangd', 'cmake', 'pylsp', 'luals' })

vim.keymap.del('n', 'gO')
vim.keymap.del('n', 'gra')
vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'grn')
vim.keymap.del('n', 'grr')
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {})
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
vim.keymap.set('n', 'gR', vim.lsp.buf.references, {})
vim.keymap.set('n', 'gr', vim.lsp.buf.rename, {})
vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, {})
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, {})
vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, {})
vim.keymap.set('n', '<leader>i',
  function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end,
  {})

-- Plugins
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer' },
    config = function()
      local cmp = require 'cmp'
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
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
          { name = 'buffer' },
        })
      })
    end
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require 'gitsigns'.setup {
        current_line_blame = true,
        current_line_blame_opts = {
          delay = 300,
        },
        current_line_blame_formatter = '<author>, <author_time:%d %b %Y %H:%M> - <summary>',
      }
    end
  },
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require 'colorizer'.setup()
    end
  },
  'Yggdroot/indentLine',
  {
    'Mofiqul/vscode.nvim',
    config = function()
      local theme = require('vscode')
      theme.setup {
        transparent = true,
        disable_nvimtree_bg = true
      }
    end
  },
  {
    'ellisonleao/gruvbox.nvim',
    config = function()
      local theme = require('gruvbox')
      theme.setup {
        transparent_mode = true,
      }
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require 'lualine'.setup {
        options = {
          theme = 'auto'
        }
      }
    end
  },
  {
    'kyazdani42/nvim-tree.lua',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require 'nvim-tree'.setup {}
      vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<CR>', {})
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
      vim.keymap.set('n', '<leader>fr', builtin.lsp_references, { desc = 'Telescope LSP references' })
    end
  },
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require('dap')
      dap.adapters.lldb = {
        type = 'executable',
        command = 'lldb-vscode',
        name = 'lldb'
      }

      dap.configurations.cpp = {
        {
          name = 'lldb-vscode',
          type = 'lldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
        },
      }

      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp

      vim.keymap.set('n', '<F5>', dap.continue, {})
      vim.keymap.set('n', '<F8>', dap.terminate, {})
      vim.keymap.set('n', '<F9>', dap.toggle_breakpoint, {})
      vim.keymap.set('n', '<F10>', dap.step_over, {})
      vim.keymap.set('n', '<F11>', dap.step_into, {})
      vim.keymap.set('n', '<F12>', dap.step_out, {})
    end
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup {
        layouts = {
          {
            -- You can change the order of elements in the sidebar
            elements = {
              -- Provide IDs as strings or tables with "id" and "size" keys
              {
                id = 'scopes',
                size = 0.25, -- Can be float or integer > 1
              },
              { id = 'breakpoints', size = 0.25 },
              { id = 'stacks',      size = 0.25 },
              { id = 'watches',     size = 0.25 },
            },
            size = 40,
            position = "left", -- Can be "left" or "right"
          },
          {
            elements = {
              'repl',
            },
            size = 10,
            position = "bottom", -- Can be "bottom" or "top"
          },
        },
      }
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  }
})

vim.cmd.colorscheme "vscode"
-- vim.cmd.colorscheme "gruvbox"
