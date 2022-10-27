# Testing connection to remote host
echo | openssl s_client -connect google.com:443 -showcerts

# Testing connection to remote host (with SNI support)
echo | openssl s_client -showcerts -servername google.com -connect google.com:443

# Testing connection to remote host with specific ssl version
openssl s_client -tls1_2 -connect google.com:443

# Testing connection to remote host with specific ssl cipher
openssl s_client -cipher 'AES128-SHA' -connect google.com:443

# Generate private key
# _ciph: des3, aes
(
  _ciph="des3"
  _fd="private.key"
  _len="2048"
  openssl genrsa -${_ciph} -out ${_fd} ${_len}
)

# Remove password from private key
(
  _fd="private.key"
  _fd_unp="private_unp.key"
  openssl rsa -in ${_fd} -out ${_fd_unp}
)

# Get public key from private key
(
  _fd="private.key"
  _fd_pub="public.key"
  openssl rsa -pubout -in ${_fd} -out ${_fd_pub}
)

# Generate private key + csr
(
  _fd="private.key"
  _fd_csr="request.csr"
  _len="2048"
  openssl req -out ${_fd_csr} -new -newkey rsa:${_len} -nodes -keyout ${_fd}
)

# Generate csr
(
  _fd="private.key"
  _fd_csr="request.csr"
  openssl req -out ${_fd_csr} -new -key ${_fd}
)

# Generate csr (metadata from exist certificate)
(
  _fd="private.key"
  _fd_csr="request.csr"
  _fd_crt="cert.crt"
  openssl x509 -x509toreq -in ${_fd_crt} -out ${_fd_csr} -signkey ${_fd}
)

# Generate csr with -config param
(
  _fd="private.key"
  _fd_csr="request.csr"
  openssl req -new -sha256 -key ${_fd} -out ${_fd_csr} \
    -config <(
      cat <<-EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C=<two-letter ISO abbreviation for your country>
ST=<state or province where your organization is legally located>
L=<city where your organization is legally located>
O=<legal name of your organization>
OU=<section of the organization>
CN=<fully qualified domain name>

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = <fully qualified domain name>
DNS.2 = <next domain>
DNS.3 = <next domain>
EOF
    )
)

# Convert DER to PEM
(
  _fd_der="cert.crt"
  _fd_pem="cert.pem"
  openssl x509 -in ${_fd_der} -inform der -outform pem -out ${_fd_pem}
)

# Convert PEM to DER
(
  _fd_der="cert.crt"
  _fd_pem="cert.pem"
  openssl x509 -in ${_fd_pem} -outform der -out ${_fd_der}
)

# Checking whether the private key and the certificate match
(
  openssl rsa -noout -modulus -in private.key | openssl md5
  openssl x509 -noout -modulus -in certificate.crt | openssl md5
) | uniq
