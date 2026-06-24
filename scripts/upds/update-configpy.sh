#!/bin/bash

# update-configpy.sh
# 用于更新 kubeflow-dashboard 的 config.py ConfigMap (仅更新 config.py,其他文件保持不变)

set -e

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

NAMESPACE="infra"
DEPLOYMENT_NAME="kubeflow-dashboard"
SOURCE_DIR="${SCRIPT_DIR}/../../install/kubernetes/cube/overlays/config"
SOURCE_FILE="${SOURCE_DIR}/config.py"
CONFIGMAP_NAME="kubeflow-dashboard-config-9gc27ccd29"

echo "========================================="
echo "Update config.py in ConfigMap ${CONFIGMAP_NAME} ..."

if [ ! -f "${SOURCE_FILE}" ]; then
    echo "✗ Error: File [${SOURCE_FILE}] not found."
    exit 1
fi

if ! kubectl get configmap ${CONFIGMAP_NAME} -n ${NAMESPACE} &>/dev/null; then
    echo "✗ Error: ConfigMap [${CONFIGMAP_NAME}] not found in namespace [${NAMESPACE}]."
    echo "Please create the ConfigMap first with all required files."
    exit 1
fi

echo "Updating config.py in ConfigMap ${CONFIGMAP_NAME} ..."

kubectl create configmap ${CONFIGMAP_NAME} \
  --from-file=config.py=${SOURCE_FILE} \
  --namespace=${NAMESPACE} \
  --dry-run=client -o yaml | \
  kubectl patch configmap ${CONFIGMAP_NAME} -n ${NAMESPACE} --type merge --patch "$(cat -)"

echo "Rollout restart deployment to apply changes ..."

kubectl rollout restart deployment/${DEPLOYMENT_NAME} -n ${NAMESPACE}

echo "Waiting for rollout status (up to 300 seconds)..."

kubectl rollout status deployment/${DEPLOYMENT_NAME} -n ${NAMESPACE} --timeout=300s


if [ $? -eq 0 ]; then
    echo "✓ ConfigMap ${CONFIGMAP_NAME} config.py update done!"
else
    echo "✗ ConfigMap ${CONFIGMAP_NAME} config.py update failed or timed out!"
    exit 1
fi

echo "========================================="
