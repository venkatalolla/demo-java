#!/bin/sh
DEPLOYMENT_APP=$1
if "$DEPLOYMENT_APP"; then
  service_name="${SERVICE_NAME}"
  kube_namespace="${KUBE_NAMESPACE}"
  app_name="${APP_NAME}"

cat << EOF > service.yaml
apiVersion: v1
kind: Service
metadata:
  name: $service_name
  namespace: $kube_namespace
  labels:
    app: $app_name
    tier: web
spec:
  type: LoadBalancer
  ports:
    - name: web
      port: 8080
      targetPort: web
  selector:
    app: $app_name
    tier: web
EOF
fi