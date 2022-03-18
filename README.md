# Overview
This is a Nix derivation to build a Docker container to run the GNUnet project.

# Build
To build a Docker layer and load it as an image

```sh
docker load < $(nix-build ./gnunet-docker.build.nix)
```

# Run

```sh
mkdir -p ./data ./config

docker run \
  -it \
  --name gnunet \
  --rm \
  -v $(pwd)/data:/data \
  -v $(pwd)/config:/config \
  --network host \
  gnunet:0.16
```

or use `start.sh` script
