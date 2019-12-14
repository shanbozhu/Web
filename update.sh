#!/bin/bash
# 用法：./update.sh 3.18.22.70 192.168.0.111
# Mac系统下，查找含有$1文本的文件，并将这些文件中的$1文本替换为$2文本

if [ ! $# -eq 2 -a ! $# -eq 3 ]; then
    echo usage:{$0 text1 text2 type}; exit 
else
    echo 正在使用文本\"$2\"替换文本\"$1\" 
fi

if [ ! $3 ]; then
    LC_CTYPE=C sed -i "" "s/$1/$2/g" `grep -rl $1 . --include=*.$3`
else
    LC_CTYPE=C sed -i "" "s/$1/$2/g" `grep -rl $1 .`
fi
echo 替换完成!
