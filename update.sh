#!/bin/bash
# Mac系统下，查找含有$1文本的文件，并将这些文件中的$1文本替换为$2文本

function replacementOperation() {
    if [ ! $# -eq 2 -a ! $# -eq 3 ]; then
        echo "usage:{$0 text1 text2 type}"; exit
    else
        echo "正在替换当前目录下所有$3文件中的文本\"$1\"为\"$2\""
    fi

    if [ ! -z $3 ]; then
        LC_CTYPE=C sed -i "" "s/$1/$2/g" `grep -rl $1 . --include=*.$3` &> /dev/null
    else
        LC_CTYPE=C sed -i "" "s/$1/$2/g" `grep -rl $1 .` &> /dev/null
    fi
    return 0
}
replacementOperation $1 $2 $3
