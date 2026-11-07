---
title: Troubleshooting
description: Fix the problems most likely to appear while following this guide.
sidebar:
  order: 2
---

Start with the symptom you can see. Change one thing, test again, and keep notes.

## The USB stick will not boot

- Reflash the Proxmox ISO with balenaEtcher and let validation finish.
- Use the PC's one-time boot menu, usually `F12`, `F2`, or `Del`, and select the USB stick.
- In BIOS settings, enable USB boot and Intel VT-x or AMD-V virtualization.

## Proxmox does not open on port 8006

- Use `https`, not `http`: `https://PROXMOX-IP:8006`.
- Confirm the IP shown on the physical server's console.
- Make sure the server and your everyday computer are on the same home network.
- Try `ping PROXMOX-IP` in a terminal on your everyday computer (PowerShell on Windows, Terminal on macOS or Linux; or in VS Code when not connected to a remote). If it fails, check the Ethernet cable and the gateway entered during installation.

The browser certificate warning is expected for a new Proxmox server. Accept it only when the address is your server's address.

## SSH says connection refused

- Confirm the target IP. The Proxmox host and Debian container have different addresses.
- Confirm the target is running in Proxmox.
- Open the container's **Console** in Proxmox and run `ip address` to check its current address.
- Retry `ssh root@PROXMOX-IP` or `ssh root@CONTAINER-IP`, whichever system you are connecting to.

If SSH rejects the key, use the Proxmox console to compare `/root/.ssh/authorized_keys` with the output of `cat $HOME/.ssh/id_ed25519.pub` on your everyday computer.

## SSH says "REMOTE HOST IDENTIFICATION HAS CHANGED"

This appears after you recreate a container, or when an address moves to a different one. Your everyday computer still holds the old host key. In a terminal on that computer (such as a VS Code window not connected to a remote), remove the old key, replacing `CONTAINER-IP` with your container's IP address:

```bash
ssh-keygen -R CONTAINER-IP
```

Use your server's `PROXMOX-IP` instead if you are connecting to the Proxmox host. Reconnect, and SSH will ask you to accept the new host key.

## Docker will not start in the LXC

Select the Debian container in Proxmox, open **Options → Features**, and confirm **Nesting** is enabled. Restart the container after changing it, then run:

```bash
systemctl status docker --no-pager
docker run --rm hello-world
```

## A Docker port is already allocated

The ports in this guide do not overlap, so an earlier attempt is still using
the port. Find the container:

```bash
docker ps --format 'table {{.Names}}\t{{.Ports}}'
```

Open that container in Dockhand and remove its old stack. If Dockhand itself
will not open, run `docker ps` in the container terminal to find the
conflicting name, then `docker rm -f NAME`. Redeploy the stack
from the current guide page without changing its port.

## An app does not open over Tailscale

- Confirm the device you are using shows the Tailscale app as connected.
- Confirm the app's Compose file has the `tsdproxy.enable: "true"` label, then redeploy its stack.
- Open the `tsdproxy` logs in Dozzle. An auth key error means the key was mistyped or has expired: generate a new one, replace it in the `tsdproxy` stack, and choose **Save & redeploy**.
- The first visit to each address can take a minute while it gets its certificate. If it never loads, confirm **Enable HTTPS** is on in the Tailscale admin console's DNS page.

## I broke it

Stop changing things. In Proxmox, select the Debian container, open **Snapshots**, select the last known-good snapshot, and choose **Rollback**. Changes made after that snapshot will be discarded. Rollback leaves the container stopped, so start it again in Proxmox before reconnecting.

If there is no snapshot, inspect the affected stack's logs in Dockhand or Dozzle before deleting anything.
