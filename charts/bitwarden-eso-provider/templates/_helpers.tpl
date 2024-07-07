{{/*
Expand the name of the chart.
*/}}
{{- define "bitwarden-eso-provider.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bitwarden-eso-provider.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "bitwarden-eso-provider.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "bitwarden-eso-provider.labels" -}}
helm.sh/chart: {{ include "bitwarden-eso-provider.chart" . }}
{{ include "bitwarden-eso-provider.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "bitwarden-eso-provider.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bitwarden-eso-provider.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "bitwarden-eso-provider.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "bitwarden-eso-provider.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the url string that will be used to query Bitwarden:
- cluster-secret-store logins url
*/}}
{{- define "bitwarden-eso-provider.clusterSecretStore.loginUrl" -}}
{{- printf "http://%s.%s.svc.cluster.local.:%s/list/object/items?search={{ .remoteRef.key }}" .Release.Name .Release.Namespace (.Values.service.port | toString) | quote }}
{{- end }}


{{/*
Create the url string that will be used to query bitwarden
- cluster-secret-store logins jsonpath
*/}}
{{- define "bitwarden-eso-provider.clusterSecretStore.loginJsonPath" -}}
{{- printf "$.data.data[0].login.{{ .remoteRef.property }}" | quote }}
{{- end }}


{{/*
Create the url string that will be used to query Bitwarden:
- cluster-secret-store fields url
*/}}
{{- define "bitwarden-eso-provider.clusterSecretStore.fieldsUrl" -}}
{{- printf "http://%s.%s.svc.cluster.local:%s/list/object/items?search={{ .remoteRef.key }}" .Release.Name .Release.Namespace (.Values.service.port | toString) | quote }}
{{- end }}


{{/*
Create the url string that will be used to query bitwarden
- cluster-secret-store fields jsonpath
*/}}
{{- define "bitwarden-eso-provider.clusterSecretStore.fieldsJsonPath" -}}
{{- printf "$.data.data[0].fields[?(@.name==\"{{ .remoteRef.property }}\")].value" | quote }}
{{- end }}

{{/*
Create the url string that will be used to query Bitwarden:
- cluster-secret-store notes url
*/}}
{{- define "bitwarden-eso-provider.clusterSecretStore.notesUrl" -}}
{{- printf "http://%s.%s.svc.cluster.local:%s/list/object/items?search={{ .remoteRef.key }}" .Release.Name .Release.Namespace (.Values.service.port | toString) | quote }}
{{- end }}

{{/*
Create the url string that will be used to query bitwarden
- cluster-secret-store notes jsonpath
*/}}
{{- define "bitwarden-eso-provider.clusterSecretStore.notesJsonPath" -}}
{{- printf "$.data.data[0].notes" | quote }}
{{- end }}
