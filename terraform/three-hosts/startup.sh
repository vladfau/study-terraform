#!/bin/bash

mkdir -p /tmp/mydir
cd /tmp/mydir
mkdir directoryOne
export instanceName=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/instanceName" -H  "Metadata-Flavor: Google")

echo "${instanceName}" >> directoryOne/about
python -m SimpleHTTPServer 8484 2>&1 > access.log &
python -m SimpleHTTPServer 1337 2>&1 > access-service.log &
