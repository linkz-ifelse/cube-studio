#!/bin/bash

echo "Start kube-explorer ..."

file_loc="./kube-explorer"
file_url="https://github.com/cnrancher/kube-explorer/releases/download/v0.5.1/kube-explorer-linux-amd64"

if [ ! -f "$file_loc" ]; then
    echo "Downloading ..."

    # 使用curl下载并重命名
    curl -L -o "$file_loc" "$file_url"

    chmod +x "$file_loc"
fi

"$file_loc" --http-listen-port=85 --https-listen-port=0
