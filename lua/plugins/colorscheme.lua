return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "moon",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_highlights = function(hl, c)
        hl.CursorLine = { bg = "none" }
        hl.CursorLineNr = { fg = c.orange, bold = true } -- ให้เลขบรรทัดยังเด่นชัดอยู่
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-moon",
    },
  },
}
