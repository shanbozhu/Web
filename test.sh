#!/bin/bash
# 将ip地址替换为本机地址

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
    localFileIP=$(cat ./index.html | sed -e 's/\//\'$'\n/g' | grep -i 172 | sed -n '1p')
    if [ -z "$localFileIP" ]; then
        read localFileIP 0< lastip.conf
    fi
    echo "$localFileIP"
    return 0;
}
localFileIP=$(getLocalFileIP)
echo "本地文件的ip:$localFileIP"

function checkReplace() {
    if [ -z "$netIP" ] || [ -z "$localFileIP" ] || [ "$netIP" == "$localFileIP" ]; then
        echo "替换失败!获取到的ip无效或二者相同"
        exit 0
    fi
    return 0
}
#checkReplace

# 调用update.sh脚本执行替换操作
#function replace() {
#    ./update.sh $localFileIP $netIP html
#    ./update.sh $localFileIP $netIP plist
#    return 0
#}
#replace
function replace() {
    source ./update.sh
    replacementOperation $localFileIP $netIP html
#    ./update.sh $localFileIP $netIP plist
    return 0
}
replace

function afterReplacement() {
    # 替换完成,记录上一次的ip
    echo "$netIP" 1> lastip.conf

    # 生成访问本站地址的二维码
    URL="http://$netIP"
    qrencode -o index.png -s 10 -m 1 "$URL"

    # 输出成功提示
    echo -e "🍺 浏览器访问: \033[34m$URL\033[0m"
    return 0
}
afterReplacement

# 将改动推送到github仓库
function pushGithub() {
    git add .
    git commit -m "修改为本机ip" &> /dev/null
    git push &> /dev/null
    return 0
}
pushGithub

# 将manifest.plist文件推送到coding仓库
function pushCoding() {
    cp -a ./common/manifest.plist ../OTA
    cd ../OTA
    
    git add .
    git commit -m "上传manifest文件" &> /dev/null
    git push &> /dev/null
    return 0
}
pushCoding
