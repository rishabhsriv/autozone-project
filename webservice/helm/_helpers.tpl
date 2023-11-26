{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "webservice.name" -}}
{{- default (printf "%s-%s" .Chart.Name .Values.env) .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "webservice.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "webservice.chart" -}}
{{- printf "%s-%s-%s" .Chart.Name .Values.env .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "webservice.labels" -}}
app.kubernetes.io/name: {{ include "webservice.name" . }}
helm.sh/chart: {{ include "webservice.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create a fully qualified configmap name.
*/}}
{{- define "service.configmap.env.fullname" -}}
{{- printf "env-%s-%s" .Release.Name .Release.Namespace -}}
{{- end -}}

{{/*
Create a fully qualified configmap name.
*/}}
{{- define "service.configmap.config.fullname" -}}
{{- printf "config-%s-%s" .Release.Name .Release.Namespace -}}
{{- end -}}


{{/*
Service registry name.
*/}}
{{- define "service.registry.name" -}}
{{- printf "%s-%s-%s-%s" .Release.Name .Release.Namespace "docker" "registry" -}}
{{- end -}}

{{/*
Service registry secret.
*/}}
{{- define "service.registry.secret" -}}
{{- printf "{\"auths\": {\"%s\": {\"username\": \"%s\", \"password\": \"%s\", \"auth\": \"%s\"}}}" .Values.docker.registry .Values.docker.user .Values.docker.password (printf "%s:%s" .Values.docker.user .Values.docker.password | b64enc) | b64enc }}
{{- end -}}

{{/*
Service image name.
*/}}
{{- define "service.image.name" -}}
{{- printf "%s/%s:%s" .Values.docker.registry .Values.docker.image .Values.docker.tag -}}
{{- end -}}


{{/*
service dns
*/}}
{{- define "service.dns" -}}
{{ template "webservice.fullname" . }}.{{ .Release.Namespace }}.svc.cluster.local
{{- end -}}


{{/*
service istio gateway name
*/}}
{{- define "istio.service.gateway.name" -}}
istio-gateway-{{ .Release.Name }}
{{- end -}}

{{/*
service istio virtualservice name
*/}}
{{- define "istio.service.virtualService.name" -}}
istio-virtualservice-{{ .Release.Name }}
{{- end -}}