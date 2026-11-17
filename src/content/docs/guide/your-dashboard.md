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
      ALLOW_INTERNAL_REQUESTS: "true"
    volumes:
      - /opt/volumes/heimdall/config:/config
    ports:
      - "80:80"
    labels:
      tsdproxy.enable: "true"
```

4. Choose **Create & Start** and wait for the container status to show as running.
5. Open `http://LXC-IP`.

## Add your first links

In Heimdall, choose **Application list**, then choose **Add** (the **+** button). Enter
`Proxmox` in **Application name**, enter `https://PROXMOX-IP:8006` in **URL**,
and choose **Save**. Repeat to add `Dockhand`
at `http://LXC-IP:3000`.

## Save the working dashboard

In Proxmox, select your LXC, open **Snapshots**, choose **Take Snapshot**, enter `working-dashboard` in the **Name** field, and choose **Take Snapshot**. Then select `docker-clean` and choose **Delete**; keep only the newest snapshot, since each one holds space on the LXC's own disk.

Heimdall is running, and you have a snapshot of the working setup.
