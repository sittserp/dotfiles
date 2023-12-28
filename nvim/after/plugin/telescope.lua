local builtin = require('telescope.builtin')
local cwd = vim.fn['getcwd']()
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
  if cwd == '/Users/perrysittser/lightspeed/teacher_dashboard' then
    builtin.grep_string({ search = vim.fn.input("Grep > "), search_dirs = { "app", "config/locales/en.yml" } });
  else
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
  end
end)
vim.keymap.set('n', '<F13>', function()
  if cwd == '/Users/perrysittser/lightspeed/teacher_dashboard' then
    builtin.grep_string({ search_dirs = { "app", "config/locales/en.yml" } });
  else
    builtin.grep_string();
  end
end)
