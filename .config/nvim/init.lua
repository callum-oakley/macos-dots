-- plugins --------------------------------------------------------------------

require("packer").startup(function()
  use "wbthomason/packer.nvim"
  use { "nvim-telescope/telescope.nvim", requires = "nvim-lua/plenary.nvim" }
  use "nvim-telescope/telescope-file-browser.nvim"
  use "rust-lang/rust.vim"
end)

-- options --------------------------------------------------------------------

local lispwords = table.concat({
  "are", "cond", "do", "dosync", "doto-wait", "fdef", "finally", "go-loop",
  "try", "with-in-str", "with-out-str",
}, ",")

vim.cmd("au FileType * set fo-=o")
vim.cmd("au FileType clojure setlocal lispwords+=" .. lispwords)
vim.cmd("au TextYankPost * lua vim.highlight.on_yank({ higroup = 'Visual' })")
vim.cmd("colorscheme rubric")
vim.g.clojure_align_multiline_strings = 1
vim.g.clojure_align_subforms = 1
vim.g.mapleader = " "
vim.g.rustfmt_autosave = 1
vim.opt.clipboard = "unnamedplus"
vim.opt.expandtab = true
vim.opt.scrolloff = 999
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- search ---------------------------------------------------------------------

-- search for word under cursor (but don't move)
vim.keymap.set("n", "<leader>j", "*N")

-- toggle word boundaries on search
vim.keymap.set("n", "<leader>t", function()
  local search = vim.fn.getreg("/")
  if search:find("\\[<>]") then
    vim.api.nvim_input("/" .. search:gsub("\\[<>]", "") .. "<cr>N")
  else
    vim.api.nvim_input("/\\<lt>" .. search .. "\\><cr>N")
  end
end)

-- search for selection
vim.keymap.set("v", "<leader>j", function()
  vim.api.nvim_input("oy")
  -- wait a moment for the above, since it's async
  vim.defer_fn(function()
    local s = vim.fn.getreg('"'):gsub("[/\\.*^$~[]", "\\%0"):gsub("<", "<lt>")
    vim.api.nvim_input("/" .. s .. "<cr>N")
  end, 100)
end)

-- clear highlight on esc
vim.keymap.set("n", "<esc>", ":noh<cr><esc>")

-- telescope ------------------------------------------------------------------

require("telescope").setup({
  defaults = {
    layout_config = {
      vertical = { width = 999, height = 999, preview_cutoff = 0 },
    },
    layout_strategy = "vertical",
  },
  extensions = {
    file_browser = {
      dir_icon = "»",
    },
  },
})

require("telescope").load_extension("file_browser")

-- files
vim.keymap.set("n", "<leader>e", ":Telescope find_files<cr>")
vim.keymap.set("n", "<leader>E", ":Telescope file_browser<cr>")

-- buffers
vim.keymap.set("n", "<leader>b", function()
  require("telescope.builtin").buffers({
    sort_mru = true,
    ignore_current_buffer = true,
  })
end)

-- grep
vim.keymap.set("n", "<leader>f", function()
  require("telescope.builtin").live_grep({
    disable_coordinates = true,
  })
end)

-- grep with current search
vim.keymap.set("n", "<leader>g", function()
  require("telescope.builtin").grep_string({
    disable_coordinates = true,
    search = vim.fn.getreg("/"):gsub("\\[<>]", "\\b"),
    use_regex = true,
  })
end)

-- help
vim.keymap.set("n", "<leader>h", ":Telescope help_tags<cr>")

-- resume
vim.keymap.set("n", "<leader>.", ":Telescope resume<cr>")

-- misc -----------------------------------------------------------------------

vim.keymap.set("n", "<leader>q", ":q!<cr>")
vim.keymap.set("n", "<leader>s", ":w<cr>")
vim.keymap.set("n", "<leader>w", ":bd<cr>")
vim.keymap.set("n", "U", "<c-r>")

-- copy current file name
vim.keymap.set("n", "<leader>p", function()
  vim.fn.setreg("+", vim.fn.expand("%"))
end)

-- remember the content of "+ in some other register
for c in string.gmatch("abcdefghijklmnopqrstuvwxyz", ".") do
  vim.keymap.set("n", "<leader>r" .. c, function()
    vim.fn.setreg(c, vim.fn.getreg("+"), vim.fn.getregtype("+"))
  end)
end
