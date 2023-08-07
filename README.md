# Bitwarden External Secrets Operator Provider
We, mostly @cloudymax, followed the [example](https://external-secrets.io/v0.9.2/examples/bitwarden/) over at the ESO docs to create a simple helm chart to deploy the Bitwarden ESO provider without having to spend a bunch of time on it.This allos you to use the [`ExternalSecrets` Custom Resource](https://external-secrets.io/latest/introduction/overview/#externalsecret) with Bitwarden.

## Usage
For helm, see the [README](./charts/bitwarden-eso-provider/README.md) for full details of the allowed values in `values.yaml`, but this is the gist:

```bash
helm repo add bitwarden-eso-provider https://jessebot.github.io/bitwarden-eso-provider
helm install my-release bitwarden-eso-provider
```

# Example Secret
By default we will create two [`ClusterSecretStore`s](https://external-secrets.io/latest/introduction/overview/#clustersecretstore) for you that can then be accessed when you create a secret like [this](./examples/example-secret.yaml), but also printed below here:

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
      # The kuberntest secret name
        password: |-
          {{ .password }}
  data:
    # the value to pass to the keubernetes secret.
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
