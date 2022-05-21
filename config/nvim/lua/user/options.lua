local o = vim.opt

-- general
o.wildmode = "list:longest,full"
o.updatetime = 100
o.maxmempattern = 2000
o.spellfile = vim.fn.stdpath("config") .. "/en.utf-8.add"
o.undofile = true

-- UI
o.listchars = "tab:> ,trail:-,extends:>,precedes:<,nbsp:+"
o.number = true-- show line numbers
o.splitright = true -- open vertical splits on the right
o.showmode = false

-- Scrolling
o.sidescrolloff = 10

-- Text Formatting / Layout
o.ignorecase = true
o.smartcase = true
o.infercase =true

-- 2 space indents
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true

o.diffopt = "filler,vertical"

-- set 'textwidth' to 78 characters for all text files
vim.cmd [[autocmd FileType text setlocal textwidth=78]]

-- Folding
o.foldenable = true -- turn on folding
o.foldmethod = "marker" -- fold on markers
o.foldlevel = 100 -- don't autofold anything
o.foldopen = "block,hor,mark,percent,quickfix,tag" -- what movements open folds

vim.cmd [[
  nnoremap yof :call FoldColumnToggle()<cr>
  function! FoldColumnToggle()
      if &foldcolumn
          setlocal foldcolumn=0
      else
          setlocal foldcolumn=1
      endif
  endfunction
]]

-- Netrw
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_winsize = -28

