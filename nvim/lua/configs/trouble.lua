
-- ~/.config/nvim/lua/custom/trouble.lua
require("trouble").setup({
  auto_open = false,
  auto_close = true,
  use_diagnostic_signs = true,
  icons = true,
})

-- Optional keymaps
vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>TroubleToggle<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", { noremap = true, silent = true })
