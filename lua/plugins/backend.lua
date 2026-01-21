-- Backend-focused tools for Python (Django/DRF) and Go

return {
  -- Mason installs for backend stacks
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- Python
        "pyright",
        "ruff",
        "black",
        "debugpy",
        -- Go
        "gopls",
        "gofumpt",
        "golangci-lint",
        "delve",
        "gomodifytags",
        "impl",
        -- Tools
        "jsonnet-language-server",
        "yaml-language-server",
        "sqlfluff",
      })
      return opts
    end,
  },

  -- Treesitter parsers for backend languages
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "python",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "json",
        "yaml",
        "toml",
        "bash",
        "html",
        "css",
        "javascript",
        "typescript",
      },
    },
  },

  -- LSP tweaks for Django/DRF and Go
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoImportCompletions = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
              },
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
            },
          },
        },
      },
    },
  },

  -- Go tooling (format, test, DAP)
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod", "gowork", "gosum" },
    dependencies = {
      "ray-x/guihua.lua",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "mfussenegger/nvim-dap",
    },
    opts = {
      gofmt = "gofumpt",
      lsp_cfg = true,
      lsp_gofumpt = true,
      lsp_keymaps = false,
      lsp_codelens = true,
      dap_debug = true,
      dap_debug_keymap = false,
      trouble = true,
      run_in_floaterm = true,
    },
    keys = {
      { "<leader>gr", function() require("go.format").goimport() end, desc = "Go format/import" },
      { "<leader>gt", "<cmd>GoTestFunc<cr>", desc = "Go test func" },
      { "<leader>gT", "<cmd>GoTestFile<cr>", desc = "Go test file" },
      { "<leader>gd", "<cmd>GoDbg<cr>", desc = "Go debug" },
    },
    config = function(_, opts)
      require("go").setup(opts)
    end,
  },

  -- Formatting setup (Conform)
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts = opts or {}
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.python = { "ruff_format", "black" }
      opts.formatters_by_ft.go = { "gofumpt" }
      opts.formatters_by_ft.yaml = { "yamlfmt" }
      opts.formatters_by_ft.json = { "jq" }
      return opts
    end,
  },

  -- REST client for API work
  {
    "rest-nvim/rest.nvim",
    ft = { "http" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      result_split_horizontal = false,
      skip_ssl_verification = true,
    },
    keys = {
      { "<leader>rr", "<cmd>Rest run<cr>", desc = "REST: run request" },
      { "<leader>rl", "<cmd>Rest last<cr>", desc = "REST: rerun last" },
    },
  },
}
