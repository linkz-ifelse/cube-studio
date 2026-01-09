#!/bin/sh

# 设置 containerd 的 mirror
mkdir -p /etc/rancher/k3s/
cat > /etc/rancher/k3s/registries.yaml <<EOF
mirrors:
  docker.io:
    endpoint:
      - "https://mirror.iscas.ac.cn"
EOF

# 设置使用国内源
export INSTALL_K3S_MIRROR=cn

# 设置集群名称（将自动加上 k3s- 前缀）
export INSTALL_K3S_NAME=cube

# 设置k8s部署配置
export INSTALL_K3S_EXEC="--system-default-registry swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io --disable=traefik"
#export INSTALL_K3S_EXEC="--system-default-registry registry.cn-hangzhou.aliyuncs.com --write-kubeconfig ~/.kube/config --disable=traefik --cluster-cidr  10.72.0.0/16 --service-cidr  10.73.0.0/16"

# 设置强制下载
export INSTALL_K3S_SYMLINK=force
#export INSTALL_K3S_FORCE_RESTART=true

# 替换github和storage 国内可以链接到的网络
export GITHUB_URL=https://githubfast.com/k3s-io/k3s/releases
#export STORAGE_URL=https://k3s-ci-builds.s3.amazonaws.com

# 执行安装脚本
sh k3s-install.sh --docker

mkdir -p ~/.kube/
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config

# 打印master的token
cat /var/lib/rancher/k3s/server/node-token

