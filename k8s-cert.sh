cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: mia
spec:
  request: $ENCODED
  signerName: kubernetes.io/kube-apiserver-client
  #expirationSeconds: 86400  # Only supported on >=1.22
  usages:
  - client auth
EOF
