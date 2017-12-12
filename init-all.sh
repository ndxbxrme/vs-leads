#!/bin/bash
git pull
npm install
npm install -g grunt-cli
bower install
grunt build
#groupadd -r vsleads && useradd -m -r -g vsleads vsleads
su vsleads -c ". env.sh
screen -X -S VSLEADS quit || true
screen -S VSLEADS node --expose-gc server/app.js"
