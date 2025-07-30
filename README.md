# ATX PSU Parametric Case

# Build

## Docker

```shell
docker run \
    -it \
    --rm \
    -v $(pwd):/openscad \
    -u $(id -u ${USER}):$(id -g ${USER}) \
    openscad/openscad:latest \
    /bin/bash
```