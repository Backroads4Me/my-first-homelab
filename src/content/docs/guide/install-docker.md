---
title: Install Docker
description: Install Docker Engine and Compose from Docker's official Debian repository.
sidebar:
  label: 5. Install Docker
  order: 6
---

Docker Engine runs the containers that power your apps, and the Compose plugin
runs a whole app from a single Compose file. Install both from Docker's
official repository.

Run every command on this page in the VS Code terminal connected to your LXC.

## Prepare Debian

The previous task updated Debian. Install the two tools the next commands need:

```bash
apt update && apt install -y ca-certificates curl
```

## Add Docker's repository

Download Docker's signing key so Debian can verify Docker's packages:

```bash
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
```

Tell Debian where Docker's packages live, then install Docker and Compose:

```bash
cat > /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
apt update && apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

## Check that it works

```bash
docker run --rm hello-world
docker compose version
```

Docker downloads a test image and prints `Hello from Docker!`. The version
command then prints the installed Compose version.

## Save a clean starting point

In Proxmox, select your LXC, open **Snapshots**, choose **Take Snapshot**, enter `docker-clean` in the **Name** field, and choose **Take Snapshot**.

This snapshot preserves the clean Docker installation. If a later experiment goes badly, you can return to this exact state instead of rebuilding the LXC. A snapshot is a safety net for one change rather than a backup: it lives on the same disk as the LXC, and an old one stops that disk reusing space, so delete it once you are sure you will not need it.

_📌 You will take a snapshot after each major task and delete the one before it, so a single known-good state is always behind you. If a step ever goes wrong, follow [Roll back to your last snapshot](/guide/perform-a-rollback/#roll-back-to-your-last-snapshot) and start the step again._

Docker works, and you have a snapshot to return to.
