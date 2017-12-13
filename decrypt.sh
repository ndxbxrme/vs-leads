#!/bin/bash
openssl aes-256-cbc -d -in env-enc.sh -out env.sh -k $VSLEADS_KEY
openssl aes-256-cbc -d -in key-enc.pem -out key.pem -k $VSLEADS_KEY
openssl aes-256-cbc -d -in cert-enc.pem -out cert.pem -k $VSLEADS_KEY
openssl aes-256-cbc -d -in certs/vitalspacelive-enc.p12 -out certs/vitalspacelive.p12 -k $VSLEADS_KEY

