return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        no_italic = true,
        term_colors = true,
        transparent_background = false,
        color_overrides = {
          mocha = {
            base = "#000000",
            mantle = "#000000",
            crust = "#000000",
          },
        },
      })

      -- Load the theme **ONLY AFTER** the plugin is properly installed
      vim.defer_fn(function()
        vim.cmd.colorscheme("catppuccin")
      end, 0)
    end,
  },
}

