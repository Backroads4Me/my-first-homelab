---
title: What You're Building
description: See the simple homelab path and check that your old PC is ready.
sidebar:
  order: 1
---

You are turning one old PC into a home server.

Proxmox manages the server and gives you snapshots and clones. A Debian Linux container (LXC) holds Docker. Dockhand manages the Docker apps, Heimdall links to them, Beszel shows system health, and Dozzle shows container logs. Tailscale and TSDProxy let you reach those apps from your phone or laptop anywhere, without opening ports on your router.

This guide makes the choices so you can get something working. You will
outgrow parts of it later. Good. That means it did its job.

Proxmox recommends running application containers such as Docker inside a virtual machine. This guide deliberately uses an unprivileged LXC with nesting enabled because snapshots and clones make experimentation less scary, and its tiny overhead suits modest hardware.

## The path

Nine short tasks take you from a blank machine to a working lab. Each one
ends with something working:

1. Install Proxmox
2. Set Up VS Code
3. Create Your Container
4. Install Docker
5. Install Dockhand
6. Build Your Dashboard
7. Break It on Purpose
8. Add Monitoring
9. Connect Remotely

## What you need

- An old desktop or laptop with a 64-bit processor and a wired network connection
- An old laptop works if you leave the lid open so the server stays awake
- 16 GB of RAM for a comfortable start; do not use a machine with less than 8 GB
- A 64 GB drive or larger that can be erased
- A USB stick of 2 GB or larger that can be erased
- Your everyday Windows, macOS, or Linux computer
- A weekend of curiosity

The best hardware is what you already have.

**[Next: Install Proxmox →](/guide/install-proxmox/)**
