vim.g.mapleader = " "
vim.keymap.set("n", "<leader>x", vim.cmd.q)
vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, silent = true })
vim.keymap.set("n", "<leader>q", ":BufferClose<CR>:q<CR>")
vim.keymap.set("n", "<leader>F5", vim.cmd.UndotreeToggle)
