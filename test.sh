#!/bin/bash
# 将ip地址替换为本机地址

aa=$(ifconfig en0 | sed -e 's/ /\'$'\n/g' | grep -i 172.18.22)
bb=$(cat ~/Desktop/CustomWeb/index.html | sed -e 's/\//\'$'\n/g' | grep -i 172.18.22)
bb=$(cat ./index.html | sed -e 's/\//\'$'\n/g' | grep -i 172.18.22)
#echo "$aa"
#echo "$bb"
bb=$(echo "$bb" | sed -n '1p')
#echo "${bb}"
#cc=$(cat ~/Desktop/CustomWeb/index.html | sed -e 's/\//\'$'\n/g')
#cc=$(cat ~/Desktop/CustomWeb/index.html | sed -e 's/\//\n/g') # GNU版本写法,非Mac OS的BSD版本写法
#cc=$(more ~/Desktop/CustomWeb/index.html | tr '\/' '\n')
#echo "$cc"
./update.sh $bb $aa html
./update.sh $bb $aa plist 

git add .
git commit -m "修改为本机ip" &> /dev/null
git push &> /dev/null

#open http://$aa
echo -e "浏览器访问: \033[34mhttp://$aa\033[0m"

cp -a ./common/manifest.plist ../OTA
cd ../OTA
git add .
git commit -m "上传manifest文件" &> /dev/null
git push &> /dev/null
