return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- import nvim-treesitter plugin
    local treesitter = require("nvim-treesitter.configs")

    -- configure treesitter
    treesitter.setup({
      -- enable syntax highlighting
      highlight = {
        enable = true,
      },
      -- enable indentation
      indent = { enable = true },
      -- enable autotagging (w/ nvim-ts-autotag plugin)
      autotag = {
        enable = true,
      },
      -- ensure these language parsers are installed
      ensure_installed = {
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "prisma",
        "markdown",
        "markdown_inline",
        "svelte",
        "graphql",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "query",
        "vimdoc",
        "c",
        "python",
        "asm",          -- Assembly (nasm/gas)
        "powershell",   -- PowerShell scripting
        "go",           -- Go (used in malware analysis & exploits)
        "rust",         -- Rust (growing in security & exploit dev)
        "perl",         -- Perl (old-school exploits & scripting)
        "ruby",         -- Ruby (Metasploit, security tools)
        "java",         -- Java (Android malware, exploit dev)
        "kotlin",       -- Kotlin (mobile security)
        "swift",        -- Swift (iOS security & reverse engineering)
        "php",          -- PHP (web exploitation)
        "sql"           -- SQL (SQL injection testing)
      }, 
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}

