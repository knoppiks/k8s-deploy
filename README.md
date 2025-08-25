# k8s-deploy

A lightweight Docker container for Kubernetes deployments with kubectl, Helm, and Kustomize.

## Features

- **kubectl**  - Kubernetes command-line tool
- **Helm** - Kubernetes package manager
- **Kustomize** - Kubernetes native configuration management
- Automatic cluster authentication setup
- Environment-based token selection

## Usage

### Environment Variables

- `KUBE_CLUSTER` - Kubernetes cluster server URL
- `KUBE_CA` - Base64-encoded cluster CA certificate
- `KUBE_NAMESPACE` - Target namespace
- `KUBE_TOKEN` - Authentication token (or `KUBE_TOKEN_<ENVIRONMENT>`)

### Example

```bash
docker run --rm \
  -e KUBE_CLUSTER="https://k8s.example.com" \
  -e KUBE_CA="LS0tLS..." \
  -e KUBE_NAMESPACE="default" \
  -e KUBE_TOKEN="eyJhbG..." \
  knoppiks/k8s-deploy kubectl get pods
```

## License

See [LICENSE](LICENSE) file.
