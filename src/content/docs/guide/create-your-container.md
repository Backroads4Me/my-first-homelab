---
title: Create Your Container
description: Create an unprivileged Debian 13 LXC with nesting and SSH access.
sidebar:
  label: 3. Create Your Container
  order: 4
---

This task creates the small Debian server that will hold every Docker app in the guide.

## Download Debian

1. In Proxmox, select **local (pve)**, then **CT Templates**.
2. Choose **Templates**, select the latest `debian-13-standard` template, and choose **Download**.

## Create the container

In a VS Code window that is not connected to a remote (the lower-left corner
shows no host), print your public key:

```bash
cat $HOME/.ssh/id_ed25519.pub
```

Copy the single output line. In Proxmox, choose **Create CT** and complete the wizard:

1. **General:** use hostname `docker`, set a root password, paste the line into **SSH public key**, and leave **Unprivileged container** and **Nesting** checked. Docker needs nesting to run.
2. **Template:** select the Debian 13 template.
3. **Disks:** set **Disk size** to `16` GiB.
4. **CPU:** set **Cores** to `2`.
5. **Memory:** set **Memory** to `2048` MiB and **Swap** to `512` MiB.
6. **Network:** keep bridge `vmbr0`, choose **DHCP** for IPv4, and set IPv6 to **Static** with its fields left empty.
7. **DNS:** keep **Use host settings**.
8. Confirm the settings and create the container.

Select the new container, open **Options → Features**, choose **Edit**, enable **keyctl**, and save. Docker needs keyctl in an unprivileged container. Nesting is already on from the wizard.

Start the container. Its **Summary** page shows the DHCP address. Return to
your router's admin page and create a DHCP reservation for the container named
`docker`. This keeps its address from changing. The container's MAC address is
on its **Network** page in Proxmox if the reservation asks for one. Write this
address down too; the guide calls it `CONTAINER-IP`.

## Connect to Debian

In VS Code's **Remote Explorer**, add `ssh root@CONTAINER-IP` with the
container's reserved address, choose the suggested SSH configuration file, and
connect. Accept the fingerprint, then run:

```bash
cat /etc/debian_version
```

It prints a version that starts with `13`. You now have a Debian 13 LXC with key-based root SSH.
