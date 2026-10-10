-- Make Mason tools available before health checks and plugins start.
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if not vim.env.PATH:find(mason_bin, 1, true) then
  vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.virtualedit = "onemore"
vim.g.autoformat = false
-- ตั้งค่าการเยื้องบรรทัดให้ตรงตามบรรทัดก่อนหน้า
vim.opt.autoindent = true   -- ขึ้นบรรทัดใหม่จะตรงกับบรรทัดก่อนหน้าเสมอ
vim.opt.smartindent = false -- ปิด smartindent เพราะมักเดาการ tab พลาด
vim.opt.cindent = false     -- ปิด cindent เพื่อไม่ให้บังคับสไตล์ภาษา C กับไฟล์อื่น
vim.g.inlay_hints = false

local opt = vim.opt

opt.expandtab = false   -- ปิดการแปลง Tab เป็น Space (Tab คือ Tab จริง)
opt.tabstop = 4         -- กำหนดความกว้างของการแสดงผล 1 Tab ให้เท่ากับ 4 ช่อง
opt.shiftwidth = 4      -- ระยะ Indent (ตอนกด >> หรือ <<) เท่ากับ 4 ช่อง
opt.softtabstop = 4     -- เวลากด Backspace ลบ Tab ในครั้งเดียว

vim.opt.clipboard = "unnamedplus"

vim.g.clipboard = {
  name = "Windows clipboard",
  copy = {
    ["+"] = { "clip.exe" },
    ["*"] = { "clip.exe" },
  },
  paste = {
    ["+"] = { "powershell.exe", "-NoLogo", "-NoProfile", "-Command", [[
      [Console]::Out.Write((Get-Clipboard -Raw) -replace "`r", "")
    ]] },
    ["*"] = { "powershell.exe", "-NoLogo", "-NoProfile", "-Command", [[
      [Console]::Out.Write((Get-Clipboard -Raw) -replace "`r", "")
    ]] },
  },
  cache_enabled = 0,
}

-- PHP language server installed through Mason
vim.g.lazyvim_php_lsp = "intelephense"
