call openssl aes-256-cbc -e -in env.sh -out env-enc.sh -k %ENCRYPTION_KEY%
call openssl aes-256-cbc -e -in cert.pem -out cert-enc.pem -k %ENCRYPTION_KEY%
call openssl aes-256-cbc -e -in key.pem -out key-enc.pem -k %ENCRYPTION_KEY%
call openssl aes-256-cbc -e -in certs/vitalspacelive.p12 -out certs/vitalspacelive-enc.p12 -k %ENCRYPTION_KEY%