
# Create Certificate Authority

openssl req -x509 \
            -sha256 -days 356 \
            -nodes \
            -newkey rsa:2048 \
            -subj "/CN=34.125.71.247/C=US/L=San Fransisco" \
            -keyout rootCA.key -out rootCA.crt 


# Create a Self-signed Certificate
################

# Create Server Private Key
openssl genrsa -out server.key 2048

# Create Certificate Signing  Request (CSR) Configuration
######

cat > csr.conf <<EOF
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = US
ST = California
L = San Fransisco
O = MLopsHub
OU = MlopsHub Dev
CN = 34.125.71.247

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = 34.125.71.247
DNS.2 = www.demo.mlopshub.com
IP.1 = 34.125.71.247
IP.2 = 34.125.29.177

EOF


# Create CSR with the above Config file
openssl req -new -key server.key -out server.csr -config csr.conf


# Create a Certificate Config file
#########

cat > cert.conf <<EOF

authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = 34.125.71.247
EOF


# Generate SSL Certificate with the self-signed CA
#######

openssl x509 -req \
    -in server.csr \
    -CA rootCA.crt -CAkey rootCA.key \
    -CAcreateserial -out server.crt \
    -days 365 \
    -sha256 -extfile cert.conf





#Convert SSL keys to PKCS12 format
######


openssl pkcs12 -export -out jenkins.p12 \
-passout 'pass:password' -inkey server.key \
-in server.crt -certfile rootCA.crt -name 34.125.71.247



#install keytool in container-optimized os (This is the OS found on GKE cluster nodes)
##########

toolbox apt-get install -y keytool



#Convert PKCS12 to JKS format
#######


keytool -importkeystore -srckeystore jenkins.p12 \
-srcstorepass 'password' -srcstoretype PKCS12 \
-srcalias 34.125.71.247 -deststoretype JKS \
-destkeystore jenkins.jks -deststorepass 'password' \
-destalias 34.125.71.247

