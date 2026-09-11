local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})

-- teacher_dashboard is big enough that grepping the whole tree is noisy, so
-- searches there are scoped to the source directories.
--
-- getcwd() is called per search, not once at startup: this file is sourced
-- when nvim launches, so capturing it up front meant the scoping only applied
-- when nvim happened to be *started* inside the project, and went stale after
-- any :cd.
local SCOPED_DIRS = {
  ['/Users/perrysittser/lightspeed/teacher_dashboard'] = { 'app', 'config', 'lib' },
}

local function grep_opts(extra)
  local opts = extra or {}
  opts.search_dirs = SCOPED_DIRS[vim.fn.getcwd()]
  return opts
end

-- Prompt for a term, then grep for it.
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string(grep_opts({ search = vim.fn.input("Grep > ") }))
end)

-- Grep for the word under the cursor.
vim.keymap.set('n', '<leader>8', function()
  builtin.grep_string(grep_opts())
end)
