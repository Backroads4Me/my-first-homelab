---
title: Add Monitoring
description: Add Beszel and Dozzle through Dockhand and save a known-good snapshot.
sidebar:
  order: 9
---

Beszel shows the server's health. Dozzle gives you a live, searchable view of
Docker logs.

## Add Beszel

In Dockhand, open **Stacks**, choose **Create**, and name the stack `beszel`.
Replace `CONTAINER-IP` with the Debian container's address, paste the file into
the editor, and choose **Create & Start**:

```yaml
services:
  beszel:
    image: henrygd/beszel:latest
    container_name: beszel
    restart: unless-stopped
    environment:
      APP_URL: http://CONTAINER-IP:8090
    ports:
      - "8090:8090"
    volumes:
      - ./beszel_data:/beszel_data
      - ./beszel_socket:/beszel_socket
    labels:
      tsdproxy.enable: "true"
  beszel-agent:
    image: henrygd/beszel-agent:latest
    container_name: beszel-agent
    restart: unless-stopped
    network_mode: host
    volumes:
      - ./beszel_agent_data:/var/lib/beszel-agent
      - ./beszel_socket:/beszel_socket
      - /var/run/docker.sock:/var/run/docker.sock:ro
    environment:
      LISTEN: /beszel_socket/beszel.sock
      HUB_URL: http://localhost:8090
      TOKEN: "REPLACE_AFTER_ADDING_SYSTEM"
      KEY: "REPLACE_AFTER_ADDING_SYSTEM"
```

Open `http://CONTAINER-IP:8090` and create your admin account. Choose **Add
System**. Enter a **Name** such as `homelab` and enter
`/beszel_socket/beszel.sock` for **Host / IP**. Copy the generated token and
public key into the matching values in Dockhand's stack editor, then choose
**Save & redeploy**. The `beszel-agent` container logs errors until these
credentials are saved; that is normal. Return to Beszel and choose **Add
System** in the dialog to finish. The system status should turn green.

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
      - "8888:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./data:/data
    labels:
      tsdproxy.enable: "true"
```

Open `http://CONTAINER-IP:8888`. Add Beszel and Dozzle to Heimdall with their URLs.

You now have Proxmox, a lightweight Debian container, Docker, a dashboard,
health monitoring, and live logs. You have also proved you can undo a mistake.
In Proxmox, select the Debian container, open **Snapshots**, choose **Take
Snapshot**, enter `core-complete` in the **Name** field, and choose **Take
Snapshot**. Make **snapshot before every experiment** your homelab habit.

**[Next Steps: Where to Go from Here →](/reference/next-steps/)**
