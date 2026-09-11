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
    "nvim-telescope/telescope.nvim",
    tag = "0.1.3",
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

  -- Pinned to master deliberately: the `main` branch is an in-progress rewrite
  -- with an incompatible API, and after/plugin/treesitter.lua uses the master
  -- one (require('nvim-treesitter.configs')). Don't drop this branch pin
  -- without porting that file.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
  },
  "nvim-treesitter/nvim-treesitter-context",
  -- Archived upstream; nvim has built-in :InspectTree / :Inspect now.
  "nvim-treesitter/playground",

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
