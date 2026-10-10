return {
  {
    "Diogo-ss/42-header.nvim",
    cmd = { "Stdheader" },
    keys = { "<F1>" },
    opts = {
      default_map = true, -- ใช้ปุ่มลัดมาตรฐาน F1
      auto_update = true, -- อัปเดต Updated by และเวลาอัตโนมัติเมื่อกดบันทึก (:w)
      user = "sbontem",  -- Intra login (เช่น rsaengja)
      mail = "sboontem@student.42bangkok.com", -- อีเมลของ 42
    },
    config = function(_, opts)
      require("42header").setup(opts)
    end,
  },
}
