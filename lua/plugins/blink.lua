return {
  {
    "saghen/blink.cmp",
    opts = {
      -- 1. การตั้งค่าปุ่มลัด (Keymaps)
      keymap = {
        preset = "none",

        ["<Tab>"] = {
          function(cmp)
            if cmp.is_visible() then
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          "fallback",
        },

        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<CR>"]    = { "fallback" },
        ["<C-y>"]   = { "select_and_accept" },

        ["<C-p>"]   = { "select_prev", "fallback" },
        ["<C-n>"]   = { "select_next", "fallback" },
        ["<Up>"]    = { "select_prev", "fallback" },
        ["<Down>"]  = { "select_next", "fallback" },
      },

      -- 2. จัดลำดับคะแนนตาม Schema ใหม่
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          snippets = {
            score_offset = 100, -- ดันคะแนน Snippet ให้อยู่บนสุด
          },
          buffer = {
            score_offset = -100, -- ลดคะแนน Buffer ไม่ให้แซง Snippet
          },
        },
      },
    },
  },
}
