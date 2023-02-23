# SteamOS Development Environment Docker Image

Can be used to build software for SteamOS without having to disable the
read-only file system.

Instructions originally from <https://gitlab.com/popsulfr/steam-deck-tricks#use-podman-to-create-a-steamosarch-development-image>.

## Build

- With Docker:

  ```sh
  docker build . -t steamos-dev
  ```

- With Podman:

  ```sh
  podman build . -t steamos-dev --format docker
  ```
