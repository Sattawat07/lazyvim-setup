-- Language support shared by the existing LazyVim setup.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Keep HTML completion, but avoid a CSS validation crash in html-lsp.
        html = { settings = { html = { validate = { styles = false } } } },
        -- For standalone JS/TS files, do not index the entire Git repository.
        vtsls = {
          root_dir = function(bufnr, on_dir)
            local file = vim.api.nvim_buf_get_name(bufnr)
            local root = vim.fs.root(bufnr, {
              "package.json", "package-lock.json", "yarn.lock",
              "pnpm-lock.yaml", "bun.lockb", "bun.lock",
              "tsconfig.json", "jsconfig.json",
            })
            on_dir(root or vim.fs.dirname(file))
          end,
        },
        -- Tailwind should start only in projects that actually use it.
        tailwindcss = {
          root_dir = function(bufnr, on_dir)
            local file = vim.api.nvim_buf_get_name(bufnr)
            local root = vim.fs.root(bufnr, {
              "tailwind.config.js", "tailwind.config.cjs",
              "tailwind.config.mjs", "tailwind.config.ts",
              "postcss.config.js", "postcss.config.cjs",
              "postcss.config.mjs", "postcss.config.ts",
            })
            if not root then
              local package = vim.fs.find("package.json", { path = vim.fs.dirname(file), upward = true })[1]
              if package then
                local ok, lines = pcall(vim.fn.readfile, package)
                if ok and table.concat(lines, "\n"):find('"tailwindcss"', 1, true) then
                  root = vim.fs.dirname(package)
                end
              end
            end
            if root then
              on_dir(root)
            end
          end,
        },
        -- Start Marksman for standalone Markdown files too.
        marksman = {
          root_dir = function(bufnr, on_dir)
            local file = vim.api.nvim_buf_get_name(bufnr)
            on_dir(vim.fs.root(bufnr, { ".marksman.toml", ".git" }) or vim.fs.dirname(file))
          end,
        },
        cssls = {},
        css_variables = {},
        cssmodules_ls = {},
        emmet_language_server = {},
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "html-lsp",
        "bash-language-server",
        "shellcheck",
        "google-java-format",
        "css-lsp",
        "css-variables-language-server",
        "cssmodules-language-server",
        "emmet-language-server",
        "prettier",
        "clang-format",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "c", "cpp", "python", "java", "javascript", "typescript", "tsx",
        "html", "css", "scss", "php", "php_only", "bash", "lua", "json",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        python = { "black" },
        java = { "google-java-format" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
      },
    },
  },
  {
    "mfussenegger/nvim-jdtls",
    optional = true,
    opts = function(_, opts)
      local project_root = opts.root_dir
      opts.root_dir = function(path)
        return project_root(path) or vim.fs.dirname(path)
      end
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters = opts.formatters or {}
      opts.formatters.sqlfluff = vim.tbl_deep_extend("force", opts.formatters.sqlfluff or {}, {
        args = { "format", "--dialect=ansi", "-" },
        cwd = function(ctx)
          return vim.fs.dirname(ctx.filename)
        end,
        require_cwd = false,
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.sh = { "shellcheck" }
      opts.linters_by_ft.bash = { "shellcheck" }
    end,
  },
}
