-- colors
vim.o.termguicolors = true
vim.o.hlsearch = false

-- line numbers
vim.o.mouse = "a"
vim.o.number = true
vim.o.relativenumber = true

-- scroll offsets
vim.o.scrolloff = 5
vim.o.sidescrolloff = 15


-- split directions
vim.o.splitbelow = true
vim.o.splitright = true

-- search settings
vim.o.ignorecase = true
vim.o.smartcase = true

-- indentations settings
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 0
vim.o.expandtab = true
vim.o.smartindent = true

-- hide extra text
vim.opt.conceallevel = 0

-- dont show mode
vim.opt.showmode = false
vim.o.cmdheight = 0

-- always show
vim.o.laststatus = 3

-- use rg for grepping
vim.opt.grepprg = "rg --vimgrep"

-- enable project-local configs
vim.opt.exrc = true

-- spelling checking
vim.opt.spelllang = { "en", "de" }
vim.opt.spelloptions:append("noplainbuffer")

-- disable swap, backup, and undo files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.local/state/nvim/undodir"
vim.opt.undofile = true


-- fix markdown stuff
vim.g.markdown_recommended_style = 0
