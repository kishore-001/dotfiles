
return {
  -- === LSP + Mason ===
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("configs.lspconfig")  -- your LSP servers config
    end,
  },

  -- === LSP Formatting / Diagnostics ===
  {
    "nvimtools/none-ls.nvim",  -- replacement for null-ls
    config = function()
      local none_ls = require("null-ls")
      none_ls.setup({
        sources = {
          none_ls.builtins.formatting.prettier,   -- JS / TS / React
          none_ls.builtins.formatting.black,      -- Python
          none_ls.builtins.formatting.stylua,     -- Lua
          none_ls.builtins.diagnostics.eslint_d,  -- JS / TS lint
        },
      })
    end,
  },
  -- === Utilities / Enhancements ===
  { "folke/flash.nvim", config = function() require("configs.flash") end },
  { "nvim-telescope/telescope.nvim", config = function() require("configs.navigator") end },
  { "folke/noice.nvim", dependencies = { "MunifTanjim/nui.nvim" }, event = "VeryLazy", config = function() require("configs.noice") end },
  { "folke/trouble.nvim", config = function() require("configs.trouble") end },
  { "stevearc/conform.nvim", opts = require("configs.conform") },

}

