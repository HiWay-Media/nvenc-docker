# Handbrake in a Docker container with nvenc support
[![Dockerimage 1.3.x](https://github.com/HiWay-Media/handbrake-nvenc-docker-v2/actions/workflows/dockerimage-13x.yml/badge.svg)](https://github.com/HiWay-Media/handbrake-nvenc-docker-v2/actions/workflows/dockerimage-13x.yml)
[![Dockerimage 1.4.x](https://github.com/HiWay-Media/handbrake-nvenc-docker-v2/actions/workflows/dockerimage-14x.yml/badge.svg)](https://github.com/HiWay-Media/handbrake-nvenc-docker-v2/actions/workflows/dockerimage-14x.yml)
[![Dockerimage with Dockerfile](https://github.com/HiWay-Media/handbrake-nvenc-docker-v2/actions/workflows/dockerimage.yml/badge.svg)](https://github.com/HiWay-Media/handbrake-nvenc-docker-v2/actions/workflows/dockerimage.yml)


### Fork of jlesage/handbrake and zocker-160/handbrake-nvenc-docker, adds NVENC Hardware encoding

In order to make this image work, you need Docker >= 19.03 and the latest [NVIDIA driver](https://github.com/NVIDIA/nvidia-docker/wiki/Frequently-Asked-Questions#how-do-i-install-the-nvidia-driver) using the [official Nvidia installer](https://www.nvidia.com/en-us/drivers/unix/) and `nvidia-docker2` installed on your host system.

An official guide by Nvidia can be found [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#installing-on-ubuntu-and-debian).

---

**NOTE:** The Docker command provided in this quick start is given as an example and parameters should be adjusted to your need.

### Supported tags

| tag             | Handbrake version |
|:---------------:|:-----------------:|
| `16x`, `latest` | 1.6.1             |
| `15x`           | 1.5.1             |
| `14x`           | 1.4.2             |
| `13x`           | 1.3.x-git         |



#### Build
```
docker build  . --progress=plain  -t docker-registry.tngrm.io/handbrake:ffmpeg5

```


#### TEST ffmpeg
```
sh test.sh

```


Launch the HandBrake docker container with the following command:

```
docker run -d -t \
    --name=handbrake \
    -p 5800:5800 \
    -v <replace/the/path>:/config:rw \
    -v <replace/the/path>:/storage:ro \
    -v <replace/the/path>:/watch:rw \
    -v <replace/the/path>:/output:rw \
    --gpus all \
    zocker160/handbrake-nvenc:latest
```

#### Usage

- `--gpus all` this enables the passthrough to the GPU(s)
- `Port 5800`: for WebGUI
- `Port 5900`: for VNC client connection
- `/config`: This is where the application stores its configuration, log and any files needing persistency.
- `/storage`: This location contains files from your host that need to be accessible by the application.
- `/watch`: This is where videos to be automatically converted are located.
- `/output`: This is where automatically converted video files are written.

Browse to `http://your-host-ip:5800` to access the HandBrake GUI. 

Files from the host appear under the `/storage` folder in the container.

#### Optional parameters

- `-e AUTOMATED_CONVERSION_PRESET` (default: `"Very Fast 1080p30"`)
- `-e AUTOMATED_CONVERSION_FORMAT` (default: `"mp4"`)
- `-e APP_NAME` (default: `"Handbrake"`)

additional detailed info:
<https://hub.docker.com/r/jlesage/handbrake#docker-container-for-handbrake>
