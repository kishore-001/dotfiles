
-- Minimal, modern LSP setup (for Neovim ≥ 0.11)

local lsp = vim.lsp
local diagnostic = vim.diagnostic

require("mason").setup()
require("mason-lspconfig").setup()

local capabilities = lsp.protocol.make_client_capabilities()

diagnostic.config({
  underline = true,
  virtual_text = { spacing = 4, prefix = "●" },
  severity_sort = true,
  float = { border = "rounded", source = "always" },
})

local on_attach = function(_, bufnr)
  local opts = { buffer = bufnr, silent = true }

  vim.keymap.set("n", "gd", lsp.buf.definition, opts)
  vim.keymap.set("n", "gr", lsp.buf.references, opts)
  vim.keymap.set("n", "gi", lsp.buf.implementation, opts)
  vim.keymap.set("n", "K", lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>rn", lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>ca", lsp.buf.code_action, opts)
  vim.keymap.set("n", "[d", diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", diagnostic.goto_next, opts)
end

local servers = {
  lua_ls = { settings = { Lua = { diagnostics = { globals = { "vim" } }, runtime = { version = "LuaJIT" }, telemetry = { enable = false }, workspace = { checkThirdParty = false } } } },
  vtsls = {},
  denols = {},
  html = {},
  cssls = {},
  jsonls = {},
  tailwindcss = {},
  pyright = {},
  gopls = {},
  rust_analyzer = {},
}

for name, config in pairs(servers) do
  config.capabilities = capabilities
  config.on_attach = on_attach
  lsp.config(name, config)
end

