#!/bin/bash
# 将ip地址替换为本机地址

# 网络ip
aa=$(ifconfig en0 | sed -e 's/ /\'$'\n/g' | grep -i 1 | sed -n '3p')
echo "$aa"

# index.html中的ip
bb=$(cat ./index.html | sed -e 's/\//\'$'\n/g' | grep -i 172 | sed -n '1p')
echo "$bb"
if [ -z "$bb" ]; then
    read bb 0< lastip.conf
    echo "-------"
fi
echo "$bb"



#cc=$(cat ~/Desktop/CustomWeb/index.html | sed -e 's/\//\'$'\n/g')
#cc=$(cat ~/Desktop/CustomWeb/index.html | sed -e 's/\//\n/g') # GNU版本写法,非Mac OS的BSD版本写法
#cc=$(more ~/Desktop/CustomWeb/index.html | tr '\/' '\n')
#echo "$cc"

if [ -z "$aa" ] || [ -z "$bb" ] || [ "$aa" == "$bb" ]; then
    echo "aa或bb为空或aa与bb相同"
    exit 0
fi

./update.sh $bb $aa html
./update.sh $bb $aa plist

# 替换完成,记录上一次的ip
echo "$aa" 1> lastip.conf

URL="http://$aa"
#open URL
echo -e "🍺 浏览器访问: \033[34m$URL\033[0m"
qrencode -o index.png -s 10 -m 1 "$URL"

git add .
git commit -m "修改为本机ip" &> /dev/null
git push &> /dev/null

cp -a ./common/manifest.plist ../OTA
cd ../OTA
git add .
git commit -m "上传manifest文件" &> /dev/null
git push &> /dev/null
