#!/usr/bin/env bash

oc export bc/eao-public-build -o json -n esm > eao-public-build-backup.json
oc patch --local=true -n esm -f eao-public-build-backup.json --type="json" -o json --patch='[   {     "op": "replace",     "path": "/spec/source",     "value": {       "type": "Dockerfile",       "dockerfile": "FROM eao-public-build-angular-app:latest\nCOPY * /tmp/app/dist/\nCMD  /usr/libexec/s2i/run",       "images": [         {           "from": {             "kind": "ImageStreamTag",             "name": "eao-public-build-angular-app:latest"           },           "paths": [             {               "sourcePath": "/opt/app-root/src/dist/.",               "destinationDir": "tmp"             }           ]         }       ]     }   },   {     "op": "replace",     "path": "/spec/strategy",     "value": {       "type": "Docker",       "dockerStrategy": {         "from": {           "kind": "ImageStreamTag",             "name": "nginx-runtime:latest"         }       }     }   } ]' > eao-public-build-patched.json