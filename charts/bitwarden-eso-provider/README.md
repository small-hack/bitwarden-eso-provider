# bitwarden-eso-provider

![Version: 0.10.0](https://img.shields.io/badge/Version-0.10.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.9.0](https://img.shields.io/badge/AppVersion-0.9.0-informational?style=flat-square)

Helm chart to use Bitwarden as a Provider for External Secrets Operator

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cloudymax | <emax@cloudydev.net> | <https://github.com/cloudymax/> |
| jessebot | <jessebot@linux.com> | <https://github.com/jessebot/> |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` | enable pod autoscaling |
| autoscaling.maxReplicas | int | `100` | max number of pods to spin up |
| autoscaling.minReplicas | int | `1` | minimum number of pods to keep |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| bitwarden_eso_provider.auth.appID | string | `""` | optional bitwarden app ID to identify your pod to the Bitwarden server so that you don't receieve infinite email notifications every login |
| bitwarden_eso_provider.auth.clientID | string | `""` | bitwarden client ID to use to grabs secrets in the pod, ignored if existingSecret is set |
| bitwarden_eso_provider.auth.clientSecret | string | `""` | bitwarden client Secret to use to grabs secrets in the pod, ignored if existingSecret is set |
| bitwarden_eso_provider.auth.existingSecret | string | `""` | use an existing secret for bitwarden credentials, ignores above credentials if this is set |
| bitwarden_eso_provider.auth.host | string | `"https://bitwarden.com"` | bitwarden hostname to use to grab secrets in the pod, ignored if existingSecret is set |
| bitwarden_eso_provider.auth.password | string | `""` | password for bitwarden |
| bitwarden_eso_provider.auth.secretKeys.appID | string | `"BW_APPID"` | secret key for bitwarden app ID to use to identify the pod to bitwarden |
| bitwarden_eso_provider.auth.secretKeys.clientID | string | `"BW_CLIENTID"` | secret key for bitwarden client ID to use to grabs secrets in the pod |
| bitwarden_eso_provider.auth.secretKeys.clientSecret | string | `"BW_CLIENTSECRET"` | secret key for bitwarden client Secret to use to grabs secrets in the pod |
| bitwarden_eso_provider.auth.secretKeys.host | string | `"BW_HOST"` | secret key for bitwarden hostname to use to grab secrets in the pod |
| bitwarden_eso_provider.auth.secretKeys.password | string | `"BW_PASSWORD"` | secret key for bitwarden password key |
| bitwarden_eso_provider.create_cluster_secret_store | bool | `true` | if set to True, we'll create a cluster-wide accessible Cluster Secret Store see: https://external-secrets.io/latest/introduction/overview/#clustersecretstore |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` | Overrides the image pullPolicy. Hint: set to Always if using latest tag |
| image.repository | string | `"jessebot/bweso"` | Overrides the image repository |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` |  |
| livenessProbe | object | `{"failureThreshold":30,"initialDelaySeconds":20,"periodSeconds":10,"timeoutSeconds":1}` | The livenessProbe calls the `bw sync` command. |
| livenessProbe.periodSeconds | int | `10` | The `periodSeconds` value controls how long to wait until next `bw sync` |
| nameOverride | string | `""` | this overrides the name of the chart |
| network_policy.enabled | bool | `true` | enable a network policy between bitwarden_eso_provider and external-secrets-operator |
| network_policy.labels | object | `{"app.kubernetes.io/name":"external-secrets"}` | specify the labels you'd like to match against for the network policy |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` | additional annotations to apply to the bitwarden ESO provider pod |
| podSecurityContext | object | `{}` |  |
| readinessProbe.failureThreshold | int | `30` |  |
| readinessProbe.initialDelaySeconds | int | `20` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| readinessProbe.timeoutSeconds | int | `1` |  |
| replicaCount | int | `1` | replicas to deploy of this pod |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.port | int | `8087` | port to broadcast for k8s service internally on the cluster |
| service.targetPort | int | `8087` | port on the container to target for the k8s service |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| startupProbe.failureThreshold | int | `30` |  |
| startupProbe.initialDelaySeconds | int | `20` |  |
| startupProbe.periodSeconds | int | `10` |  |
| startupProbe.timeoutSeconds | int | `1` |  |
| tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
