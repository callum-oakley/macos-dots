vim.g.mapleader = " "

vim.opt.clipboard = "unnamedplus"
vim.opt.fillchars = "eob: "
vim.opt.scrolloff = 99

vim.keymap.set("n", "<esc>", ":noh<cr><esc>")
vim.keymap.set("n", "<leader>J", "g*N")
vim.keymap.set("n", "<leader>N", ":bp<cr>")
vim.keymap.set("n", "<leader>j", "*N")
vim.keymap.set("n", "<leader>n", ":bn<cr>")
vim.keymap.set("n", "<leader>q", ":q!<cr>")
vim.keymap.set("n", "<leader>s", ":w<cr>")
vim.keymap.set("n", "<leader>w", ":bd<cr>")
