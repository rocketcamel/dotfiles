vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.NvimTreeOpen)
vim.keymap.set("n", "<leader>x", vim.cmd.q)
vim.keymap.set("i", "<C-c>", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-h>", "<Left>", { noremap = true, silent = false })
vim.keymap.set("i", "<C-l>", "<Right>", { noremap = true, silent = true })
vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { desc = "Git commit" })
vim.keymap.set("n", "<leader>ga", function()
	vim.ui.input({ prompt = "Git add: " }, function(input)
		if input then
			vim.cmd("Git add " .. input)
		end
	end)
end)
