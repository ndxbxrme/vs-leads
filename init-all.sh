#!/bin/bash
git pull
npm install
npm install -g grunt-cli
bower install
grunt build
#groupadd -r vsleads && useradd -m -r -g vsleads vsleads
su vsleads -c "openssl aes-256-cbc -d -in env-enc.sh -out env.sh -k $ENCRYPTION_KEY
openssl aes-256-cbc -d -in key-enc.pem -out key.pem -k $ENCRYPTION_KEY
openssl aes-256-cbc -d -in cert-enc.pem -out cert.pem -k $ENCRYPTION_KEY
openssl aes-256-cbc -d -in certs/rightmoveKey-enc.pem -out certs/rightmoveKey.pem -k $ENCRYPTION_KEY
openssl aes-256-cbc -d -in certs/rightmoveCert-enc.pem -out certs/rightmoveCert.pem -k $ENCRYPTION_KEY
. env.sh
screen -X -S VSLEADS quit || true
screen -S VSLEADS node --expose-gc server/app.js"
