---
title: Build Your Dashboard
description: Deploy Heimdall through Dockhand and save a working snapshot.
sidebar:
  label: 7. Build Your Dashboard
  order: 8
---

Heimdall gives your homelab a simple home page with links to every service.

## Deploy Heimdall

1. Open Dockhand at `http://LXC-IP:3000`.
2. Open **Stacks**, choose **Create**, and enter `heimdall` for the stack name.
3. Paste this Compose file into the editor:

```yaml
services:
  heimdall:
    image: lscr.io/linuxserver/heimdall:latest
    container_name: heimdall
    restart: unless-stopped
    environment:
      PUID: "0"
      PGID: "0"
      TZ: Etc/UTC
      ALLOW_INTERNAL_REQUESTS: "true"
    volumes:
      - /opt/volumes/heimdall/config:/config
    ports:
      - "8080:80"
    labels:
      tsdproxy.enable: "true"
```

4. Choose **Create & Start** and wait for the container status to show as running.
5. Open `http://LXC-IP:8080`.

## Add your first links

In Heimdall, choose **Add an application here** (or the **+** tile). Enter
`Proxmox` in **Application name**, enter `https://PROXMOX-IP:8006` in **URL**,
and choose **Save** (the disk icon in the top right). Repeat to add `Dockhand`
at `http://LXC-IP:3000`.

## Save the working dashboard

In Proxmox, select your LXC, open **Snapshots**, choose **Take Snapshot**, enter `working-dashboard` in the **Name** field, and choose **Take Snapshot**.

Heimdall is running, and you have a snapshot of the working setup.
