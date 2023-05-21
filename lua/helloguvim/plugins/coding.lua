return {
  -- 代码折叠
  {
    "kevinhwang91/nvim-ufo",
    event = { "User AstroFile", "InsertEnter" },
    dependencies = { "kevinhwang91/promise-async" },
    opts = {
      open_fold_hl_timeout = 0,
      close_fold_kinds = {},
      ---@diagnostic disable-next-line: unused-local
      provider_selector = function(bufnr, filetype, buftype)
        local M = {
          requires = {
            "ufo",
          },
          filetype_fold_config = {
            markdown = { "treesitter", "indent" },
          },
        }
        return M.filetype_fold_config[filetype] or { "lsp", "indent" }
      end,

      fold_virt_text_handler = function(virtual_text, lnum, end_lnum, width, truncate)
        local new_virtual_text = {}
        local suffix = ("   %d"):format(end_lnum - lnum)
        local suffix_width = vim.fn.strdisplaywidth(suffix)
        local target_width = width - suffix_width
        local current_width = 0
        for _, chunk in ipairs(virtual_text) do
          local chunk_text = chunk[1]
          local chunk_width = vim.fn.strdisplaywidth(chunk_text)
          if target_width > current_width + chunk_width then
            table.insert(new_virtual_text, chunk)
          else
            chunk_text = truncate(chunk_text, target_width - current_width)
            local hlGroup = chunk[2]
            table.insert(new_virtual_text, { chunk_text, hlGroup })
            chunk_width = vim.fn.strdisplaywidth(chunk_text)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if current_width + chunk_width < target_width then
              suffix = suffix .. (" "):rep(target_width - current_width - chunk_width)
            end
            break
          end
          current_width = current_width + chunk_width
        end
        table.insert(new_virtual_text, { suffix, "MoreMsg" })
        return new_virtual_text
      end,
    },
  },

  -- 反义词
  {
    "AndrewRadev/switch.vim",
    event = { "VeryLazy" },
  },

  -- 函数列表
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },

  -- snippets
  {
    "L3MON4D3/LuaSnip",
    -- build = (not jit.os:find("Windows"))
    -- and "echo -e 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
    -- or nil,
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
        -- stylua: ignore
    keys = {
      {
        -- snip跳到下一处编辑点
        "`",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "`"
        end,
        expr = true, silent = true, mode = "i",
      },
      { "`", function() require("luasnip").jump(1) end, mode = "s" },

      -- snip跳到上一处编辑点
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },

  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
      local cmp = require("cmp")
      local function border(hl_name)
        return {
          { "╭", hl_name },
          { "─", hl_name },
          { "╮", hl_name },
          { "│", hl_name },
          { "╯", hl_name },
          { "─", hl_name },
          { "╰", hl_name },
          { "│", hl_name },
        }
      end
      local border_opts = {
        border = border("CmpDocBorder"),
        -- border = "single",
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
      }
      return {
        -- window = {
        --   completion = cmp.config.window.bordered(border_opts),
        --   documentation = cmp.config.window.bordered(border_opts),
        -- },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
          completion = {
            border = border("CmpDocBorder"),
            winhighlight = "Normal:CmpDoc",
          },
          documentation = {
            border = border("CmpDocBorder"),
            winhighlight = "Normal:CmpDoc",
          },
        },
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),

        -- 补全来源
        sources = cmp.config.sources({
          -- { name = "nvim_lsp", priority = 1000 },
          -- { name = "luasnip", priority = 750 },
          -- { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }),
        formatting = {
          format = function(_, item)
            local icons = require("helloguvim.config").icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        -- 灰色显示可能输入
        -- experimental = {
        --     ghost_text = {
        --         hl_group = "LspCodeLens",
        --     },
        -- },
      }
    end,
  },

  -- auto pairs
  -- 自动括号匹配
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    config = function()
      require("mini.pairs").setup({
        modes = { insert = true, command = false, terminal = true },
      })
    end,
  },

  -- surround
  -- {
  --   "echasnovski/mini.surround",
  --   keys = function(_, keys)
  --     -- Populate the keys based on the user's options
  --     local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
  --     local opts = require("lazy.core.plugin").values(plugin, "opts", false)
  --     local mappings = {
  --       { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
  --       { opts.mappings.delete, desc = "Delete surrounding" },
  --       { opts.mappings.find, desc = "Find right surrounding" },
  --       { opts.mappings.find_left, desc = "Find left surrounding" },
  --       { opts.mappings.highlight, desc = "Highlight surrounding" },
  --       { opts.mappings.replace, desc = "Replace surrounding" },
  --       { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
  --     }
  --     mappings = vim.tbl_filter(function(m)
  --       return m[1] and #m[1] > 0
  --     end, mappings)
  --     return vim.list_extend(mappings, keys)
  --   end,
  --   opts = {
  --     mappings = {
  --       add = "gza", -- Add surrounding in Normal and Visual modes
  --       delete = "gzd", -- Delete surrounding
  --       find = "gzf", -- Find surrounding (to the right)
  --       find_left = "gzF", -- Find surrounding (to the left)
  --       highlight = "gzh", -- Highlight surrounding
  --       replace = "gzr", -- Replace surrounding
  --       update_n_lines = "gzn", -- Update `n_lines`
  --     },
  --   },
  --   config = function(_, opts)
  --     -- use gz mappings instead of s to prevent conflict with leap
  --     require("mini.surround").setup(opts)
  --   end,
  -- },

  -- 注释
  {
    "numToStr/Comment.nvim",
    opts = {
      opleader = {
        line = "gc",
        block = "gb",
      },
      toggler = {
        line = "gcc",
        block = "gcb",
      },
      extra = {
        -- 上一行创建注释
        above = "gck",
        -- 下一行创建注释
        below = "gcj",
        -- 行尾创建注释
        eol = "gca",
      },
    },
  },

  -- better text-objects
  -- {
  --   "echasnovski/mini.ai",
  --   -- keys = {
  --   --   { "a", mode = { "x", "o" } },
  --   --   { "i", mode = { "x", "o" } },
  --   -- },
  --   event = "VeryLazy",
  --   dependencies = { "nvim-treesitter-textobjects" },
  --   opts = function()
  --     local ai = require("mini.ai")
  --     return {
  --       n_lines = 500,
  --       custom_textobjects = {
  --         o = ai.gen_spec.treesitter({
  --           a = { "@block.outer", "@conditional.outer", "@loop.outer" },
  --           i = { "@block.inner", "@conditional.inner", "@loop.inner" },
  --         }, {}),
  --         f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
  --         c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
  --       },
  --     }
  --   end,
  --   config = function(_, opts)
  --     require("mini.ai").setup(opts)
  --     -- register all text objects with which-key
  --     if require("helloguvim.util").has("which-key.nvim") then
  --       ---@type table<string, string|table>
  --       local i = {
  --         [" "] = "Whitespace",
  --         ['"'] = 'Balanced "',
  --         ["'"] = "Balanced '",
  --         ["`"] = "Balanced `",
  --         ["("] = "Balanced (",
  --         [")"] = "Balanced ) including white-space",
  --         [">"] = "Balanced > including white-space",
  --         ["<lt>"] = "Balanced <",
  --         ["]"] = "Balanced ] including white-space",
  --         ["["] = "Balanced [",
  --         ["}"] = "Balanced } including white-space",
  --         ["{"] = "Balanced {",
  --         ["?"] = "User Prompt",
  --         _ = "Underscore",
  --         a = "Argument",
  --         b = "Balanced ), ], }",
  --         c = "Class",
  --         f = "Function",
  --         o = "Block, conditional, loop",
  --         q = "Quote `, \", '",
  --         t = "Tag",
  --       }
  --       local a = vim.deepcopy(i)
  --       for k, v in pairs(a) do
  --         a[k] = v:gsub(" including.*", "")
  --       end
  --
  --       local ic = vim.deepcopy(i)
  --       local ac = vim.deepcopy(a)
  --       for key, name in pairs({ n = "Next", l = "Last" }) do
  --         i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
  --         a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
  --       end
  --       require("which-key").register({
  --         mode = { "o", "x" },
  --         i = i,
  --         a = a,
  --       })
  --     end
  --   end,
  -- },
}
