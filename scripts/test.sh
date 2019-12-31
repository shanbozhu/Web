#!/bin/bash
# 将当前目录下所有html和plist文件中的ip地址替换为本机地址

directory=../
htmlPath=${directory}index.html
lastIPPath=./lastip.conf

# 获取网络ip
function getNetIP() {
    netIP=$(ifconfig en0 | sed -e 's/ /\'$'\n/g' | grep -i 1 | sed -n '3p')
    echo "$netIP"
    return 0;
}
netIP=$(getNetIP)
echo "当前网络的ip:$netIP"

# 获取index.html中的ip
function getLocalFileIP() {
    localFileIP=$(cat ${htmlPath} | sed -e 's/\//\'$'\n/g' | grep -i 172 | sed -n '1p')
    if [ -z "$localFileIP" ]; then
        read localFileIP 0< $lastIPPath
    fi
    echo "$localFileIP"
    return 0;
}
localFileIP=$(getLocalFileIP)
echo "本地文件的ip:$localFileIP"

function checkReplace() {
    if [ -z "$netIP" ] || [ -z "$localFileIP" ] || [ "$netIP" == "$localFileIP" ]; then
        echo "替换失败!获取到的ip无效或二者相同"
        echo -e "浏览器尝试访问: \033[34mhttp://$netIP\033[0m"
        exit 0
    fi
    return 0
}
checkReplace

# 调用update.sh脚本执行替换操作
function replace() {
    ./update.sh $localFileIP $netIP html
    ./update.sh $localFileIP $netIP plist
    echo 替换完成!
    return 0
}
replace

URL="http://$netIP"
function afterReplacement() {
    # 记录上一次的ip到本地文件
    echo "$netIP" 1> $lastIPPath

    # 生成访问本站地址的二维码
    qrencode -o index.png -s 10 -m 1 "$URL"
    return 0
}
afterReplacement

source push.sh
function push() {
    pushGithub "正在推送本地改动到github仓库..."
    pushCoding "正在推送manifest.plist文件到coding仓库..."
    return 0
}
push


# 输出成功提示
echo -e "🍺 浏览器访问: \033[34m$URL\033[0m"
