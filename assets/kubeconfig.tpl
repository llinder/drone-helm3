apiVersion: v1
clusters:
- cluster:
{{- if eq .SkipTLSVerify true }}
    insecure-skip-tls-verify: true
{{- else if .Certificate }}
    certificate-authority-data: {{ .Certificate }}
{{- end}}
    server: {{ .APIServer }}
  name: helm
contexts:
- context:
    cluster: helm
{{- if .Namespace }}
    namespace: {{ .Namespace }}
{{- end }}
    user: {{ .ServiceAccount }}
  name: helm
current-context: "helm"
kind: Config
preferences: {}
users:
- name: {{ .ServiceAccount }}
  user:
{{- if .Token }}
    token: {{ .Token }}
{{ else if .EKSCluster }}
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "{{ .EKSCluster }}"
    {{- if .EKSRoleArn }}
        - "-r"
        - "{{ .EKSRoleArn }}"
    {{ end }}
{{ end }}
