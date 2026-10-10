local packages = {
  "ansible-language-server",
  "astro-language-server",
  "bash-language-server",
  "biome",
  "black",
  "clang-format",
  "clangd",
  "cmakelang",
  "cmakelint",
  "codelldb",
  "css-lsp",
  "css-variables-language-server",
  "csskit",
  "cssmodules-language-server",
  "debugpy",
  "delve",
  "docker-compose-language-service",
  "dockerfile-language-server",
  "emmet-language-server",
  "eslint-lsp",
  "eslint_d",
  "gofumpt",
  "goimports",
  "golangci-lint",
  "google-java-format",
  "gopls",
  "hadolint",
  "helm-ls",
  "html-lsp",
  "intelephense",
  "java-debug-adapter",
  "java-test",
  "jdtls",
  "js-debug-adapter",
  "json-lsp",
  "lua-language-server",
  "markdown-toc",
  "markdownlint-cli2",
  "marksman",
  "neocmakelsp",
  "oxfmt",
  "oxlint",
  "php-cs-fixer",
  "php-debug-adapter",
  "phpcs",
  "prettier",
  "prisma-language-server",
  "pyright",
  "ruff",
  "shellcheck",
  "shfmt",
  "sqlfluff",
  "stylua",
  "svelte-language-server",
  "tailwindcss-language-server",
  "tree-sitter-cli",
  "vtsls",
  "vue-language-server",
}

local registry = require("mason-registry")

registry.refresh(function()
  local pending = 0
  local failed = {}

  local function finish()
    if pending > 0 then
      return
    end
    if #failed > 0 then
      vim.notify("Mason install failed: " .. table.concat(failed, ", "), vim.log.levels.ERROR)
      vim.cmd("cquit 1")
    else
      vim.notify("Mason tools are ready")
      vim.cmd("qa")
    end
  end

  for _, name in ipairs(packages) do
    local ok, package = pcall(registry.get_package, name)
    if not ok then
      table.insert(failed, name .. " (not found)")
    elseif not package:is_installed() then
      pending = pending + 1
      package:once("install:success", function()
        pending = pending - 1
        finish()
      end)
      package:once("install:failed", function()
        table.insert(failed, name)
        pending = pending - 1
        finish()
      end)
      package:install()
    end
  end

  finish()
end)

vim.defer_fn(function()
  vim.notify("Mason installation timed out", vim.log.levels.ERROR)
  vim.cmd("cquit 1")
end, 15 * 60 * 1000)
