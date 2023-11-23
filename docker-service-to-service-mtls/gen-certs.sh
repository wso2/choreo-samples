#!/bin/bash

CERTS_DIR=certs

CA_CONF=${CERTS_DIR}/ca.cnf
CA_KEY_OUT=${CERTS_DIR}/ca.key
CA_CERT_OUT=${CERTS_DIR}/ca.crt

SERVER_CSR_CONF=${CERTS_DIR}/server-csr.cnf
SERVER_KEY_OUT=${CERTS_DIR}/server.key
SERVER_CSR_OUT=${CERTS_DIR}/server.csr
SERVER_CERT_OUT=${CERTS_DIR}/server.crt

CLIENT_CSR_CONF=${CERTS_DIR}/client-csr.cnf
CLIENT_KEY_OUT=${CERTS_DIR}/client.key
CLIENT_CSR_OUT=${CERTS_DIR}/client.csr
CLIENT_CERT_OUT=${CERTS_DIR}/client.crt

# Generate CA key and certificate
openssl req -new -x509 -days 3650 -nodes -config ${CA_CONF} -keyout ${CA_KEY_OUT} -out ${CA_CERT_OUT}

# Generate server key and certificate signing request
openssl req -new -nodes -config ${SERVER_CSR_CONF} -keyout ${SERVER_KEY_OUT} -out ${SERVER_CSR_OUT}

# Sign the server certificate with generated CA
  openssl x509 -req -days 365 -in ${SERVER_CSR_OUT} -CA ${CA_CERT_OUT} -CAkey ${CA_KEY_OUT} -set_serial 01 -out ${SERVER_CERT_OUT} -extfile ${SERVER_CSR_CONF} -extensions req_ext

# Generate client key and certificate signing request
openssl req -new -nodes -config ${CLIENT_CSR_CONF} -keyout ${CLIENT_KEY_OUT} -out ${CLIENT_CSR_OUT}

# Sign the client certificate with generated CA
openssl x509 -req -days 365 -in ${CLIENT_CSR_OUT} -CA ${CA_CERT_OUT} -CAkey ${CA_KEY_OUT} -set_serial 02 -out ${CLIENT_CERT_OUT}
