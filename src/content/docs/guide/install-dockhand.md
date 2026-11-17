---
title: Install Dockhand
description: Install Dockhand and open its Docker management interface.
sidebar:
  label: 6. Install Dockhand
  order: 7
---

Dockhand gives you a web interface for deploying and managing Docker Compose stacks.

In the VS Code terminal connected to your LXC, create its directory, install the nano editor, and open a new Compose file:

```bash
mkdir -p /opt/dockhand
cd /opt/dockhand
apt install -y nano
nano compose.yaml
```

In the blank nano window, paste the configuration (`Ctrl+V` on Windows, `Cmd+V`
on macOS, `Ctrl+Shift+V` on Linux), save with `Ctrl+O` and `Enter`, and close
with `Ctrl+X`:

```yaml
services:
  dockhand:
    image: fnsys/dockhand:latest
    container_name: dockhand
    restart: unless-stopped
    ports:
      - "3000:3000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /opt/volumes/dockhand/data:/app/data
    labels:
      tsdproxy.enable: "true"
```

The data each app writes lives on the LXC under `/opt/volumes/<app-name>`,
separate from its Compose file, so it survives deleting the stack. Dockhand's
own data is `/opt/volumes/dockhand/data`.

Every app's Compose file in this guide has this `labels` entry. It does
nothing yet; [Connect Remotely](/guide/connect-remotely/) uses it to reach your
apps from anywhere.

Start it:

```bash
docker compose up -d
```

Open `http://LXC-IP:3000`. On first launch, Dockhand shows a one-time
**Unsecured exposure** warning; choose **Got it** to dismiss it. Then go to
**Settings <span class="ui-arrow" role="img" aria-label="then"></span> Authentication**, create your admin user, and enable
authentication.

Dockhand will be used to install and control every other Docker container.
