---
title: Create Your LXC
description: Create a Debian LXC with SSH access.
sidebar:
  label: 3. Create Your LXC
  order: 4
---

This task creates the LXC that will hold every Docker app in the guide. An LXC is a virtual computer inside Proxmox, and you build it entirely from the Proxmox web interface.

## Download Debian

1. In the tree on the left, open **Datacenter** and select **local (pve)** under the **pve** node, then choose **CT Templates** beside it. Proxmox lists each machine it manages under **Datacenter**, and storage appears under the machine that owns it with that machine's name in brackets, which is why the Proxmox host's own storage reads **local (pve)**.
2. Choose **Templates**, select the latest `debian-13-standard` template, and choose **Download**.

## Create the LXC

In the VS Code terminal, print your public key:

```bash
cat $HOME/.ssh/id_ed25519.pub
```

Copy the single output line. Then complete the **Create CT** wizard in Proxmox:

1. Select **pve** in the tree on the left to return to the node's main page, then choose **Create CT** in the top-right corner.
2. **General:** use hostname `docker`, set a root password, paste the SSH key you copied above into **SSH public key**, and leave **Unprivileged container** and **Nesting** checked. Docker needs nesting to run.
3. **Template:** select the Debian 13 template.
4. **Disks:** keep **Storage** as `local-lvm` and set **Disk size** to `16` GiB. Snapshots work only on `local-lvm`, not on directory storage.
5. **CPU:** set **Cores** to `2`.
6. **Memory:** set **Memory** to `4096` MiB and **Swap** to `512` MiB.
7. **Network:** keep bridge `vmbr0`, choose **DHCP** for IPv4, and set IPv6 to **Static** with its fields left empty.
8. **DNS:** keep **Use host settings**.
9. Confirm the settings and create the LXC.

Select the new LXC, open **Options <span class="ui-arrow" role="img" aria-label="then"></span> Features**, choose **Edit**, enable **keyctl**, and save. Docker needs keyctl in an unprivileged LXC. Nesting is already on from the wizard.

Start the LXC. Its **Summary** page shows the DHCP address. Write it down; the guide calls it `LXC-IP`.

Confirm it is live with another ping in the terminal:

```bash
ping LXC-IP
```

Replies mean the address is right.

Then return to your router's admin page and create a DHCP reservation for the LXC named `docker`. This keeps its address from changing. The LXC's MAC address is on its **Network** page in Proxmox if the reservation asks for one.

That is the second DHCP reservation, one for each machine: Proxmox keeps `PROXMOX-IP` and the LXC keeps `LXC-IP`.
