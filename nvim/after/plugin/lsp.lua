-- Native LSP setup (nvim 0.11+).
--
-- This replaces lsp-zero, which is deprecated upstream and internally called
-- the removed require('lspconfig').<server>.setup{} framework -- the source of
-- the startup deprecation warning. nvim-lspconfig is still installed, but only
-- for the server definitions it ships under its lsp/ directory; vim.lsp.enable
-- reads those directly.

require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = { "eslint", "lua_ls", "ts_ls", "gopls", "solargraph" },
  -- mason-lspconfig v2 calls vim.lsp.enable() for each installed server, so
  -- there is no separate enable list to keep in sync with the one above.
  automatic_enable = true,
})

-- Defaults applied to every server: advertise the completion capabilities
-- nvim-cmp adds on top of the built-in client ones.
vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- Per-server overrides. Stops lua_ls flagging `vim` as an undefined global.
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
    },
  },
})

-- Buffer-local keymaps, bound when a server actually attaches.
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP keymaps",
  callback = function(event)
    local opts = { buffer = event.buf, remap = false }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

    -- NOTE: these two keep the direction from the old config, where [d went
    -- to the NEXT diagnostic and ]d to the previous. vim.diagnostic.goto_next
    -- is itself deprecated now, so both go through vim.diagnostic.jump.
    vim.keymap.set("n", "[d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, opts)
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, opts)
  end,
})

vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN] = "W",
      [vim.diagnostic.severity.HINT] = "H",
      [vim.diagnostic.severity.INFO] = "I",
    },
  },
})

-- Completion. lsp-zero used to preconfigure this; the mappings below are the
-- same ones the old config set, and <Tab>/<S-Tab> stay unmapped because cmp's
-- insert preset does not claim them.
local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "nvim_lua" },
    { name = "buffer" },
    { name = "path" },
  },
})
