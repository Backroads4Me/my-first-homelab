---
title: Install Proxmox
description: Install Proxmox VE and update it from the web interface.
sidebar:
  label: 2. Install Proxmox
  order: 3
---

This task turns the old PC into a Proxmox server you can manage from a browser.

## Make the installer

1. Download the current **Proxmox VE ISO Installer** from [Proxmox Downloads](https://www.proxmox.com/en/downloads/proxmox-virtual-environment/iso). Take the entry whose name does not say `ARM64`.
2. Install [balenaEtcher](https://etcher.balena.io/) on your everyday computer.
3. Insert the USB stick and open Etcher.
4. Choose **Flash from file**, select the Proxmox ISO, choose the USB stick, then select **Flash**.
5. When validation finishes, eject the USB stick and put it in the server.

## Install Proxmox

Before you boot, connect the server (your old computer) to your router with an Ethernet cable. The installer has no
Wi-Fi option, and the update steps below need internet.

Boot the server from the USB stick and choose **Install Proxmox VE (Graphical)**.
Follow the installer:

1. Accept the license and select the drive to erase.
2. Set your country, time zone, and keyboard layout.
3. Set a strong root password and enter your email address.
4. On **Management Network Configuration**, select the wired network interface. The installer fills in the network values supplied by your router. Leave those values in place and enter:
   - **Hostname:** `pve.home.arpa`. Proxmox uses the part before the first dot as the server's own
     name, so it appears in the web interface as **pve**.
5. Review the summary, install, remove the USB stick, and reboot.

:::caution[USB does not boot]
Open the PC's BIOS or boot menu with `F2`, `F12`, or `Del`, enable USB boot, then try again.
:::

The physical server's console shows its management address after it starts. Write the address down; the guide calls it `PROXMOX-IP`.

## Reserve the address in your router

Before you use that address anywhere, confirm it is live. In the VS Code terminal, run:

```bash
ping PROXMOX-IP
```

Replies mean the address is right. Windows stops after four on its own, and macOS and Linux keep going until you press Ctrl+C. No replies means the address is mistyped or the two machines are not on the same network, so re-read the console before you reserve anything.

Proxmox keeps that address until you tell the router otherwise, so open your router's admin page and create a DHCP reservation for it, and the router will not hand it to another device. The router's client list shows the Proxmox device and its MAC address if the reservation asks for one.

## Log in and update
On your everyday computer, open `https://PROXMOX-IP:8006`, replacing `PROXMOX-IP` with the
reserved address.

The browser interrupts with **Your connection is not private** in Chrome, or **Warning: Potential
Security Risk Ahead** in Firefox. Proxmox answers HTTPS with a certificate it signed itself, which
no certificate authority your browser trusts has vouched for, so this warning appears on every
fresh install and is expected on your own network. Choose **Advanced**, then **Proceed to …
(unsafe)**; that button repeats the address you typed. Firefox calls it **Accept the Risk and
Continue**.

Sign in as `root` with realm **Linux PAM standard authentication**. A "No valid subscription"
message appears; this is normal, and **OK** dismisses it.

Set up the no-subscription repository:

1. Select **pve** in the tree on the left. That is your server; Proxmox calls each machine it
   manages a node. Then open **Updates <span class="ui-arrow" role="img" aria-label="then"></span> Repositories**.
2. Select the enterprise repository and choose **Disable**. Do the same for
   the Ceph enterprise repository if it is listed.
3. Choose **Add**, select **No-Subscription**, and confirm.
4. Open **Updates**, choose **Refresh**, then **Upgrade**.
5. Follow the prompts in the upgrade window and reboot if requested.

You now have an updated Proxmox server.
