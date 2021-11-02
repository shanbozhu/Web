#!/bin/bash
# Mac系统下，查找$4目录下所有含有$1文本的文件，并将这些文件中的$1文本替换为$2文本

function replacementOperation() {
    if [ ! $# -eq 4 ]; then
        echo "usage:{$0 text1 text2 type path}"
        exit
    else
        echo "替换所有\"$3\"中的\"$1\"为\"$2\""
    fi

    if [ ! -z $3 ]; then
        LC_CTYPE=C sed -i "" "s/$1/$2/g" $(grep -rl $1 $4 --include=*.$3) &>/dev/null
    else
        #LC_CTYPE=C sed -i "" "s/$1/$2/g" `grep -rl $1 $4` &> /dev/null
        LC_CTYPE=C sed -i "" "s/$1/$2/g" $(grep -rl $1 $4) &>/dev/null
    fi
    return 0
}
replacementOperation $1 $2 $3 $4
