# FFmpeg Docker container with nvenc support
[![Docker FFmpeg Nvenc 5.1.2](https://github.com/HiWay-Media/nvenc-docker/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/HiWay-Media/nvenc-docker/actions/workflows/docker-publish.yml)
[![Docker FFmpeg6.0](https://github.com/HiWay-Media/nvenc-docker/actions/workflows/docker-publish-ffmpeg6.yml/badge.svg)](https://github.com/HiWay-Media/nvenc-docker/actions/workflows/docker-publish-ffmpeg6.yml)
[![Docker FFmpeg6.0 Nvenc 11](https://github.com/HiWay-Media/nvenc-docker/actions/workflows/docker-publish-ffmpeg6-nvenc11.yml/badge.svg)](https://github.com/HiWay-Media/nvenc-docker/actions/workflows/docker-publish-ffmpeg6-nvenc11.yml)

nvenc-docker is a repository that provides a Docker image for video encoding utilizing NVIDIA's NVENC (NVIDIA Video Encoder) capabilities. It enables hardware-accelerated video encoding using NVIDIA GPUs, resulting in faster video processing.

## Features
- Automatic setup of Docker environment with NVIDIA GPU support.
- Integration with GitHub Actions for easy CI/CD workflows.
- Efficient video encoding using NVENC for faster processing.
- Flexibility to customize the encoding parameters and workflow as needed.
- Seamless integration with other GitHub Actions and workflows.

## Prerequisites
To use this repository, you need to have the following:

- A machine with an NVIDIA GPU that supports NVENC.
- Docker installed on the machine.
- A GitHub repository with GitHub Actions enabled.
- NVIDIA Docker runtime installed (for GPU support).

## Usage
To utilize nvenc-docker, follow these steps:

1. Pull the nvenc-docker image from Docker Hub:

```shell
docker pull hiwaymedia/nvenc-docker:latest
```

2. Run the Docker container with your desired encoding parameters. For example:

```shell
docker run --gpus all \
  --volume /path/to/input:/data/input \
  --volume /path/to/output:/data/output \
  hiwaymedia/nvenc-docker:latest \
  ffmpeg -i /data/input/video.mp4 -c:v h264_nvenc -preset fast /data/output/output.mp4
```

Customize the input and output paths and the encoding command as per your requirements. This example uses ffmpeg with the h264_nvenc codec to encode a video file.

3. Monitor the encoding process and retrieve the encoded video from the output directory.

For more detailed usage examples and additional information, please refer to the documentation.

## Contributing
Contributions to nvenc-docker are welcome! If you have any suggestions, improvements, or bug fixes, feel free to open an issue or submit a pull request.

## License
This project is licensed under the MIT License.