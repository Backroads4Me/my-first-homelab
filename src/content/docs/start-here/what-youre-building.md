---
title: What You're Building
description: See the simple homelab path and check that your old PC is ready.
sidebar:
  order: 1
---

You are turning one old PC into a home server.

<div class="stack-diagram not-content" role="img" aria-label="Your old PC runs Proxmox. Inside Proxmox is a Debian container. Inside the container is Docker, which runs the apps Dockhand, Heimdall, Beszel, Dozzle, and TSDProxy.">
<div class="stack-layer">
<span class="stack-label">Your old PC, running Proxmox</span>
<div class="stack-layer">
<span class="stack-label">Debian container</span>
<div class="stack-layer">
<span class="stack-label">Docker</span>
<div class="stack-apps"><span>Dockhand</span><span>Heimdall</span><span>Beszel</span><span>Dozzle</span><span>TSDProxy</span></div>
</div>
</div>
</div>
</div>

Each layer has one job:

- **Proxmox** runs on the PC and manages everything inside it. It gives you snapshots and clones.
- **A Debian Linux container (LXC)** is a small server inside Proxmox. It holds Docker.
- **Docker** runs the apps.
- **Dockhand** manages the Docker apps, **Heimdall** links to them, **Beszel** shows system health, and **Dozzle** shows their logs.
- **Tailscale and TSDProxy** let you reach those apps from your phone or laptop anywhere, without opening ports on your router.

This guide makes the choices so you can get something working. You will
outgrow parts of it later; that is expected.

Proxmox recommends running application containers such as Docker inside a virtual machine. This guide deliberately uses an unprivileged LXC with nesting enabled because snapshots and clones make mistakes cheap to undo, and its tiny overhead suits modest hardware.

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

- An old desktop or laptop with a 64-bit processor and a wired network connection. On a laptop, leave the lid open so the server stays awake.
- 8 GB of RAM or more for a comfortable start; 4 GB is enough for everything in this guide
- A 64 GB drive or larger that can be erased
- A USB stick of 2 GB or larger that can be erased
- Your everyday Windows, macOS, or Linux computer
- A weekend to work through it at your own pace
