return {
  {
    "NvChad/nvim-colorizer.lua",
    config = function(_, opts)
      require("colorizer").setup(opts)
      -- execute colorizer as soon as possible
    end,
  },

  -- 光标动画
  {
    "echasnovski/mini.animate",
    enabled = false,
    event = "VeryLazy",
    opts = function()
      -- don't use animate when scrolling with the mouse
      local mouse_scrolled = false
      for _, scroll in ipairs({ "Up", "Down" }) do
        local key = "<ScrollWheel" .. scroll .. ">"
        vim.keymap.set({ "", "i" }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end

      local animate = require("mini.animate")
      return {
        resize = {
          timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
        },
        scroll = {
          timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
          subscroll = animate.gen_subscroll.equal({
            predicate = function(total_scroll)
              if mouse_scrolled then
                mouse_scrolled = false
                return false
              end
              return total_scroll > 1
            end,
          }),
        },
      }
    end,
    config = function(_, opts)
      require("mini.animate").setup(opts)
    end,
  },
  -- Better `vim.notify()`
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      -- background_colour = "#000000", --"Normal",
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    init = function()
      -- when noice is not enabled, install notify on VeryLazy
      local Util = require("helloguvim.util")
      if not Util.has("noice.nvim") then
        Util.on_very_lazy(function()
          vim.notify = require("notify")
        end)
      end
    end,
  },

  -- better vim.ui
  -- 悬浮输入窗
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- bufferline
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bq", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "close all buffers" },
    },

    opts = {
      options = {
                -- stylua: ignore
                close_command = function(n) require("mini.bufremove").delete(n, false) end,
                -- stylua: ignore
                right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
        diagnostics = "nvim_lsp",
        buffer_close_icon = "",
        numbers = "none",
        always_show_bufferline = false,
        separator_style = "thin", --| "slant" | "thick" | "thin" | { 'any', 'any' },
        sort_by = "id", -- ,'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
        -- diagnostics_indicator = function(_, _, diag)
        --     local icons = require("helloguvim.config").icons.diagnostics
        --     local ret = (diag.error and icons.Error .. diag.error .. " " or "")
        --     .. (diag.warning and icons.Warn .. diag.warning or "")
        --     return vim.trim(ret)
        -- end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local icons = require("helloguvim.config").icons
      local Util = require("helloguvim.util")

      local branch = {
        "branch",
        icons_enabled = true,
        icon = "",
      }
      return {
        options = {
          theme = "auto",
          globalstatus = true,
          -- component_separators = { left = "|", right = "|" },
          -- section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
        },
        sections = {
          lualine_a = { "mode" },
          -- lualine_b = { "branch" },
          -- lualine_b = { branch },
          lualine_b = {},
          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            {
              "filetype",
              -- 只显示图标
              icon_only = true,
              separator = "",
              padding = {
                left = 1,
                right = 0,
              },
            },
            -- { "filename", path = 0, symbols = { modified = "  ", readonly = "", unnamed = "" } },
            -- stylua: ignore
            -- 函数winbar
            -- {
            --     function() return require("nvim-navic").get_location() end,
            --     cond = function()
            --         return package.loaded["nvim-navic"] and
            --             require("nvim-navic").is_available()
            --     end,
            -- },
          },
          lualine_x = {

            -- -- stylua: ignore
            -- {
            --     function() return require("noice").api.status.command.get() end,
            --     cond = function()
            --         return package.loaded["noice"] and
            --             require("noice").api.status.command.has()
            --     end,
            --     color = Util.fg("Statement"),
            -- },
            -- -- stylua: ignore
            -- {
            --     function() return require("noice").api.status.mode.get() end,
            --     cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            --     color = Util.fg("Constant"),
            -- },
            -- -- stylua: ignore
            -- {
            --     function() return "  " .. require("dap").status() end,
            --     cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            --     color = Util.fg("Debug"),
            -- },
            -- {
            --     require("lazy.status").updates,
            --     cond = require("lazy.status").has_updates,
            --     color = Util.fg("Special"),
            -- },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
            },
            -- padding 占位字符数
            { "progress", separator = " ", padding = { left = 1, right = 1 } },
            -- { "location", padding = { left = 0, right = 1 } },
          },
          lualine_y = {
            function()
              local fmt = "%H:%M"
              return " " .. os.date(fmt)
            end,
          },
          lualine_z = {
            function()
              return " " .. os.date("%Y/%m/%d")
            end,
          },
        },
        extensions = { "neo-tree", "lazy" },
      }
    end,
  },

  -- indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- char = "▏",
      char = "│",
      filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
  },

  -- active indent guide and indent text objects
  -- 动态缩进
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
    config = function(_, opts)
      require("mini.indentscope").setup(opts)
    end,
  },

  -- noicer ui
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      -- which key integration
      {
        "folke/which-key.nvim",
        opts = function(_, opts)
          if require("helloguvim.util").has("noice.nvim") then
            opts.defaults["<leader>sn"] = { name = "+noice" }
          end
        end,
      },
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        -- inc_rename = false, -- enables an input dialog for inc-rename.nvim
        -- 为其他悬停文档和签名帮助添加边框
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    },
        -- stylua: ignore
        keys = {
            {
                "<S-Enter>",
                function() require("noice").redirect(vim.fn.getcmdline()) end,
                mode = "c",
                desc =
                "Redirect Cmdline"
            },
            {
                "<leader>snl",
                function() require("noice").cmd("last") end,
                desc =
                "Noice Last Message"
            },
            {
                "<leader>snh",
                function() require("noice").cmd("history") end,
                desc =
                "Noice History"
            },
            {
                "<leader>sna",
                function() require("noice").cmd("all") end,
                desc =
                "Noice All"
            },
            {
                "<leader>snd",
                function() require("noice").cmd("dismiss") end,
                desc =
                "Dismiss All"
            },
            {
                "<c-f>",
                function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,
                silent = true,
                expr = true,
                desc =
                "Scroll forward",
                mode = {
                    "i", "n", "s" }
            },
            {
                "<c-b>",
                function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end,
                silent = true,
                expr = true,
                desc =
                "Scroll backward",
                mode = {
                    "i", "n", "s" }
            },
        },
  },

  -- dashboard
  -- 启动页
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      --            local logo = [[
      --  __    __            __  __                   ______
      -- /  |  /  |          /  |/  |                 /      \
      -- $$ |  $$ |  ______  $$ |$$ |  ______        /$$$$$$  | __    __
      -- $$ |__$$ | /      \ $$ |$$ | /      \       $$ | _$$/ /  |  /  |
      -- $$    $$ |/$$$$$$  |$$ |$$ |/$$$$$$  |      $$ |/    |$$ |  $$ |
      -- $$$$$$$$ |$$    $$ |$$ |$$ |$$ |  $$ |      $$ |$$$$ |$$ |  $$ |
      -- $$ |  $$ |$$$$$$$$/ $$ |$$ |$$ \__$$ |      $$ \__$$ |$$ \__$$ |
      -- $$ |  $$ |$$       |$$ |$$ |$$    $$/       $$    $$/ $$    $$/
      -- $$/   $$/ $$$$$$$/ $$/ $$/  $$$$$$/          $$$$$$/   $$$$$$/
      --            ]]

      -- http://patorjk.com/software/taag
      -- Font style: ANSI Shadow
      local logo = [[
            ██╗  ██╗███████╗██╗     ██╗      ██████╗      ██████╗ ██╗   ██╗          Z
            ██║  ██║██╔════╝██║     ██║     ██╔═══██╗    ██╔════╝ ██║   ██║      Z
            ███████║█████╗  ██║     ██║     ██║   ██║    ██║  ███╗██║   ██║   z
            ██╔══██║██╔══╝  ██║     ██║     ██║   ██║    ██║   ██║██║   ██║ z
            ██║  ██║███████╗███████╗███████╗╚██████╔╝    ╚██████╔╝╚██████╔╝
            ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝ ╚═════╝      ╚═════╝  ╚═════╝
                      
                             Good Good Study   Day Day Up
            ]]

      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
        dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
        dashboard.button("e", " " .. " File Explorer", ":Neotree <CR>"),
        -- dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
        -- dashboard.button("s", " " .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "helloguvimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },

  -- lsp symbol navigation for lualine
  -- winbar 组件
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
      vim.g.navic_silence = true
      require("helloguvim.util").on_attach(function(client, buffer)
        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, buffer)
        end
      end)
    end,
    opts = function()
      return {
        icons = {
          File = " ",
          Module = " ",
          Namespace = " ",
          Package = " ",
          Class = " ",
          Method = " ",
          Property = " ",
          Field = " ",
          Constructor = " ",
          Enum = "練",
          Interface = "練",
          Function = " ",
          Variable = " ",
          Constant = " ",
          String = " ",
          Number = " ",
          Boolean = "◩ ",
          Array = " ",
          Object = " ",
          Key = " ",
          Null = "ﳠ ",
          EnumMember = " ",
          Struct = " ",
          Event = " ",
          Operator = " ",
          TypeParameter = " ",
        },
        highlight = true,
        separator = " > ",
        depth_limit = 5,
        depth_limit_indicator = "..",
        safe_output = true,
        -- separator = " ",
        -- highlight = true,
        -- depth_limit = 5,
        -- icons = require("helloguvim.config").icons.kinds,
      }
    end,
  },

  -- icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },
}
