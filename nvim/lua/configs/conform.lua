
-- ~/.config/nvim/lua/custom/conform.lua

local options = {
    -- Specify which formatter to use for each filetype
    formatters_by_ft = {
        -- Systems / Cybersecurity
        lua        = { "stylua" },       -- Lua
        python     = { "black" },        -- Python
        rust       = { "rustfmt" },      -- Rust
        go         = { "gofmt" },        -- Go
        bash       = { "shfmt" },        -- Bash scripts
        powershell = { "pwshfmt" },      -- PowerShell
        asm        = {},                  -- Assembly (usually no formatter)

        -- Frontend
        html       = { "prettier" },
        css        = { "prettier" },
        json       = { "prettier" },

        -- Backend
        javascript = { "prettier" },     -- Node.js
        typescript = { "prettier" },     -- Node.js TS
    },

    -- Automatically format files on save
    format_on_save = {
        timeout_ms = 500,   -- wait 500ms for the formatter
        lsp_fallback = true,-- fallback to LSP formatting if formatter fails
    },
}

return options

