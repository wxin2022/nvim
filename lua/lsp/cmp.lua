-- local lspkind = require('lspkind')
local kindIcons = require('lsp.icon')

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end
local cmp = require('cmp')

cmp.setup{
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-b>'] = cmp.mapping.scroll_docs(-8),
    ['<C-f>'] = cmp.mapping.scroll_docs(8),
    ['<C-e>'] = cmp.mapping.abort(),

    -- ["<Tab>"] = cmp.mapping({
    --   c = function()       if cmp.visible() then
    --       cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
    --     else
    --       cmp.complete()
    --     end
    --   end,
    --   i = function(fallback)
    --     if cmp.visible() then
    --       cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
    --     else
    --       fallback()
    --     end
    --   end
    -- }),
    -- ["<S-Tab>"] = cmp.mapping({
    --   c = function()
    --     if cmp.visible() then
    --       cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
    --     else
    --       cmp.complete()
    --     end
    --   end,
    --   i = function(fallback)
    --     if cmp.visible() then
    --       cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
    --     else
    --       fallback()
    --     end
    --   end
    -- }),
    -- ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
    -- ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
    -- ['<C-n>'] = cmp.mapping({
    --   c = function()
    --     if cmp.visible() then
    --       cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
    --     else
    --       vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
    --     end
    --   end,
    --   i = function(fallback)
    --     if cmp.visible() then
    --       cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
    --     else
    --       fallback()
    --     end
    --   end
    -- }),
    -- ['<C-p>'] = cmp.mapping({
    --   c = function()
    --     if cmp.visible() then
    --       cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
    --     else
    --       vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
    --     end
    --   end,
    --   i = function(fallback)
    --     if cmp.visible() then
    --       cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
    --     else
    --       fallback()
    --     end
    --   end
    -- }),
    -- ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
    -- ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
    -- --['<C-e>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
    -- --['<C-e>'] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
    -- ['<CR>'] = cmp.mapping({
    --   i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
    --   c = function(fallback)
    --     if cmp.visible() then
    --       cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true})
    --     else
    --       fallback()
    --     end
    --   end
    -- }),
  },

  formatting = {
    -- format = lspkind.cmp_format({
    --   with_text = true, -- do not show text alongside icons
    --   maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
    --   before = function (entry, vim_item)
    --     -- Source ??????????????????
    --     vim_item.menu = "["..string.upper(entry.source.name).."]"
    --     return vim_item
    --   end
    -- })

    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format("%s", kindIcons[vim_item.kind])
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        vsnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },

  sources = cmp.config.sources({
      {
        name = 'path',
        option = {
          -- ???????????????????????? /
          label_trailing_slash = false,
          trailing_slash  = false
        }
        -- keyword_length = 0,
        -- keyword_pattern = ".*?",
        -- trigger_characters = {}
      },
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
      {
        name = 'buffer',
        keyword_length = 2,
        option = {
          -- ????????????????????????buffer????????????(??????????????????buffer??????)
          get_bufnrs = function()
            return vim.api.nvim_list_bufs()
          end
        }
      },
  })
}

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source foj `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  completion = { autocomplete = false },
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  completion = { autocomplete = true },
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})



