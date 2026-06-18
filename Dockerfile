FROM alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b

RUN apk add --no-cache -q ca-certificates curl git jq yq procps gettext make bash

ARG TARGETOS
ARG TARGETARCH

# renovate: datasource=github-tags depName=helm lookupName=helm/helm
ENV HELM_VERSION="v4.2.2"
RUN curl -sLfo- "https://get.helm.sh/helm-${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" | tar -xzO ${TARGETOS}-${TARGETARCH}/helm >/usr/local/bin/helm \
 && chmod +x /usr/local/bin/helm \
 && helm version

# renovate: datasource=github-tags depName=kustomize lookupName=kubernetes-sigs/kustomize extractVersion=^kustomize\/(?<version>v.+)$
ENV KUSTOMIZE_VERSION="v5.8.1"
RUN curl -sLfo- "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" | tar -xzO kustomize >/usr/local/bin/kustomize \
 && chmod +x /usr/local/bin/kustomize \
 && kustomize version

ARG KUBECTL_VERSION
RUN curl -sLf https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && kubectl version --client

COPY --chmod=755 entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
