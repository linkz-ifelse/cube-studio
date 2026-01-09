#!/bin/bash

echo "Install cube-studio ... "

# kubectl label nodes yun01 control-plane=true kubeflow-dashboard=true kubeflow=true mysql=true monitoring=true redis=true --overwrite
kubectl label nodes yun01 \
  control-plane=true \
  kubeflow=true \
  kubeflow-dashboard=true \
  kubernetes-dashboard=true \
  mysql=true \
  monitoring=true \
  redis=true \
  --overwrite
kubectl label nodes yun01 kubernetes.io/arch=amd64

cd ~/cube/cube-studio/install/kubernetes/
cp /etc/rancher/k3s/k3s.yaml ./config

sh start.sh 172.16.104.52

# kubectl patch svc istio-ingressgateway -n istio-system -p '{"spec":{"externalIPs":["154.9.255.58"]}}'
