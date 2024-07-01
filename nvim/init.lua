vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.signcolumn = 'yes'
vim.o.colorcolumn = '80'
vim.o.termguicolors = true
vim.o.wrap = false
vim.o.hlsearch = false
vim.o.scrolloff = 8
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.shiftround = true
vim.o.showmode = false
vim.o.clipboard = 'unnamedplus'

vim.g.mapleader = ' '
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath
    })
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    {
        'folke/tokyonight.nvim',
        lazy = false,
        priority = 1000,
        opts = {}
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate'
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {}
    },
    {
        'nvim-tree/nvim-tree.lua',
        version = '*',
        lazy = false,
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {
        'akinsho/bufferline.nvim',
        version = '*',
        dependencies = 'nvim-tree/nvim-web-devicons'
    },
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = true
    },
    'neovim/nvim-lspconfig',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'saadparwaiz1/cmp_luasnip',
    'L3MON4D3/LuaSnip',
    {
        'ThePrimeagen/harpoon',
        dependencies = 'nvim-lua/plenary.nvim'
    },
    'tpope/vim-fugitive',
    'hrsh7th/cmp-nvim-lsp-signature-help'
})

require('nvim-treesitter.configs').setup({
    ensure_installed = {
        'c', 'lua', 'vim', 'vimdoc', 'query',
        'cpp', 'javascript', 'typescript'
    },
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true }
})

require('nvim-tree').setup {
    actions = {
        open_file = {
            quit_on_open = true
        }
    }
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspconfig = require('lspconfig')

lspconfig.clangd.setup {
    cmd = { 'clangd', '--header-insertion=never' },
    capabilities = capabilities,
    on_attach = function()
        vim.keymap.set('n', '<leader>s', '<cmd>ClangdSwitchSourceHeader<cr>', opts)
    end
}

local servers = { 'tsserver', 'eslint' }
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        capabilities = capabilities
    }
end

local luasnip = require 'luasnip'

local cmp = require 'cmp'
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'nvim_lsp_signature_help' }
    }
}

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)

vim.cmd.colorscheme('tokyonight')

require('bufferline').setup()

vim.keymap.set('i', 'jk', '<esc>')
vim.keymap.set('i', 'jK', '<esc>')
vim.keymap.set('i', 'Jk', '<esc>')
vim.keymap.set('i', 'JK', '<esc>')

vim.keymap.set('i', 'kj', '<esc>')
vim.keymap.set('i', 'kJ', '<esc>')
vim.keymap.set('i', 'Kj', '<esc>')
vim.keymap.set('i', 'KJ', '<esc>')

vim.keymap.set('n', '<leader>w', '<cmd>w<cr>')

vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')
vim.keymap.set('n', '<m-q>', '<cmd>q!<cr>')
vim.keymap.set('n', '<m-o>', '<cmd>on<cr>')

local silent = { silent = true }
vim.keymap.set('n', '<a-j>', ':m .+1<cr>==', silent)
vim.keymap.set('n', '<a-k>', ':m .-2<cr>==', silent)
vim.keymap.set('i', '<a-j>', '<esc>:m .+1<cr>==gi', silent)
vim.keymap.set('i', '<a-k>', '<esc>:m .-2<cr>==gi', silent)
vim.keymap.set('v', '<a-j>', ':m \'>+1<cr>gv=gv', silent)
vim.keymap.set('v', '<a-k>', ':m \'<-2<cr>gv=gv', silent)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files)
vim.keymap.set('n', '<leader>fF', builtin.git_files)
vim.keymap.set('n', '<leader>fg', builtin.live_grep)
vim.keymap.set('n', '<leader>fG', builtin.grep_string)
vim.keymap.set('n', '<leader>fb', builtin.buffers)
vim.keymap.set('n', '<leader>fh', builtin.help_tags)
vim.keymap.set('n', '<leader>fd', builtin.diagnostics)

vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeFindFileToggle<cr>')

vim.keymap.set('n', '<tab>', '<cmd>BufferLineCycleNext<cr>')
vim.keymap.set('n', '<s-tab>', '<cmd>BufferLineCyclePrev<cr>')
vim.keymap.set('n', '<leader>q', '<cmd>bd!<cr>')
vim.keymap.set('n', '<leader>o', '<cmd>BufferLineCloseOthers<cr>')

local mark = require('harpoon.mark')
local ui = require('harpoon.ui')

vim.keymap.set('n', '<leader>a', mark.add_file)
vim.keymap.set('n', '<leader>m', ui.toggle_quick_menu)

vim.keymap.set('n', '<a-1>', function() ui.nav_file(1) end)
vim.keymap.set('n', '<a-2>', function() ui.nav_file(2) end)
vim.keymap.set('n', '<a-3>', function() ui.nav_file(3) end)
vim.keymap.set('n', '<a-4>', function() ui.nav_file(4) end)
vim.keymap.set('n', '<a-5>', function() ui.nav_file(5) end)
vim.keymap.set('n', '<a-6>', function() ui.nav_file(6) end)
vim.keymap.set('n', '<a-7>', function() ui.nav_file(7) end)
vim.keymap.set('n', '<a-8>', function() ui.nav_file(8) end)
vim.keymap.set('n', '<a-9>', function() ui.nav_file(9) end)

vim.keymap.set('n', '<c-p>', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<c-n>', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>j', vim.diagnostic.goto_next)

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', builtin.lsp_references, opts)
        vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, opts)
        vim.keymap.set('n', '<leader>fS', builtin.lsp_workspace_symbols, opts)
    end
})

local actions = require('telescope.actions')

require('telescope').setup{
    defaults = {
        mappings = {
            i = {
                ['jk'] = actions.close,
                ['jK'] = actions.close,
                ['Jk'] = actions.close,
                ['JK'] = actions.close,

                ['kj'] = actions.close,
                ['kJ'] = actions.close,
                ['Kj'] = actions.close,
                ['KJ'] = actions.close,

                ['<tab>'] = actions.move_selection_previous,
                ['<s-tab>'] = actions.move_selection_next
            }
        }
    }
}

cmp.setup {
    mapping = cmp.mapping.preset.insert({
        ['<c-u>'] = cmp.mapping.scroll_docs(-4),
        ['<c-d>'] = cmp.mapping.scroll_docs(4),
        ['<c-space>'] = cmp.mapping.complete(),
        ['<cr>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
        },
        ['<tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<s-tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' })
    })
}
