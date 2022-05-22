-- Automatically install packer
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Install plugins
return packer.startup(function(use)
  use "wbthomason/packer.nvim"    -- Have packer manage itself
  use "nvim-lua/plenary.nvim"     -- Useful lua functions used ny lots of plugins

  use "fatih/vim-go"
  use "google/vim-jsonnet"
  use "joshdick/onedark.vim"
  use "junegunn/gv.vim"
  use "konfekt/vim-sentence-chopper"
  use "kshenoy/vim-signature"
  use "majutsushi/tagbar"
  use "michaeljsmith/vim-indent-object"
  use "sheerun/vim-polyglot"
  use "sickill/vim-pasta"
  use "tpope/vim-afterimage"
  use "tpope/vim-eunuch"
  use "tpope/vim-fugitive"
  use "tpope/vim-git"
  use "tpope/vim-repeat"
  use "tpope/vim-sensible"
  use "tpope/vim-sleuth"
  use "tpope/vim-surround"
  use "tpope/vim-unimpaired"
  use "tpope/vim-vinegar"

  use {
    "ojroques/vim-oscyank",
    config = function()
      vim.keymap.set("v", "<C-c>", ":OSCYank<cr>")
    end,
  }

  use {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end
  }

  use {
    "editorconfig/editorconfig-vim",
    config = function()
      vim.g.EditorConfig_exclude_patterns = {"fugitive://.*"}
    end,
  }

  use {
    "sjl/gundo.vim",
    config = function()
      vim.g.gundo_preview_bottom = 1
      vim.g.gundo_prefer_python3 = 1
      vim.keymap.set("n", "<leader>u", ":GundoToggle<CR>")
    end,
  }

  use {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup {
        signs = {
          add = { text = "+" },
          change = { text = "~" },
        }
      }
      vim.keymap.set("n", "yogs", ":Gitsigns toggle_signs<CR>")
    end,
  }

  use {
    "zhaocai/GoldenView.vim",
    config = function()
      vim.g.goldenview__enable_default_mapping = 0
      vim.keymap.set("n", "yogv", ":ToggleGoldenViewAutoResize<CR>")
    end,
  }

  use {
    "mileszs/ack.vim",
    config = function()
      if vim.fn.executable("rg") == 1 then
        vim.opt.grepprg = "rg --vimgrep --no-heading"
        vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
        vim.g.ackprg = "rg --vimgrep --no-heading"
      end
    end,
  }

  use "junegunn/goyo.vim"
  use {
    "junegunn/limelight.vim",
    config = function()
      vim.g.limelight_conceal_ctermfg = 8
      vim.cmd [[
        function! s:goyo_enter()
          DisableGoldenViewAutoResize
          lua require('gitsigns').toggle_signs(false)
          Limelight
        endfunction
        autocmd! User GoyoEnter nested call <SID>goyo_enter()

        function! s:goyo_leave()
          EnableGoldenViewAutoResize
          lua require('gitsigns').toggle_signs(true)
          Limelight!
        endfunction
        autocmd! User GoyoLeave nested call <SID>goyo_leave()
      ]]
      vim.keymap.set("n", "<leader>gg", ":DisableGoldenViewAutoResize<CR>:Goyo<CR>")
    end,
  }

  use "junegunn/fzf.vim"
  use {
    "junegunn/fzf",
    run = "./install --bin",
    config = function()
      vim.g.fzf_history_dir = vim.fn.stdpath("data") .. "/fzf-history"
      vim.g.fzf_action = {
        ["ctrl-t"] = "tab split",
        ["ctrl-s"] = "split",
        ["ctrl-v"] = "vsplit",
      }
      vim.g.fzf_layout = { down = "~70%" }
      vim.keymap.set("n", "<C-T>", ":FZF<CR>")
    end,
  }

  use {
    "w0rp/ale",
    config = function()
      vim.g.ale_lint_on_text_changed = "normal"
      vim.g.ale_lint_on_insert_leave = 1
      vim.g.ale_fixers = {
         javascript = {"eslint"},
      }
      vim.cmd [[highlight ALEErrorSign ctermfg=8 ctermbg=1]]
    end,
  }

  use {
    "nvim-lualine/lualine.nvim",
    config = function()
      -- customize 16color theme, swapping insert and normal color
      local t16c = require "lualine.themes.16color"
      local normal = t16c.normal.a
      t16c.normal.a = t16c.insert.a
      t16c.insert.a = normal
      t16c.normal.a.fg = "#000000"
      t16c.insert.a.fg = "#000000"
      t16c.visual.a.fg = "#000000"

      require("lualine").setup {
        options = {
          theme = t16c,
          icons_enabled = false,
          section_separators = "",
          component_separators = "",
        },
        sections = {
          lualine_a = {
            { "mode", fmt = function(str) return str:sub(1,1) end }
          },
        },
        tabline = {
          lualine_a = { {"buffers", mode=2} },
          lualine_z = { {"tabs", mode=2} },
        }
      }
    end,
  }

  -- Automatically set up configuration after cloning packer.nvim
  if packer_bootstrap then
    require("packer").sync()
  end
end)
