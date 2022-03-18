#!/usr/bin/env bash

#  -p 2086:2086 \
mkdir -p ./data ./config

docker run \
  -it \
  --name gnunet \
  --rm \
  -v $(pwd)/data:/data \
  -v $(pwd)/config:/config \
  --network host \
  gnunet:0.16
