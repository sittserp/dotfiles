-- remap first: it sets mapleader, which has to be set before lazy loads any
-- plugin that defines <leader> mappings.
require("perry.remap")
require("perry.set")
require("perry.lazy")

-- LSP servers, completion, and CopilotChat are configured in after/plugin/,
-- which nvim sources once the plugins on the runtimepath have loaded.
