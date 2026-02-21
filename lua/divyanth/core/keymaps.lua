vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split indow vertically" })      -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })   -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })      -- make split windows equal width
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- tab key maps
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })        -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })        -- go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })    -- go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- -- terminal key maps
-- keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true, desc = "Exit terminal mode" })
-- keymap.set("n", "<leader>th", "<cmd>split | terminal<CR>", { silent = true, desc = "Terminal horizontal" })
-- keymap.set("n", "<leader>tv", "<cmd>vsplit | terminal<CR>", { silent = true, desc = "Terminal vertical" })
-- keymap.set("n", "<leader>tg", "<cmd>tabnew | terminal<CR>", { silent = true, desc = "Terminal group (new tab)" })
-- keymap.set("n", "<leader>q", "<cmd>close<CR>", { silent = true, desc = "Close window" })
--
-- -- TERMINAL TOGGLE (HORIZONTAL, REUSED)
-- local term_win = nil
-- local function toggle_terminal()
--   if term_win and vim.api.nvim_win_is_valid(term_win) then
--     vim.api.nvim_win_close(term_win, true)
--     term_win = nil
--   else
--     vim.cmd("split | terminal")
--     term_win = vim.api.nvim_get_current_win()
--     vim.cmd("startinsert")
--   end
-- end
-- keymap.set("n", "<leader>tt", toggle_terminal, { desc = "Toggle terminal" })
--
-- -- TERMINAL POLISH
-- vim.api.nvim_create_autocmd("TermOpen", {
--   callback = function()
--     vim.opt_local.number = false
--     vim.opt_local.relativenumber = false
--     vim.cmd("startinsert")
--   end,
-- })
