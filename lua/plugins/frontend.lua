-- Frontend tooling for React/TypeScript plus shared web tooling

return {
  -- Ensure frontend LSP/formatters/debuggers via Mason
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- JS/TS/React
        "typescript-language-server",
        "eslint-lsp",
        "prettierd",
        "tailwindcss-language-server",
        "emmet-language-server",
        -- Debugger (Mason installs js-debug-adapter)
        "js-debug-adapter",
      })
      return opts
    end,
  },

  -- Treesitter parsers for web stacks
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "javascript",
        "typescript",
        "tsx",
        "json",
        "html",
        "css",
        "scss",
        "graphql",
      },
    },
  },

  -- Formatting and linting
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts = opts or {}
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.javascript = { "prettierd", "prettier" }
      opts.formatters_by_ft.typescript = { "prettierd", "prettier" }
      opts.formatters_by_ft.javascriptreact = { "prettierd", "prettier" }
      opts.formatters_by_ft.typescriptreact = { "prettierd", "prettier" }
      opts.formatters_by_ft.css = { "prettierd", "prettier" }
      opts.formatters_by_ft.scss = { "prettierd", "prettier" }
      opts.formatters_by_ft.json = { "prettierd", "prettier" }
      opts.formatters_by_ft.graphql = { "prettierd", "prettier" }
      return opts
    end,
  },

  -- DAP UI and virtual text for all languages (Python/Go included)
  {
    "mfussenegger/nvim-dap",
    optional = true,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {},
    keys = {
      { "<leader>du", function() require("dapui").toggle({}) end, desc = "DAP UI toggle" },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {},
  },

  -- JavaScript/TypeScript debugging via Mason's js-debug-adapter
  {
    "mfussenegger/nvim-dap",
    optional = true,
    config = function()
      local dap = require("dap")

      -- Use Mason-installed js-debug-adapter
      local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_debug_path .. "/js-debug/src/dapDebugServer.js", "${port}" },
        },
      }

      dap.adapters["pwa-chrome"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_debug_path .. "/js-debug/src/dapDebugServer.js", "${port}" },
        },
      }

      local js_based_languages = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
      for _, lang in ipairs(js_based_languages) do
        dap.configurations[lang] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file (Node)",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch Chrome",
            url = "http://localhost:5173",
            webRoot = "${workspaceFolder}",
          },
        }
      end
    end,
  },
}
