-- This file is automatically loaded by plugins.config
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- 自动保存
opt.autowrite = true -- Enable auto write
-- 离开插入模式或普通模式有更改时自动保存
if opt.autowrite then
    vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
        pattern = { "*" },
        command = "silent! wall",
        nested = true,
    })
end

-- 全局缩进
opt.tabstop = 4 -- Number of spaces tabs count for
opt.shiftwidth = 4 -- Size of an indent
opt.expandtab = true -- Use spaces instead of tabs
-- 根据文件类型设置缩进规则  注意与null-ls保持一致
-- 配置文件放在~/.config/nvim/ftplugin/目录下
opt.filetype = "plugin"

-- 系统剪贴板
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"

-- 隐藏粗体和斜体标记 如markdown的标记符号
-- opt.conceallevel = 3 -- Hide * markup for bold and italic

-- 退出时不询问保存
opt.confirm = false -- Confirm to save changes before exiting modified buffer
-- 高亮当前行
opt.cursorline = true -- Enable highlighting of the current line

opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
-- grep使用的程序
opt.grepprg = "rg --vimgrep"

-- 搜索时忽略大小写
opt.ignorecase = true -- Ignore case

-- 原位置即时预览命令效果
opt.inccommand = "nosplit" -- preview incremental substitute
-- 不显示状态行
opt.laststatus = 0
-- 显示行尾不可见字符 space tab等
opt.list = true -- Show some invisible characters (tabs...
-- 启用鼠标
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = false -- Relative line numbers

--光标上下移动保留的行数
opt.scrolloff = 5 -- Lines of context

-- 保存会话选项
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }

opt.shiftround = true -- Round indent
opt.shortmess:append({ W = true, I = true, c = true })
opt.showmode = false -- Dont show mode since we have a statusline
-- 光标水平移动保留的字符数
opt.sidescrolloff = 8 -- Columns of context
-- 显示左侧标识列
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
--搜索时若只有大写字母就区分大小写
opt.smartcase = true -- Don't ignore case with capitals
--边输入边搜索
opt.incsearch = true
opt.smartindent = true -- Insert indents automatically
-- 英文拼写检查
opt.spelllang = { "en" }
-- 默认新窗口右和下
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
-- 避免编辑器启动时代码自动折叠
vim.o.foldlevel = 99

-- 终端真颜色
opt.termguicolors = true -- True color support
opt.timeoutlen = 300
-- 持久性撤销
opt.undofile = true
opt.undolevels = 10000
-- 持久性撤销文件保存目录，目录自动创建
-- 生成的文件名带有绝对路径并使用%替换/,防止重命名
-- opt.undodir = vim.fn.expand "~/.cache/nvim/undo/"

--使用-连起的单词认为是一个单词 此处+=是运算符
vim.cmd([[set iskeyword+=-]])

--不生成备份文件
opt.backup = false
opt.swapfile = false

-- 命令补全匹配模式
opt.wildmode = "list:full" -- Command-line completion mode
-- 非当前窗口的最小宽度
opt.winminwidth = 5 -- Minimum window width
-- 折行
opt.wrap = true -- Disable line wrap
-- 回绕行重复缩进
opt.breakindent = true
--取消新行自动注释
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "*" },
    command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
})


-- 光标到达行首或行尾时,使用h\l可转到上一行或下一行的行尾或行首
-- opt.whichwrap:append "<>[]hl"

if vim.fn.has("nvim-0.9.0") == 1 then
    opt.splitkeep = "screen"
    opt.shortmess:append({ C = true })
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
