-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local autosave_group = vim.api.nvim_create_augroup("user_autosave", { clear = true })

vim.api.nvim_create_autocmd({ "InsertLeave", "BufLeave" }, {
  group = autosave_group,
  desc = "Save changed files after editing or before switching buffers",
  callback = function(args)
    if not vim.api.nvim_buf_is_valid(args.buf) then
      return
    end

    local name = vim.api.nvim_buf_get_name(args.buf)
    local bo = vim.bo[args.buf]
    if name == "" or bo.buftype ~= "" or not bo.modifiable or bo.readonly or not bo.modified then
      return
    end

    vim.api.nvim_buf_call(args.buf, function()
      local ok, err = pcall(vim.cmd, "silent update")
      if not ok then
        vim.notify("Auto Save ไม่สำเร็จ: " .. tostring(err), vim.log.levels.ERROR)
      end
    end)
  end,
})
