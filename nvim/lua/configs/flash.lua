
require("flash").setup({
  search = {
    multi_window = true,       -- highlights matches across multiple windows
    highlight = { backdrop = true },  -- dims the backdrop while highlighting
  },
  jump = {
   autojump = true,           -- automatically jumps to the selected match
 },
})
