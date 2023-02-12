#!/bin/bash


MYIPV4=$(hostname -I | cut -d' ' -f1)
DOMAIN_NAME=$1


kubectl apply -f -  <<EOF
apiVersion: v1
kind: Service
metadata:
  name: httpd-internal
spec:
  ports:
  - name: app
    port: 8080
    protocol: TCP
    targetPort: 8080
  clusterIP: None
  type: ClusterIP
EOF

kubectl apply -f -  <<EOF
apiVersion: v1
kind: Endpoints
metadata:
  name: httpd-internal
subsets:
- addresses:
  - ip: ${MYIPV4}
  ports:
  - name: app
    port: 8080
    protocol: TCP
EOF

kubectl apply -f -  <<EOF
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: route-httpd-internal
  namespace: default
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/affinity: "cookie"
    nginx.ingress.kubernetes.io/session-cookie-name: "route-httpd"
    nginx.ingress.kubernetes.io/session-cookie-expires: "172800"
    nginx.ingress.kubernetes.io/session-cookie-max-age: "172800"
    nginx.ingress.kubernetes.io/proxy-connect-timeout: "300s"
    
spec:
  tls:
  - secretName: appflex
  rules:
  - host: ${DOMAIN_NAME}.appflex.io
    http:
      paths:
      - backend:
          serviceName: httpd-internal
          servicePort: 8080
EOF
