#!/bin/bash

# update-deployment.sh
# 用于更新 kubeflow-dashboard 部署

set -e

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

NAMESPACE="infra"
DEPLOYMENT_NAME="kubeflow-dashboard"
YAML_PATH="${SCRIPT_DIR}/../../install/kubernetes/cube/base/deploy-backend.yaml"

echo "========================================="
echo "Update deployment: ${DEPLOYMENT_NAME} ..."

if [ ! -f "${YAML_PATH}" ]; then
    echo "✗ Error: File [${YAML_PATH}] not found."
    exit 1
fi

echo "Applying Deployment ${YAML_PATH} ..."

kubectl apply -f ${YAML_PATH} -n ${NAMESPACE}

echo "Rollout restart deployment ..."

kubectl rollout restart deployment/${DEPLOYMENT_NAME} -n ${NAMESPACE}

echo "Waiting for rollout status (up to 300 seconds)..."

kubectl rollout status deployment/${DEPLOYMENT_NAME} -n ${NAMESPACE} --timeout=300s

if [ $? -eq 0 ]; then
    echo "✓ Deployment ${DEPLOYMENT_NAME} update done!"
else
    echo "✗ Deployment ${DEPLOYMENT_NAME} update failed or timed out!"
    exit 1
fi

echo "========================================="
