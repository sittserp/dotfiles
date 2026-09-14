-- nvim-treesitter, `main` branch.
--
-- This is a rewrite rather than a new version of the master-branch plugin:
-- there is no configs.setup{}, no ensure_installed, no auto_install, and no
-- modules table. The plugin now does one job -- install parsers and their
-- queries -- and the features themselves come from core Neovim, enabled per
-- buffer. See :h nvim-treesitter.
--
-- The old configs.setup{} here enabled `highlight` only, so that is all this
-- enables. Folds and indent are opt-in; to turn them on, add to the FileType
-- callback below:
--
--   vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
--   vim.wo[0][0].foldmethod = 'expr'
--   vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

local ts = require("nvim-treesitter")

-- Defaults are fine; parsers land in stdpath('data')/site, which the plugin
-- prepends to runtimepath. Must be called before any install operation.
ts.setup()

-- Was `ensure_installed`. c/lua/markdown/query/vim/vimdoc ship with Neovim,
-- but they are listed anyway: main's queries are version-locked to main's own
-- parsers, so it is better to use its copies than Neovim's bundled ones.
local ensure_installed = {
  "c", "css", "csv", "go", "graphql", "html", "javascript", "json", "lua",
  "markdown", "markdown_inline", "query", "regex", "ruby", "scss", "sql",
  "typescript", "vim", "vimdoc", "yaml",
}

local installed = ts.get_installed("parsers")
local missing = vim.tbl_filter(function(lang)
  return not vim.tbl_contains(installed, lang)
end, ensure_installed)

if #missing > 0 then
  ts.install(missing, { summary = true })
end

-- Was `auto_install = true`, which main dropped. This replaces it: start
-- highlighting if a parser is already on the runtimepath, otherwise install
-- one on demand and start once it lands.
local available ---@type string[]? filled on first miss; get_available() is not cheap

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("perry_treesitter", { clear = true }),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not lang then
      return
    end

    -- start() throws when the parser is missing, which doubles as the check
    -- for whether it is there.
    if pcall(vim.treesitter.start, ev.buf, lang) then
      return
    end

    available = available or ts.get_available()
    if not vim.tbl_contains(available, lang) then
      return
    end

    ts.install(lang):await(function(err)
      if not err and vim.api.nvim_buf_is_valid(ev.buf) then
        pcall(vim.treesitter.start, ev.buf, lang)
      end
    end)
  end,
})
