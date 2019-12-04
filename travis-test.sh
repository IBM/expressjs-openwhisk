#!/bin/bash

##############################################################################
# Copyright 2017 IBM Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##############################################################################
set -e

OPEN_WHISK_BIN=/home/ubuntu/bin
LINK=https://${APIHOST}/cli/go/download/linux/amd64/wsk

echo "Downloading OpenWhisk CLI from '$LINK'...\n"
curl -O $LINK
chmod u+x wsk
export PATH=$PATH:`pwd`

printf "Generating express app\n"
express --view=pug myexpressapp
cd myexpressapp
npm install

printf "patch package.json\n"
json -I -f package.json -e 'this.main="action.js"'

printf "Patch views/layout.pug\n"
cat > views/layout.pug << EOM
doctype html
html
  head
    title= title
    if baseurl
      base(href=baseurl)
    link(rel='stylesheet', href='stylesheets/style.css')
  body
    block content
EOM

echo "Install expressjs-openwhisk\n"
npm install expressjs-openwhisk --save

cat > action.js << EOM

const app = require('./app');
const forward = require('expressjs-openwhisk')(app);

function main(request) {
  return forward(request);
}

exports.main = main;
EOM

printf "deploy\n"
zip -r app.zip .
../wsk action update express app.zip --kind nodejs:6 --web raw \
    -p baseurl https://${APIHOST}/api/v1/web/${ORG}_${SPACE}/default/express/ \
    --auth $OPEN_WHISK_KEY \
    --apihost {$APIHOST}

printf "curl\n"
echo https://${APIHOST}/api/v1/web/${ORG}_${SPACE}/default/express/
RESULT=$(curl https://${APIHOST}/api/v1/web/${ORG}_${SPACE}/default/express/)

printf "$RESULT"
if [ "$RESULT" == "<!DOCTYPE html><html><head><title>Express</title><link rel=\"stylesheet\" href=\"stylesheets/style.css\"></head><body><h1>Express</h1><p>Welcome to Express</p></body></html>" ]; then
  printf "all good"
else
  printf "not good"
  exit -1
fi
