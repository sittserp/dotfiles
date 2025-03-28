local builtin = require('telescope.builtin')
local cwd = vim.fn['getcwd']()
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
  if cwd == '/Users/perrysittser/lightspeed/teacher_dashboard' then
    builtin.grep_string({ search = vim.fn.input("Grep > "), search_dirs = { "app", "config", "lib" } });
  else
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
  end
end)
vim.keymap.set('n', '<leader>8', function()
  if cwd == '/Users/perrysittser/lightspeed/teacher_dashboard' then
    builtin.grep_string({ search_dirs = { "app", "config", "lib" } });
  else
    builtin.grep_string();
  end
end)
