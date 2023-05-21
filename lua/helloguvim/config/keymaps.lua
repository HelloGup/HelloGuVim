-- This file is automatically loaded by helloguvim.plugins.config

local Util = require("helloguvim.util")

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

map("i", "jj", "<esc>", { silent = true })

-- better up/down
map("n", "j", "v:count == 0 ? 'j' : 'gj'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'k' : 'gk'", { expr = true, silent = true })

-- 移至行首行尾
map({ "n", "v" }, "H", "^", { silent = true })
map({ "n", "v" }, "L", "$", { silent = true })

-- 快速移动
map("n", "J", "5jzz", { silent = true })
map("n", "K", "5kzz", { silent = true })

-- 删或复制至行首
map("n", "yH", "y0", { silent = true })
map("n", "dH", "d0", { silent = true })

-- 删除全文行尾空格
map("n", "ds", ":%s#\\s\\+$##g<CR>zz", { desc = "Delete space", silent = true })

-- 插入模式导航
map("i", "<C-e>", "<End>", { silent = true })
map("i", "<C-h>", "<Left>", { silent = true })
map("i", "<C-l>", "<Right>", { silent = true })
map("i", "<C-j>", "<Down>", { silent = true })
map("i", "<C-k>", "<Up>", { silent = true })

-- 插入模式粘贴
map("i", "<C-p>", "<ESC>pli", { silent = true })

-- 当前行居中
map("n", "#", "#zz", { silent = true, noremap = true })
map("n", "<C-o>", "<C-o>zz", { silent = true, noremap = true })
map("n", "<C-i>", "<C-i>zz", { silent = true, noremap = true })
map("n", "i", "zzi", { silent = true, noremap = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize window using <ctrl> arrow keys
-- 调整窗口尺寸
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines 块移动
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- buffers
if Util.has("bufferline.nvim") then
  map("n", "bh", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  map("n", "bl", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
  map("n", "<TAB>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
else
  map("n", "bh", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  map("n", "bl", "<cmd>bnext<cr>", { desc = "Next buffer" })
end
-- 关闭当前buffer 不关闭窗口
--使用mibi.bufremove 插件实现 该映射不需要了
-- map("n", "bd", ":bd<CR>", opts)

map("n", "<leader>b1", "<cmd>BufferLineGoToBuffer 1<cr>", { desc = "go to buffer 1", silent = true })
map("n", "<leader>b2", "<cmd>BufferLineGoToBuffer 2<cr>", { desc = "go to buffer 2", silent = true })
map("n", "<leader>b3", "<cmd>BufferLineGoToBuffer 3<cr>", { desc = "go to buffer 3", silent = true })
map("n", "<leader>b4", "<cmd>BufferLineGoToBuffer 4<cr>", { desc = "go to buffer 4", silent = true })
map("n", "<leader>b5", "<cmd>BufferLineGoToBuffer 5<cr>", { desc = "go to buffer 5", silent = true })
map("n", "<leader>b6", "<cmd>BufferLineGoToBuffer 6<cr>", { desc = "go to buffer 6", silent = true })
map("n", "<leader>b7", "<cmd>BufferLineGoToBuffer 7<cr>", { desc = "go to buffer 7", silent = true })
map("n", "<leader>b9", "<cmd>BufferLineGoToBuffer 9<cr>", { desc = "go to buffer 9", silent = true })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { noremap = true, desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update" }
)

-- 高亮搜索光标下单词
map({ "n", "x" }, "*", "*N", { desc = "Search word under cursor" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
-- n和N的方向始终是向下和向上搜索
map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- save file
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- better indenting
--快速缩进
map("v", "<", "<gv")
map("v", ">", ">gv")
map("n", "<", "<<", { noremap = true })
map("n", ">", ">>", { noremap = true })

-- lazy
map("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- markdown preview 仅在md文件有效
map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "markdown preview" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- trouble
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

if not Util.has("trouble.nvim") then
  map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
  map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
end

-- toggle options
map("n", "<leader>us", function()
  Util.toggle("spell")
end, { desc = "Toggle Spelling" })
-- 开启关闭折行
map("n", "<leader>uw", function()
  Util.toggle("wrap")
end, { desc = "Toggle Word Wrap" })
-- 开启关闭相对行号
map("n", "<leader>ul", function()
  Util.toggle("relativenumber", true)
  Util.toggle("number")
end, { desc = "Toggle Line Numbers" })
-- 开启关闭显示错误信息
map("n", "<leader>ud", Util.toggle_diagnostics, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3

map("n", "<leader>uc", function()
  Util.toggle("conceallevel", false, { 0, conceallevel })
end, { desc = "Toggle Conceal" })

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
  map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
end

-- floating terminal
-- map("n", "<leader>ft", function() Util.float_term(nil, { cwd = Util.get_root() }) end, { desc = "Terminal (root dir)" })
-- map("n", "<leader>fT", function() Util.float_term() end, { desc = "Terminal (cwd)" })
-- map("t", "<esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })

-- Copy all
map("n", "<C-c>", "<cmd> %y+ <CR><CR>", { desc = "copy all", silent = true })

-- windows
map("n", "<leader>wq", "<C-W>o", { desc = "Delete other window" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete current window" })
-- 分屏
map("n", "<leader>-", "<C-W>v", { desc = "Split window below" })
map("n", "<leader>|", "<C-W>s", { desc = "Split window right" })
--水平、垂直分屏布局切换
-- map("n", xxx, "<C-w>b<C-w>K", { noremap = true })
-- map("n", xxx, "<C-w>b<C-w>H", { noremap = true })

-- tabs
-- map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
-- map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
-- map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
-- map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
-- map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
-- map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- 折叠
map("n", "zR", require("ufo").openAllFolds)
map("n", "zM", require("ufo").closeAllFolds)

-- toggleterm 退出终端模式
map("t", "<ESC>", "<c-\\><c-n>", { desc = "Escape term insert mode", silent = true })

-- 注释上加========
map("v", "<leader>cb", "`<`>``yyP_Wv$r=$5a=yy``p", { desc = "CommentBox", silent = true })
