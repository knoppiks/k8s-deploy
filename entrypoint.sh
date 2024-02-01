#!/bin/bash

set -e

if [[ -z "${KUBE_CLUSTER}" || -z "${KUBE_CA}" ]]; then
  echo "'KUBE_CLUSTER' or 'KUBE_CA' not set."
  exit 1
fi
kubectl config set-cluster cluster \
  --server="${KUBE_CLUSTER}" \
  --certificate-authority-data=${KUBE_CA} >/dev/null

TOKEN_ENV_VAR="KUBE_TOKEN_${CI_ENVIRONMENT_SLUG^^}"
if [[ -n "${KUBE_TOKEN}" ]]; then
  token="${KUBE_TOKEN}"
elif [[ -n "${!TOKEN_ENV_VAR}" ]]; then
  token="${!TOKEN_ENV_VAR}"
else
  echo "'KUBE_TOKEN'/${TOKEN_ENV_VAR} not set: Cannot authenticate with the cluster."
  exit 1
fi
kubectl config set-credentials user --token="${token}" >/dev/null

if [[ -z "${KUBE_NAMESPACE}" ]]; then
  echo "'KUBE_NAMESPACE' not set."
  exit 1
fi
kubectl config set-context context --cluster=cluster --user=user --namespace="${KUBE_NAMESPACE}" >/dev/null
kubectl config use-context context >/dev/null

exec "$@"
