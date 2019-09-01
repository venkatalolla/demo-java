#!/bin/sh
DEPLOYMENT_APP=$1
if "$DEPLOYMENT_APP"; then
  deployment_name="${DEPLOYMENT_NAME}"
  kube_namespace="${KUBE_NAMESPACE}"
  app_name="${APP_NAME}"
  app_replicas="${APP_REPLICAS}"
  repository_name="${REPOSITORY_NAME}"
  image_name="${IMAGE_NAME}"
  tag_name="${CI_COMMIT_SHORT_SHA}"

cat << EOF > deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $deployment_name
  namespace: $kube_namespace
  labels:
    app: $app_name
    tier: web
spec:
  replicas: $app_replicas
  selector:
    matchLabels:
      app: $app_name
      tier: web
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: $app_name
        tier: web
    spec:
      containers:
      - image: $repository_name/$image_name:$tag_name
        imagePullPolicy: Always
        name: $app_name
        ports:
        - name: web
          containerPort: 8080
        livenessProbe:
          httpGet:
            path: /
            port: 8080
          initialDelaySeconds: 15
          timeoutSeconds: 15
        readinessProbe:
          httpGet:
            path: /
            port: 8080
          initialDelaySeconds: 5
          timeoutSeconds: 3
EOF
fi
