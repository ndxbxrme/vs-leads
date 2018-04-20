#!/bin/bash
git pull
npm install
npm install -g grunt-cli
bower install
grunt build
#groupadd -r vsleads && useradd -m -r -g vsleads vsleads
su vsleads -c ". env.sh
pm2 start server/app.js"
