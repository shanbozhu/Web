#!/bin/bash
# 将ip地址替换为本机地址

# 获取网络ip
function getNetIP() {
    NETIP=$(ifconfig en0 | sed -e 's/ /\'$'\n/g' | grep -i 1 | sed -n '3p')
    echo "$NETIP"
    return 0;
}
NETIP=$(getNetIP)
echo "当前网络的ip:$NETIP"

# 获取index.html中的ip
function getLocalFileIP() {
    LOCALFILEIP=$(cat ./index.html | sed -e 's/\//\'$'\n/g' | grep -i 172 | sed -n '1p')
    if [ -z "$LOCALFILEIP" ]; then
        read LOCALFILEIP 0< lastip.conf
    fi
    echo "$LOCALFILEIP"
    return 0;
}
LOCALFILEIP=$(getLocalFileIP)
echo "本地文件的ip:$LOCALFILEIP"

#echo $NETIP

if [ -z "$NETIP" ] || [ -z "$LOCALFILEIP" ] || [ "$NETIP" == "$LOCALFILEIP" ]; then
    echo "替换失败!获取到的ip无效或二者相同"
    exit 0
fi

# 调用update.sh脚本执行替换操作
./update.sh $LOCALFILEIP $NETIP html
./update.sh $LOCALFILEIP $NETIP plist

# 替换完成,记录上一次的ip
echo "$NETIP" 1> lastip.conf

# 输出成功提示
URL="http://$NETIP"
echo -e "🍺 浏览器访问: \033[34m$URL\033[0m"

# 生成访问本站地址的二维码
qrencode -o index.png -s 10 -m 1 "$URL"

# 将改动推送到github仓库
function pushGithub() {
    git add .
    git commit -m "修改为本机ip" &> /dev/null
    git push &> /dev/null
    return 0
}
#pushGithub

# 将manifest.plist文件推送到coding仓库
function pushCoding() {
    cp -a ./common/manifest.plist ../OTA
    cd ../OTA
    
    git add .
    git commit -m "上传manifest文件" &> /dev/null
    git push &> /dev/null
    return 0
}
#pushCoding

