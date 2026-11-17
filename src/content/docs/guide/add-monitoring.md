---
title: Add Monitoring
description: Add Beszel and Dozzle through Dockhand and save a known-good snapshot.
sidebar:
  label: 8. Add Monitoring
  order: 9
---

Beszel shows your LXC's health: processor, memory, disk, and
network use. Dozzle gives you a live, searchable view of Docker logs.

## Add Beszel

In Dockhand, open **Stacks**, choose **Create**, and name the stack `beszel`.
Replace `LXC-IP` with your LXC's address, paste the file into
the editor, and choose **Create & Start**:

```yaml
services:
  beszel:
    image: henrygd/beszel:latest
    container_name: beszel
    restart: unless-stopped
    environment:
      APP_URL: http://LXC-IP:8090
    ports:
      - "8090:8090"
    volumes:
      - /opt/volumes/beszel/data:/beszel_data
      - /opt/volumes/beszel/socket:/beszel_socket
    labels:
      tsdproxy.enable: "true"
  beszel-agent:
    image: henrygd/beszel-agent:latest
    container_name: beszel-agent
    restart: unless-stopped
    network_mode: host
    volumes:
      - /opt/volumes/beszel/agent_data:/var/lib/beszel-agent
      - /opt/volumes/beszel/socket:/beszel_socket
      - /var/run/docker.sock:/var/run/docker.sock:ro
    environment:
      LISTEN: /beszel_socket/beszel.sock
      HUB_URL: http://localhost:8090
      TOKEN: "REPLACE_AFTER_ADDING_SYSTEM"
      KEY: "REPLACE_AFTER_ADDING_SYSTEM"
```

Open `http://LXC-IP:8090` and create your admin account. Choose **Add System**.
Enter a **Name** such as `docker` (the LXC hostname) and enter
`/beszel_socket/beszel.sock` for **Host / IP**. Copy the generated token and
public key into the matching `TOKEN` and `KEY` environment variables in
Dockhand's stack editor, then choose **Save & redeploy**. The `beszel-agent`
container may log authentication errors until it restarts with the correct
credentials; this is normal during initial setup. Return to Beszel and choose
**Add System** in the dialog to complete registration. The system status should
turn green.

## Add Dozzle

On **Stacks**, choose **Create**, name the stack `dozzle`, paste this file into
the editor, and choose **Create & Start**:

```yaml
services:
  dozzle:
    image: amir20/dozzle:latest
    container_name: dozzle
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    labels:
      tsdproxy.enable: "true"
```

Open `http://LXC-IP:8080`. Add Beszel and Dozzle to Heimdall with their URLs.

In Proxmox, select your LXC, open **Snapshots**, choose **Take
Snapshot**, enter `monitoring-installed` in the **Name** field, and choose **Take
Snapshot**. Then select `working-dashboard` and choose **Delete**, so only the newest snapshot remains.

You now have health monitoring and live logs.
