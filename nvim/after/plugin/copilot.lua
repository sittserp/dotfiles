-- Copilot autosuggestions
vim.g.copilot_hide_during_completion = 0
vim.g.copilot_proxy_strict_ssl = 0

-- If you want to use Shift+Tab to accept a completion, uncomment the following lines
-- vim.g.copilot_no_tab_map = true
-- vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })

local chat = require('CopilotChat')

chat.setup({
    question_header = '',
    answer_header = '',
    error_header = '',
    allow_insecure = true,
    mappings = {
        submit_prompt = {
            insert = '',
        },
        reset = {
            normal = '',
            insert = '',
        },
    },
    prompts = {
        Explain = {
            mapping = '<leader>ae',
            description = 'AI Explain',
        },
        Review = {
            mapping = '<leader>ar',
            description = 'AI Review',
        },
        Tests = {
            mapping = '<leader>at',
            description = 'AI Tests',
        },
        Fix = {
            mapping = '<leader>af',
            description = 'AI Fix',
        },
        Optimize = {
            mapping = '<leader>ao',
            description = 'AI Optimize',
        },
        Docs = {
            mapping = '<leader>ad',
            description = 'AI Documentation',
        },
        CommitStaged = {
            mapping = '<leader>ac',
            description = 'AI Generate Commit',
        },
    },
})

vim.keymap.set({ 'n', 'v' }, '<leader>aa', chat.toggle, { desc = 'AI Toggle' })
vim.keymap.set({ 'n', 'v' }, '<leader>ax', chat.reset, { desc = 'AI Reset' })
