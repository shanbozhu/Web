#!/bin/sh
# Mac系统下，查找含有$1文本的文件，并将这些文件中的$1文本替换为$2文本
LC_CTYPE=C sed -i "" "s/$1/$2/g" `grep -rl $1 .`
