vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

-- OPTIONS --

opt.relativenumber = true
opt.number = true


opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- SEARCH SETTINGS --

opt.ignorecase = true
opt.smartcase = true


-- COLOR THEME --

opt.termguicolors = true
opt.background = "dark"


-- BACKSPACE --

opt.backspace = "indent,eol,start"

-- CLIPBOARD --

opt.clipboard:append("unnamedplus")

-- SPLITWINDOW --

opt.splitright = true
opt.splitbelow = true

-- MAPPING TIMEOUT --

vim.o.timeoutlen = 1500  -- Time in milliseconds (1000ms = 1s)

