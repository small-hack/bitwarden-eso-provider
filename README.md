# Bitwarden External Secrets Operator Provider Helm Chart
<a href="https://github.com/jessebot/bitwarden-eso-provider/releases"><img src="https://img.shields.io/github/v/release/jessebot/bitwarden-eso-provider?style=plastic&labelColor=blue&color=green&logo=GitHub&logoColor=white"></a>

Deploy a Bitwarden Provider for the [External Secrets Operator](https://external-secrets.io) so you can use [`ExternalSecrets`](https://external-secrets.io/latest/introduction/overview/#externalsecret) from Bitwarden to create Kubernetes Secrets 🎉 <sub>This project is neither affiliated with the External Secrets Operator, nor the official Bitwarden®️.</sub>

## Usage
For helm, see the [README](./charts/bitwarden-eso-provider/README.md) for full details of the allowed values in [`values.yaml`](./charts/bitwarden-eso-provider/values.yaml), but, provided you already installed the Externeral secrets operator, this is the gist:

```bash
helm repo add bitwarden-eso-provider https://jessebot.github.io/bitwarden-eso-provider
helm install my-release bitwarden-eso-provider/bitwarden-eso-provider \
  --set bitwarden_eso_provider.auth.password=my-secure-bitwarden-password \
  --set bitwarden_eso_provider.auth.clientID=my-bitwarden-clientID \
  --set bitwarden_eso_provider.auth.clientSecret=my-bitwarden-clientSecret
```

### Disable ClusterSecretStore Deployment

If you don't want to deploy any [`ClusterSecretStores`](https://external-secrets.io/latest/introduction/overview/#clustersecretstore), use the following arg to helm:
```bash
helm install my-release bitwarden-eso-provider/bitwarden-eso-provider \
  --set bitwarden_eso_provider.create_cluster_secret_store=false
```

or set it via the values:

```yaml
bitwarden_eso_provider:
  create_cluster_secret_store: false
```

### Use an existing Secret for Bitwarden credentials
You can pass in credentials plain text to this helm chart, and we'll create the values as a Kubernetes Secret, but it's recommended to instead provide an existing Secret so that the values are never plain text anywhere. You can do that by passing in the following in your `values.yaml`:

```yaml
bitwarden_eso_provider:
  auth:
    # -- use an existing Kubernetes Secret for bitwarden credentials
    existingSecret: "my-cool-secert"
    # -- Keys in the existing Kubernetes Secret to use for each sensitive value
    secretKeys:
      # -- secret key for Bitwarden password key
      password: "BW_PASSWORD"
      # -- secret key for Bitwarden client Secret to use to grabs secrets in the pod
      clientSecret: "BW_CLIENTSECRET"
      # -- secret key for Bitwarden client ID to use to grabs secrets in the pod
      clientID: "BW_CLIENTID"
      # -- secret key for Bitwarden hostname to use to grab secrets in the pod
      host: "BW_HOST"
```

Or setting it via the `helm` cli:

```
helm install my-release bitwarden-eso-provider/bitwarden-eso-provider --set bitwarden_eso_provider.auth.existingSecret="my-cool-secret"
```

# Example Secret
By default we will create two `ClusterSecretStores` for you that can then be accessed when you create a secret like [this](./examples/example-secret.yaml), but also printed below here:

```yaml
---
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  # this is the name of the ExternalSecret object
  name: cool-secret-4-dogs
  namespace: coolapp4dogs
spec:
  target:
    # This is the name of the secret in bitwarden
    name: cool-secret
    deletionPolicy: Delete
    template:
      type: Opaque
      data:
        # The kubernetes secret name
        password: |-
          {{ .password }}
  data:
    # the value to pass to the kubernetes secret.
    - secretKey: password
      sourceRef:
        storeRef:
          # Use the `bitwarden-login` store to get `username` and
          # `password` values from a bitwarden secret that does not
          # contain custom fields, Otherwise use `bitwarden-fields'
          name: bitwarden-login
          kind: ClusterSecretStore
      remoteRef:
        # This is the `name` of your bitwarden secret. 
        key: <your-secret-name>
        # This is the property of the bitwarden secret that we want
        property: <some-secret-property>
```

## Status
Actively maintained mostly by @jessebot and @cloudymax but we'd love to have your help if you'd like to make improvements. Feel free to submit a GitHub issue to _this_ repo (_not_ the BitWarden repos) if you need help. You're also welcome to submit PRs and we'd love to review them 💙

## Acknowledgements
We followed the [example](https://external-secrets.io/v0.9.2/examples/bitwarden/) over at the ESO docs to create this helm chart :)
