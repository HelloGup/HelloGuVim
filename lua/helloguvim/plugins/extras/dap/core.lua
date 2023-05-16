return {
  "mfussenegger/nvim-dap",

  dependencies = {

    -- fancy UI for the debugger
    {
      "rcarriga/nvim-dap-ui",
      -- stylua: ignore
      keys = {
        { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
      },
      opts = {
        layouts = {
          {
            elements = {
              "scopes",
              -- 'stacks',
              "watches",
              "breakpoints",
            },
            size = 30,
            position = "left",
          },
          {
            elements = {
              "console",
            },
            size = 30,
            position = "right",
          },
          -- { elements = {
          --   },
          --   size = 12,
          --   position = "top",
          -- },
          {
            elements = {
              "repl",
            },
            size = 15,
            position = "bottom",
          },
        },
        -- sidebar = {
        -- 更改侧边栏元素的顺序
        --   elements = {
        --     -- Provide as ID strings or tables with "id" and "size" keys
        --     {
        --       id = "scopes",
        --       size = 0.35, -- Can be float or integer > 1
        --     },
        --     { id = "stacks", size = 0.35 },
        --     { id = "watches", size = 0.15 },
        --     { id = "breakpoints", size = 0.15 },
        --   },
        --   size = 40,
        --   position = "left", -- Can be "left", "right", "top", "bottom"
        -- },
        tray = {
          elements = { "repl" },
          size = 5,
          position = "bottom", -- Can be "left", "right", "top", "bottom"
        },
        floating = {
          max_height = nil, -- These can be integers or a float between 0 and 1.
          max_width = nil, -- Floats will be treated as percentage of your screen.
          border = "single", -- Border style. Can be "single", "double" or "rounded"
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
      },
      config = function(_, opts)
        local dap = require("dap")
        local dapui = require("dapui")
        dapui.setup(opts)
        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open({})
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close({})
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close({})
        end
      end,
    },

    -- virtual text for the debugger
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {
        -- 所有引用处都显示虚拟文本
        all_references = false,

        -- 显示所有栈帧的虚拟文本
        all_frames = false,

        -- 使用注释的形式显示虚拟文本
        commented = false,
      },
    },

    -- which key integration
    {
      "folke/which-key.nvim",
      opts = {
        defaults = {
          ["<leader>d"] = { name = "+debug" },
          ["<leader>da"] = { name = "+adapters" },
        },
      },
    },

    -- mason.nvim integration
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = "mason.nvim",
      cmd = { "DapInstall", "DapUninstall" },
      opts = {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_setup = true,

        -- 客户端适配器配置
        handlers = {},

        -- -- You'll need to check that you have the required things installed
        -- -- online, please don't ask me how to install them :)
        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
          -- 自动安装的适配器
          "codelldb",
        },
      },
    },
  },

  -- stylua: ignore
  keys = {
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },

    { "<F4>", function() require("dap").terminate() end, desc = "Terminate" },
    { "<F5>", function() require("dap").continue() end, desc = "Continue" },
    { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<F10>", function() require("dap").step_over() end, desc = "Step Over" },
    { "<F11>", function() require("dap").step_into() end, desc = "Step Into" },
    { "<F12>", function() require("dap").step_out() end, desc = "Step Out" },

    { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
    { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
  },

  config = function()
    local Config = require("helloguvim.config")
    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

    for name, sign in pairs(Config.icons.dap) do
      sign = type(sign) == "table" and sign or { sign }
      vim.fn.sign_define(
        "Dap" .. name,
        { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
      )
    end
  end,
}
