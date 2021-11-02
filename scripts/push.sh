#!/bin/bash

# 将改动推送到github仓库
function pushGithub() {
    echo "$1"

    cd ../

    # 由于github网络不稳定,暂时不推送到远端仓库!!!!!!!!!!!!!!!!!!
    return 0

    git add .
    git commit -m "修改为本机ip" &>/dev/null
    git push &>/dev/null
    return 0
}

# 将manifest.plist文件推送到coding仓库
function pushCoding() {
    echo "$1"

    cp -a ./common/manifest.plist ../OTA
    cd ../OTA

    git add .
    git commit -m "上传manifest文件" &>/dev/null
    git push &>/dev/null
    return 0
}
