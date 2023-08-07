# Bitwarden External Secrets Operator Provider
We followed the [example](https://external-secrets.io/v0.9.2/examples/bitwarden/) over at the ESO docs to create a simple helm chart to deploy the Bitwarden ESO provider without having to spend a bunch of time on it. This project is neither affiliated with the External Secrets Operator, nor the official Bitwarden project. Report bugs here :)

### TLDR
For helm, see the [README](./charts/bitwarden-eso-provider/README.md) for full details of the allowed values in `values.yaml`, but this is the gist:

```bash
helm repo add bitwarden-eso-provider https://jessebot.github.io/bitwarden-eso-provider
helm install my-release bitwarden-eso-provider
```
