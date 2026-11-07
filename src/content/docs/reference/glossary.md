---
title: Glossary
description: Plain-language definitions for terms used in this guide.
sidebar:
  order: 3
---

**Bridge (`vmbr0`):** Proxmox's virtual network switch. Containers and virtual machines connect to it to reach your home network; `vmbr0` is Proxmox's default bridge.

**Clone:** An independent copy of a container. A full clone copies all of its storage.

**Compose:** A YAML file and Docker command for defining and running a group of containers as one stack.

**Container:** An isolated application or Linux environment that shares its host's kernel. This guide uses both an LXC system container and Docker application containers.

**DHCP:** The router service that automatically assigns network addresses.

**DHCP reservation:** A router setting that keeps the same address assigned to a particular device.

**Docker:** The engine that downloads images and runs application containers.

**Image:** A packaged, read-only application used to create a Docker container.

**LXC:** The Linux container technology Proxmox uses for lightweight system containers.

**Nesting:** The Proxmox LXC feature that permits container technology such as Docker to run inside an LXC.

**Port mapping (host:container):** A Docker setting that publishes a container's port on its host, written like `8080:80`. You reach the app at the host's address and the first port.

**Proxmox VE:** The server operating system and web interface that manages virtual machines, LXC containers, storage, snapshots, and networking.

**Snapshot:** A saved point in a container's filesystem and configuration that you can roll back to. Later changes are discarded during rollback.

**SSH:** An encrypted connection used by VS Code and its terminal to work on another computer.

**Stack:** One or more services managed together from a Compose file.

**Tailscale:** A service that joins your devices into a private network, called a tailnet, that works from anywhere without opening router ports.

**Template:** A prepared Linux filesystem Proxmox uses to create an LXC.

**TSDProxy:** A Docker app that gives each labeled container its own HTTPS address on your tailnet.

**Unprivileged container:** An LXC that runs as an ordinary user on the host. Root inside the container is not root on the host, so a mistake inside stays inside.

**VM:** A virtual machine that behaves like a separate computer with its own operating system and virtual hardware.

**Volume:** Persistent data stored outside a Docker container's disposable filesystem.

## Ports used in this guide

| Service | Port | Address form |
| --- | ---: | --- |
| Proxmox | 8006 | `https://PROXMOX-IP:8006` |
| Dockhand | 3000 | `http://CONTAINER-IP:3000` |
| Heimdall | 8080 | `http://CONTAINER-IP:8080` |
| Beszel | 8090 | `http://CONTAINER-IP:8090` |
| Dozzle | 8888 | `http://CONTAINER-IP:8888` |

Away from home, each Docker app is also at `https://NAME.TAILNET.ts.net`, as
set up in [Connect Remotely](/guide/connect-remotely/).
