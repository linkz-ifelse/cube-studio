#!/bin/bash

echo "Install k3s ..."

file_loc="./k3s.sh"
file_url="https://get.k3s.io"

if [ ! -f "$file_loc" ]; then
    echo "Downloading ..."

    # 使用curl下载并重命名
    curl -L -o "$file_loc" "$file_url"

    chmod +x "$file_loc"
fi


# 设置集群名称（将自动加上 k3s- 前缀）
export INSTALL_K3S_NAME=cube

# 设置k8s部署配置
export INSTALL_K3S_EXEC="--disable=traefik"
#export INSTALL_K3S_EXEC="--system-default-registry registry.cn-hangzhou.aliyuncs.com --write-kubeconfig ~/.kube/config --disable=traefik --cluster-cidr  10.72.0.0/16 --service-cidr  10.73.0.0/16"

# 设置强制下载
export INSTALL_K3S_SYMLINK=force
#export INSTALL_K3S_FORCE_RESTART=true


# 执行安装脚本
sh "$file_loc" --docker

mkdir -p ~/.kube/
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config

# 打印master的token
echo "Master node token:"
cat /var/lib/rancher/k3s/server/node-token

echo "Install k3s done."
