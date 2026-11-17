---
title: Connect to Your LXC
description: Connect to your LXC over SSH and update Debian.
sidebar:
  label: 4. Connect to Your LXC
  order: 5
---

Your key went into the LXC when you created it, so this connection needs no password. Proxmox is managed solely from its web interface; this step is connecting to the LXC.

## Connect

1. In VS Code, open **Remote Explorer** in the Activity Bar.
2. Under **SSH**, choose **New Remote** (`+`).
3. Enter `ssh root@LXC-IP`, replacing `LXC-IP` with the LXC's reserved address.
4. Choose the SSH configuration file suggested by VS Code.
5. Select the new host and choose **Connect in New Window**.
6. Choose **Linux** when VS Code asks for the remote platform, and accept the fingerprint if one appears.

The lower-left corner of the new window shows the LXC's address. That is how you tell whose terminal you are using: with the address showing, the terminal runs on the LXC, and with nothing showing it runs on your everyday computer.

## Check the connection

Open **Terminal <span class="ui-arrow" role="img" aria-label="then"></span> New Terminal** in the connected window and run:

```bash
hostname
```

`hostname` prints `docker`, the name you gave the LXC in the wizard. If it prints something about your own computer instead, the window is not connected to the LXC; check the lower-left corner again.

## Update Debian

Bring the freshly created LXC up to date before installing anything else:

```bash
apt update && apt full-upgrade -y
```

This can take a few minutes. Leave this window connected: every command from here on runs in its terminal.
