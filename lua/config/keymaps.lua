-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- บังคับให้ Terminal เปิดที่โฟลเดอร์ของไฟล์ปัจจุบันเสมอ
local function open_file_terminal()
  local dir = vim.fn.expand("%:p:h")
  if dir == "" or vim.bo.buftype ~= "" then
    dir = vim.uv.cwd() or ""
  end
  Snacks.terminal(nil, {
    cwd = dir,
    win = { position = "bottom" }
  })
end
vim.keymap.set({ "n", "t" }, "<C-/>", open_file_terminal, { desc = "Terminal (File Dir)" })
vim.keymap.set({ "n", "t" }, "<c-_>", open_file_terminal, { desc = "Terminal (File Dir)" })
vim.keymap.set("n", "<leader>ft", open_file_terminal, { desc = "Terminal (File Dir)" })

-- Save and run a standalone source file.
vim.keymap.set("n", "<F5>", function() require("config.single_file").run() end, { desc = "Run current file" })
vim.api.nvim_create_user_command("RunFile", function() require("config.single_file").run() end, { desc = "Run current file" })
