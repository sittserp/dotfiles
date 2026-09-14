-- lazy.nvim, replacing packer (archived upstream since Aug 2023).
--
-- Bootstrap clones lazy itself on a fresh machine, so this file is the only
-- thing needed to rebuild the plugin set. Resolved versions are written to
-- lazy-lock.json, which IS committed -- that file is the reproducible part.
--
--   :Lazy         status / install / update UI
--   :Lazy sync    install, clean, and update to match this file
--   :Lazy restore reset every plugin to the committed lockfile
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    -- Was pinned to 0.1.3 (Sep 2023), which called the now-deprecated
    -- vim.tbl_flatten on every grep. v0.2.2 drops it and needs nvim > 0.10.4.
    -- grep_string/find_files/git_files/buffers are unchanged across the bump.
    "nvim-telescope/telescope.nvim",
    tag = "v0.2.2",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  { "rose-pine/neovim", name = "rose-pine" },

  "ThePrimeagen/harpoon",
  "ThePrimeagen/vim-be-good",
  "tpope/vim-fugitive",
  "github/copilot.vim",

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim", -- for curl, log wrapper
    },
    -- setup() lives in after/plugin/copilot.lua
  },

  {
    "brianhuster/live-preview.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },

  -- `main` branch: a full rewrite, not an upgrade. It only installs parsers
  -- and queries -- highlighting/folds/indent are core Neovim features enabled
  -- per buffer in after/plugin/treesitter.lua. Requires nvim >= 0.12 and the
  -- tree-sitter CLI (brew install tree-sitter-cli; the `tree-sitter` formula
  -- is library-only). master is frozen at nvim 0.11 and breaks on 0.12.
  --
  -- The plugin does not support lazy-loading, hence lazy = false. Parsers are
  -- version-locked to the plugin, so :TSUpdate must run on every update.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
  },
  -- Uses core vim.treesitter only, so it is unaffected by the master -> main
  -- move.
  "nvim-treesitter/nvim-treesitter-context",

  -- LSP. lsp-zero used to tie these together; it is deprecated and called
  -- nvim-lspconfig's removed framework internally, so after/plugin/lsp.lua
  -- now wires them up directly against the native vim.lsp API.
  "neovim/nvim-lspconfig",
  { "mason-org/mason.nvim", build = ":MasonUpdate" },
  "mason-org/mason-lspconfig.nvim",

  -- Autocompletion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lua",
  "saadparwaiz1/cmp_luasnip",

  -- Snippets
  "L3MON4D3/LuaSnip",
  "rafamadriz/friendly-snippets",
}, {
  change_detection = { notify = false },
})
