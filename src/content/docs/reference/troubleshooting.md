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
- In BIOS settings, enable USB boot.

## Proxmox does not open on port 8006

- Use `https`, not `http`: `https://PROXMOX-IP:8006`.
- Confirm the IP shown on the physical server's console.
- Make sure the server and your everyday computer are on the same home network.
- Try `ping PROXMOX-IP` as [Install Proxmox](/guide/install-proxmox/) describes it. If it fails, check the Ethernet cable and the gateway entered during installation.

The browser certificate warning is expected for a new Proxmox server. Accept it only when the address is your server's address.

## Proxmox shows "No valid subscription"

The dialog saying "You do not have a valid subscription for this server" appears whenever you sign into the Proxmox web interface without an enterprise subscription key. This is expected. Select **OK** to dismiss the notice; the server is fully functional and updates come from the no-subscription repository configured in the guide.

## SSH says connection refused

- Confirm the target IP. The Proxmox host and your LXC have different addresses.
- Confirm the target is running in Proxmox.
- Open the LXC's **Console** in Proxmox and run `ip address` to check its current address.
- Retry `ssh root@LXC-IP` from the VS Code terminal on your everyday computer.

If SSH rejects the key, open the LXC's **Console** in Proxmox and compare `/root/.ssh/authorized_keys` with the output of `cat $HOME/.ssh/id_ed25519.pub` on your everyday computer.

## SSH says "REMOTE HOST IDENTIFICATION HAS CHANGED"

This appears after you recreate the LXC, or when an address moves to a different one. Your everyday computer still holds the old host key. In the VS Code terminal on your everyday computer, remove the old key, replacing `LXC-IP` with your LXC's IP address:

```bash
ssh-keygen -R LXC-IP
```

Use `PROXMOX-IP` instead if you are connecting to the Proxmox host. Reconnect, and SSH will ask you to accept the new host key.

## Your LXC has no network address

- Confirm the LXC is connected to bridge `vmbr0` in Proxmox under its **Network** settings.
- Check that your router's DHCP server is running and has available addresses.
- Under the LXC's **Network** settings, confirm IPv4 is set to **DHCP** and IPv6 is set to **Static** with its fields empty.
- Shut the LXC down in Proxmox and start it again.

## Docker will not start in the LXC

Select the LXC in Proxmox, open **Options <span class="ui-arrow" role="img" aria-label="then"></span> Features**, and confirm **Nesting** and **keyctl** are enabled. Restart the LXC after changing it, then run:

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

Remove that container's old stack in Dockhand. If Dockhand itself will not
open, run `docker rm -f NAME` with the name from the list. Redeploy the stack
from the current guide page without changing its port.

## An app does not open over Tailscale

- Confirm the device you are using shows the Tailscale app as connected.
- Confirm the app's Compose file has the `tsdproxy.enable: "true"` label, then redeploy its stack.
- Open the `tsdproxy` logs in Dozzle. An auth key error means the key was mistyped or has expired: generate a new one, replace it in `/opt/volumes/tsdproxy/config/tsdproxy.yaml`, and restart the `tsdproxy` stack.
- The first visit to each address can take a minute while it gets its certificate. If it never loads, confirm **Enable HTTPS** is on in the Tailscale admin console's DNS page.

## I broke it

Stop changing things. In Proxmox, select your LXC, open **Snapshots**, select the last known-good snapshot, and choose **Rollback**. Changes made after that snapshot will be discarded. Rollback leaves the LXC stopped, so start it again in Proxmox before reconnecting.

If there is no snapshot, inspect the affected stack's logs in Dockhand or Dozzle before deleting anything.
