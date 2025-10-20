
local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        -- Formatters
        null_ls.builtins.formatting.prettier,   -- JS/TS/React
        null_ls.builtins.formatting.black,      -- Python
        null_ls.builtins.formatting.gofmt,      -- Go

        -- Linters
        null_ls.builtins.diagnostics.eslint,    -- JS/TS
        null_ls.builtins.diagnostics.flake8,    -- Python
    },
})
