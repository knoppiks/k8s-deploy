FROM alpine:3.22.2@sha256:4b7ce07002c69e8f3d704a9c5d6fd3053be500b7f1c69fc0d80990c2ad8dd412

RUN apk add --no-cache -q ca-certificates curl git jq yq procps gettext make bash

ARG TARGETOS
ARG TARGETARCH

# renovate: datasource=github-tags depName=helm lookupName=helm/helm
ENV HELM_VERSION="v3.19.1"
RUN curl -sLfo- "https://get.helm.sh/helm-${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" | tar -xzO ${TARGETOS}-${TARGETARCH}/helm >/usr/local/bin/helm \
 && chmod +x /usr/local/bin/helm \
 && helm version

# renovate: datasource=github-tags depName=kustomize lookupName=kubernetes-sigs/kustomize extractVersion=^kustomize\/(?<version>v.+)$
ENV KUSTOMIZE_VERSION="v5.8.0"
RUN curl -sLfo- "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" | tar -xzO kustomize >/usr/local/bin/kustomize \
 && chmod +x /usr/local/bin/kustomize \
 && kustomize version

ARG KUBECTL_VERSION
RUN curl -sLf https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && kubectl version --client

COPY --chmod=755 entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
