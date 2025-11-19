
local ok, noice = pcall(require, "noice")
if not ok then return end

noice.setup({
    lsp = {
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
        signature = { enabled = false },
    },
    presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
    },
    messages = { enabled = true, view = "notify" },
    popupmenu = {
        enabled = true,
        backend = "nui",
        --- Add selection keymaps here
        keymap = {
            accept = "<C-y>",     -- Accept the suggestion
            close = "<C-n>",
            scroll_up = "<C-k>",
            scroll_down = "<C-j>",
        },
    },
    cmdline = {
        enabled = true,  -- optional if you want completion in command line
    },
})

