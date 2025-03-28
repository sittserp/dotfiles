require("perry.remap")
require("perry.set")
require 'lspconfig'.gopls.setup {}
require 'lspconfig'.ts_ls.setup {}
require 'lspconfig'.solargraph.setup {}
require("CopilotChat").setup {
  debug = true, -- Enable debugging
  -- See Configuration section for rest
}
