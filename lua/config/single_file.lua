local M = {}

local function compile_command(compiler, file)
  local cache = vim.fn.stdpath("cache") .. "/single-file-run"
  vim.fn.mkdir(cache, "p")
  local name = vim.fn.fnamemodify(file, ":t:r"):gsub("[^%w_.-]", "_")
  local output = cache .. "/" .. name .. "-" .. vim.fn.sha256(file):sub(1, 10)
  local escaped_file = vim.fn.shellescape(file)
  local escaped_output = vim.fn.shellescape(output)
  return { "bash", "-lc", compiler .. " " .. escaped_file .. " -o " .. escaped_output .. " && " .. escaped_output }
end

local function open_html(file)
  if vim.fn.executable("wslpath") == 0 or vim.fn.executable("explorer.exe") == 0 then
    vim.notify("ไม่พบตัวเปิดเบราว์เซอร์ของ WSL", vim.log.levels.ERROR)
    return
  end
  local windows_path = vim.fn.system({ "wslpath", "-w", file }):gsub("[%r\n]+$", "")
  if vim.v.shell_error ~= 0 or windows_path == "" then
    vim.notify("แปลง path สำหรับเบราว์เซอร์ไม่สำเร็จ", vim.log.levels.ERROR)
    return
  end
  if vim.fn.jobstart({ "explorer.exe", windows_path }, { detach = true }) <= 0 then
    vim.notify("เปิด HTML ในเบราว์เซอร์ไม่สำเร็จ", vim.log.levels.ERROR)
  end
end

function M.run()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" or vim.bo.buftype ~= "" then
    vim.notify("บันทึกไฟล์ก่อน แล้วกด F5 อีกครั้ง", vim.log.levels.WARN)
    return
  end

  local ok, err = pcall(vim.cmd, "update")
  if not ok then
    vim.notify("บันทึกไฟล์ไม่สำเร็จ: " .. tostring(err), vim.log.levels.ERROR)
    return
  end

  local ft = vim.bo.filetype
  if ft == "html" then
    open_html(file)
    return
  end
  if ft == "css" or ft == "scss" or ft == "less" then
    vim.notify("ไฟล์ CSS ต้องเปิดผ่าน HTML: เปิดไฟล์ .html แล้วกด F5", vim.log.levels.INFO)
    return
  end

  local commands = {
    c = function() return compile_command("gcc", file) end,
    cpp = function() return compile_command("g++", file) end,
    python = function() return { "python3", file } end,
    java = function() return { "java", file } end,
    javascript = function() return { "node", file } end,
    typescript = function() return { "tsx", file } end,
    typescriptreact = function() return { "tsx", file } end,
    php = function() return { "php", file } end,
    go = function() return { "go", "run", file } end,
    sh = function() return { "bash", file } end,
  }
  local build = commands[ft]
  if not build then
    vim.notify("ไฟล์ชนิดนี้ยังไม่มีคำสั่งรันเดี่ยว: " .. ft, vim.log.levels.WARN)
    return
  end

  local command = build()
  if vim.fn.executable(command[1]) == 0 then
    vim.notify("ไม่พบคำสั่ง " .. command[1], vim.log.levels.ERROR)
    return
  end
  Snacks.terminal.open(command, {
    cwd = vim.fn.fnamemodify(file, ":h"),
    interactive = false,
    win = { position = "bottom" },
  })
end

return M
