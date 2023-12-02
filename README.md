# Bitwarden External Secrets Operator Provider Helm Chart
<a href="https://github.com/small-hack/bitwarden-eso-provider/releases"><img src="https://img.shields.io/github/v/release/small-hack/bitwarden-eso-provider?style=plastic&labelColor=blue&color=036440&logo=GitHub&logoColor=white"></a>

Deploy a Bitwarden Provider for the [External Secrets Operator](https://external-secrets.io) so you can use [`ExternalSecrets`](https://external-secrets.io/latest/introduction/overview/#externalsecret) from Bitwarden to create Kubernetes Secrets 🎉 <sub>This project is neither directly affiliated with the External Secrets Operator, nor the official Bitwarden®️ at this time.</sub>

## Usage
For helm, see the [README](./charts/bitwarden-eso-provider/README.md) for full details of the allowed values in [`values.yaml`](./charts/bitwarden-eso-provider/values.yaml), but, provided you already installed the Externeral secrets operator, this is all you need to test:

```bash
# add the helm repo locally
helm repo add bitwarden-eso-provider https://small-hack.github.io/bitwarden-eso-provider

# install the bitwarden provider with credentials via the CLI
helm install my-release bitwarden-eso-provider/bitwarden-eso-provider \
  --set bitwarden_eso_provider.auth.password=my-secure-bitwarden-password \
  --set bitwarden_eso_provider.auth.clientID=my-bitwarden-clientID \
  --set bitwarden_eso_provider.auth.clientSecret=my-bitwarden-clientSecret
```

> [!Note]
> [kind](https://kind.sigs.k8s.io/) cant pull the container for some reason so we are using a pre-pull and side-load workaround in our CI steps. Ref: [thread](https://stackoverflow.com/questions/63657414/kind-kubernetes-cluster-failed-to-pull-docker-images).

## Why does this exist?

We really didnt want to make this, but after lots of searching and experimentation we have found that Bitwarden stands out from its competitors for the following reasons:

1. A Generous free tier
2. Open-Source with a permissive license
3. Self-Hostable via VaultWarden
4. Compatible with the External Secrets Operator
5. Also a password manager with native desktop and mobile apps on Windows, Mac, Linux, Andorid, and IOS

![secrets-suck drawio](https://github.com/small-hack/bitwarden-eso-provider/assets/84841307/88c7f483-ca08-48ec-80bc-8892f46b1c80)


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

# Example ExternalSecret
By default we will create two `ClusterSecretStores` for you that can then be accessed when you create a secret like [this](./examples/example-secret.yaml), but also printed below here:

```yaml
---
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  # name of the ExternalSecret itself
  name: beatiful-external-secret
  namespace: coolapp4dogs
spec:
  target:
    # name of the secret to create in Kubernetes
    name: beautiful-k8s-secret
    deletionPolicy: Delete
    template:
      type: Opaque
      data:
        # key in the Kubernetes secret to create
        password: |-
          {{ .password }}
  data:
    # value to pass to the Kubernetes secret, go-templated as {{ .password }} above
    - secretKey: password
      sourceRef:
        storeRef:
          # Use the bitwarden-login store to get password values from a Bitwarden item
          # does *not* contain custom fields. Use bitwarden-fields for Bitwarden items with custom fields
          name: bitwarden-login
          kind: ClusterSecretStore
      remoteRef:
        # This is the `name` of your Bitwarden item (not the id)
        key: my-beautiful-login-item-in-bitwarden
        # This is the property of the Bitwarden item that we want e.g. password
        property: password
```

## Testing 

Searching for items has to be done using JSONpath, you will need to install a utility for that, we use [bashtools/JSONPath.sh](https://github.com/bashtools/JSONPath.sh).

To query the endpoint you will need to deploy a maintenance container into the `external-secrets` namespace.

```yaml
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: maintenance
  namespace: external-secrets
  annotations:
    # set to "true" to include in future backups
    k8up.io/backup: "false"
  # Optional:
  #labels:
  #  app: multi-file-writer
spec:
  # Optional:
  storageClassName: local-path
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      # Must be sufficient to hold your data
      storage: 16Gi
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: maintenance
  namespace: external-secrets
  annotations:
    # set to "true" to include in future backups
    k8up.io/backup: "false"
  # Optional:
  #labels:
  #  app: multi-file-writer
spec:
  # Optional:
  storageClassName: local-path
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      # Must be sufficient to hold your data
      storage: 16Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: maintenance
  namespace: external-secrets
spec:
  selector:
    matchLabels:
      app: onboardme
  template:
    metadata:
      labels:
        app: onboardme
    spec:
      restartPolicy: Always
      containers:
        - name: onboardme
          image: jessebot/onboardme:debian12
          command:
            - /bin/sleep
            - 3650d
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: 80
              name: "http"
            - containerPort: 443
              name: "https"
            - containerPort: 22
              name: "ssh"
            - containerPort: 5900
              name: "vnc"
          volumeMounts:
          - mountPath: /tmp
            name: maintenance
      volumes:
      - name: maintenance
        persistentVolumeClaim:
          claimName: maintenance
```

- Use `kubectl exec -n external-secrets -it <pod name> -- bash` to attach to the container.

- Download JSONPath.sh

  ```bash
  sudo apt-get update && sudo apt-get install -y gawk
  curl -O https://raw.githubusercontent.com/mclarkson/JSONPath.sh/master/JSONPath.sh
  chmod +x JSONPath.sh
  ```

- Query the endpoint

  ```bash
  curl bitwarden-eso-provider.external-secrets.svc.cluster.local:8087/list/object/items
  ```

- Test a JSONPath filter

  ```bash
  curl bitwarden-eso-provider.external-secrets.svc.cluster.local:8087/list/object/items?search=zitadel \
  | JSONPath.sh '$.data'

  ```

## Status
Actively maintained mostly by @jessebot and @cloudymax, but we'd love to have your help if you'd like to make improvements (bugs or feature fixes). We mostly test on k3s. Feel free to submit a GitHub issue to _this_ repo (_not_ the Bitwarden repos) if you need help. You're also welcome to submit PRs to this repo, and we'd love to review them 💙 Star the repo if you find it helpful <3

## Acknowledgements
We followed the [example](https://external-secrets.io/v0.9.2/examples/bitwarden/) over at the ESO docs to create this helm chart :)

## Contributors

<!-- readme: contributors -start -->
<table>
<tr>
    <td align="center">
        <a href="https://github.com/jessebot">
            <img src="https://avatars.githubusercontent.com/u/2389292?v=4" width="100;" alt="jessebot"/>
            <br />
            <sub><b>Jessebot</b></sub>
        </a>
    </td>
    <td align="center">
        <a href="https://github.com/cloudymax">
            <img src="https://avatars.githubusercontent.com/u/84841307?v=4" width="100;" alt="cloudymax"/>
            <br />
            <sub><b>Max!</b></sub>
        </a>
    </td>
    <td align="center">
        <a href="https://github.com/jokajak">
            <img src="https://avatars.githubusercontent.com/u/460913?v=4" width="100;" alt="jokajak"/>
            <br />
            <sub><b>Jokajak</b></sub>
        </a>
    </td></tr>
</table>
<!-- readme: contributors -end -->
