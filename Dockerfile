FROM docker.io/bitnami/kubectl:1.31.3-debian-12-r1@sha256:3e89d1d1dbd10b1809bde3436bbe9f3708ad4c7d3ad4a9551cd8a16d88400365

USER 0
RUN install_packages -q curl git jq procps gettext

ARG TARGETOS
ARG TARGETARCH

# renovate: datasource=github-tags depName=helm lookupName=helm/helm
ENV HELM_VERSION="v3.16.3"
# renovate: datasource=github-tags depName=kustomize lookupName=kubernetes-sigs/kustomize extractVersion=^kustomize\/(?<version>v.+)$
ENV KUSTOMIZE_VERSION="v5.5.0"

RUN curl -sLfo- "https://get.helm.sh/helm-${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" | tar -xzO ${TARGETOS}-${TARGETARCH}/helm >/usr/local/bin/helm \
 && curl -sLfo- "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_${TARGETOS}_${TARGETARCH}.tar.gz" | tar -xzO kustomize >/usr/local/bin/kustomize \
 && chmod +x /usr/local/bin/helm /usr/local/bin/kustomize \
 && helm version >/dev/null && kustomize version >/dev/null

COPY --chmod=755 entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
