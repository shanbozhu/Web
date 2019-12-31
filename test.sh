#!/bin/bash
# 将ip地址替换为本机地址

# 获取网络ip
aa=$(ifconfig en0 | sed -e 's/ /\'$'\n/g' | grep -i 1 | sed -n '3p')
echo "当前网络的ip:$aa"

# 获取index.html中的ip
bb=$(cat ./index.html | sed -e 's/\//\'$'\n/g' | grep -i 172 | sed -n '1p')
if [ -z "$bb" ]; then
    read bb 0< lastip.conf
fi
echo "本地文件的ip:$bb"

if [ -z "$aa" ] || [ -z "$bb" ] || [ "$aa" == "$bb" ]; then
    echo "替换失败!获取到的ip无效或二者相同"
    exit 0
fi

# 调用update.sh脚本执行替换操作
./update.sh $bb $aa html
./update.sh $bb $aa plist

# 替换完成,记录上一次的ip
echo "$aa" 1> lastip.conf

# 输出成功提示
URL="http://$aa"
echo -e "🍺 浏览器访问: \033[34m$URL\033[0m"

# 生成访问本站地址的二维码
qrencode -o index.png -s 10 -m 1 "$URL"

# 将改动推送到github仓库
git add .
git commit -m "修改为本机ip" &> /dev/null
git push &> /dev/null

# 将manifest.plist文件推送到coding仓库
cp -a ./common/manifest.plist ../OTA
cd ../OTA
git add .
git commit -m "上传manifest文件" &> /dev/null
git push &> /dev/null
