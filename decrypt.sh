#!/bin/bash
openssl aes-256-cbc -d -in env-enc.sh -out env.sh -k $ENCRYPTION_KEY
openssl aes-256-cbc -d -in key-enc.pem -out key.pem -k $ENCRYPTION_KEY
openssl aes-256-cbc -d -in cert-enc.pem -out cert.pem -k $ENCRYPTION_KEY
openssl aes-256-cbc -d -in certs/rightmoveKey-enc.pem -out certs/rightmoveKey.pem -k $ENCRYPTION_KEY
openssl aes-256-cbc -d -in certs/rightmoveCert-enc.pem -out certs/rightmoveCert.pem -k $ENCRYPTION_KEY

