-- pyworks.nvim - Zero-configuration Python notebook development
-- For ML and Data Science workflows with Jupyter notebook support

return {
  -- Main pyworks plugin
  {
    "jeryldev/pyworks.nvim",
    dependencies = {
      -- Code execution engine
      {
        "benlubas/molten-nvim",
        version = "^1.0.0",
        build = ":UpdateRemotePlugins",
        init = function()
          -- Molten configuration for better notebook experience
          vim.g.molten_auto_open_output = false
          vim.g.molten_image_provider = "image.nvim"
          vim.g.molten_output_win_max_height = 20
          vim.g.molten_wrap_output = true
          vim.g.molten_virt_text_output = true
          vim.g.molten_virt_lines_off_by_1 = true
          -- Auto-initialize kernel without prompting
          vim.g.molten_auto_init_behavior = "init"
        end,
      },
      -- Inline image rendering for plots
      {
        "3rd/image.nvim",
        opts = {
          backend = "kitty", -- or "ueberzug" if not using Kitty/Ghostty
          integrations = {
            markdown = { enabled = true },
          },
          max_width = 100,
          max_height = 12,
          max_height_window_percentage = math.huge,
          max_width_window_percentage = math.huge,
          window_overlap_clear_enabled = true,
          window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
        },
      },
    },
    ft = { "python", "jupyter", "ipynb" },
    keys = {
      -- Kernel management
      { "<leader>mi", "<cmd>MoltenInit python3<cr>", desc = "Initialize Molten kernel" },
      { "<leader>mr", "<cmd>MoltenRestart<cr>", desc = "Restart kernel" },
      { "<leader>mx", "<cmd>MoltenInterrupt<cr>", desc = "Interrupt execution" },
      -- Cell execution
      { "<leader>jl", "<cmd>MoltenEvaluateLine<cr>", desc = "Evaluate line" },
      { "<leader>jc", "<cmd>MoltenReevaluateCell<cr>", desc = "Re-evaluate cell" },
      { "<leader>jv", "<cmd>MoltenEvaluateVisual<cr>", mode = "v", desc = "Evaluate visual" },
      -- Output management
      { "<leader>mo", "<cmd>MoltenShowOutput<cr>", desc = "Show output" },
      { "<leader>mh", "<cmd>MoltenHideOutput<cr>", desc = "Hide output" },
      { "<leader>md", "<cmd>MoltenDelete<cr>", desc = "Delete cell output" },
    },
    config = function()
      require("pyworks").setup({
        -- Python environment settings
        python = {
          use_uv = true, -- Use uv for faster package management (10-100x faster than pip)
          preferred_venv_name = ".venv",
          auto_install_essentials = true,
          -- Essential packages for ML/Data Science
          essentials = {
            "pynvim",
            "ipykernel",
            "jupyter_client",
            "jupytext",
            -- Core data science
            "numpy",
            "pandas",
            "matplotlib",
            "seaborn",
            -- ML essentials
            "scikit-learn",
            "scipy",
          },
        },

        -- Package detection settings
        packages = {
          custom_package_prefixes = {
            "^my_",
            "^custom_",
            "^local_",
            "^internal_",
            "^private_",
            "^app_",
            "^lib_",
            "^src$",
            "^utils$",
            "^helpers$",
          },
        },

        -- Cache TTL in seconds
        cache = {
          kernel_list = 60,
          installed_packages = 300,
        },

        -- Notification settings
        notifications = {
          verbose_first_time = true,
          silent_when_ready = true,
          show_progress = true,
          debug_mode = false,
        },

        -- Auto-detection
        auto_detect = true,

        -- Image rendering for inline plots
        image_backend = "kitty", -- Use "kitty" for Kitty/Ghostty terminals

        -- Feature configuration
        skip_molten = false,
        skip_jupytext = false,
        skip_image = false,
        skip_keymaps = false,
      })
    end,
    lazy = false,
    priority = 100,
  },
}
