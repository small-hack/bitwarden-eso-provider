# Bitwarden External Secrets Operator Provider
We, mostly @cloudymax, followed the [example](https://external-secrets.io/v0.9.2/examples/bitwarden/) over at the ESO docs to create a simple helm chart to deploy the Bitwarden ESO provider without having to spend a bunch of time on it.This allos you to use the [`ExternalSecrets` Custom Resource](https://external-secrets.io/latest/introduction/overview/#externalsecret) with Bitwarden.

## Usage
For helm, see the [README](./charts/bitwarden-eso-provider/README.md) for full details of the allowed values in `values.yaml`, but this is the gist:

```bash
helm repo add bitwarden-eso-provider https://jessebot.github.io/bitwarden-eso-provider
helm install my-release bitwarden-eso-provider
```

# Example Secret
By default we will create two [`ClusterSecretStore`s](https://external-secrets.io/latest/introduction/overview/#clustersecretstore) for you that can then be accessed when you create a secret like this:

```yaml
# The `key` is actually the `name` of your secret in bitwarden
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: example-secret
  namespace: default
spec:
  target:
    name: example-secret
    deletionPolicy: Delete
    template:
      type: Opaque
      data:
        # this key will be in the rendered Kubetenes Secret manifest
        username: |-
          {{ .username }}
        password: |-
          {{ .password }}
  data:
    - secretKey: username
      sourceRef:
        storeRef:
          name: bitwarden-login
          kind: ClusterSecretStore
      remoteRef:
        # `key` is actually the `name` of your item in bitwarden
        key: my-bitwarden-secret-name
        # this is the field in the bitwarden item
        property: username
    - secretKey: password
      sourceRef:
        storeRef:
          name: bitwarden-login
          kind: ClusterSecretStore
      remoteRef:
        key: my-bitwarden-secret-name
        property: password
```
