---
title: Install Docker
description: Install Docker Engine and Compose from Docker's official Debian repository.
sidebar:
  order: 5
---

Docker Engine runs the containers that power your apps, and the Compose plugin
runs a whole app from a single Compose file. Install both from Docker's
official repository.

Run every command on this page in the VS Code terminal connected to the Debian container.

## Update Debian

```bash
apt update
apt full-upgrade -y
apt install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
```

Add Docker's official repository:

```bash
cat > /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Verify Docker and Compose:

```bash
docker run --rm hello-world
docker compose version
```

Docker downloads a test image and prints `Hello from Docker!`. The version
command then prints the installed Compose version.

## Save a clean starting point

In Proxmox, select the Debian container, open **Snapshots**, choose **Take Snapshot**, enter `docker-clean` in the **Name** field, and choose **Take Snapshot**.

This snapshot preserves the clean Docker installation. If a later experiment goes badly, you can return to this exact state instead of rebuilding the container.

Docker works, and you have your first safety net.

**[Next: Install Dockhand →](/guide/install-dockhand/)**
