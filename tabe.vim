function! MVCtabe()
python << EOF
# coding=utf-8

##################################################
#   author: lsp, lspbupt@sina.com
#   date: 2013年 08月 21日 星期三 16:53:26 CST
#   usage: ctrl + n
##################################################

import vim
import re
import os

#可以将该basename修改为自己的mvc框架的根目录
basename = ""

row, col = vim.current.window.cursor
line = vim.current.line
#获取当前buffer
buffer = vim.current.buffer

#获取当前单词
start = end = col
while True:
    if line[start] == 0:
        break
    if line[start].isalpha() or line[start] == ":":
        start -= 1
    else:
        break
m = re.search("([\w:]+\(?)", line[start:])
if m:
    word = m.group(0)
    #判断所需要查询的是否为函数
    functionName = "";
    if word.endswith("("):
        word = word[:-1]
        functionName = "function"

    list = word.split("::")
    className = list[0]
    methodName = ""
    dirname = basename

    if len(list) > 1:
        methodName = list[1]

    #根据方法获取文件名并跳转
    if className[-5:] == "Model":
        dirname += "model/"
    elif className[-10:] == "Controller":
        dirname += "controller/"
    elif className[-6:] == "Helper":
        dirname += "helper/"
    else:
        dirname += "classes/"
    dirname += className + ".php"
    if os.path.isfile(dirname):
        if functionName and ( not methodName):
            methodName = "__construct"
        vim.command("tabe " + dirname)
    else:
        if className != 'self':
            print "该函数不存在!"

    #在vim跳转后，搜索当前文件，移至该函数的定义处
    row,col = vim.current.window.cursor
    buf = vim.current.buffer
    if methodName:
        pa = r'%s\s+%s' %(functionName, methodName)
        i=0
        for i in range(0,len(buf)):
            m1 = re.search(pa, buf[i])
            if m1:
                vim.current.window.cursor = (i+1, col)
                break
EOF
endfunction
map <C-N> :call MVCtabe()<CR>
