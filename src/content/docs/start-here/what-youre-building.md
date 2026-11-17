---
title: What You're Building
description: See the simple homelab path and check that your old PC is ready.
sidebar:
  order: 1
---

You are turning one old PC into a home server.

<div class="stack-diagram not-content" role="img" aria-label="Your old PC runs Proxmox. Inside Proxmox is a Debian LXC. Inside the LXC is Docker, which runs the apps Dockhand, Heimdall, Beszel, Dozzle, and TSDProxy.">
<div class="stack-layer">
<span class="stack-label">Your old PC, running Proxmox</span>
<div class="stack-layer">
<span class="stack-label">Debian LXC</span>
<div class="stack-layer">
<span class="stack-label">Docker</span>
<div class="stack-apps"><span>Dockhand</span><span>Heimdall</span><span>Beszel</span><span>Dozzle</span><span>TSDProxy</span></div>
</div>
</div>
</div>
</div>

Each layer has one job:

- **Proxmox** is a server management and virtualization platform built on Debian Linux. It allows you to run multiple virtual machines and LXCs on a single computer.
- **An LXC** is a virtual computer inside Proxmox.
- **Docker** runs the apps.
- **Dockhand** manages the Docker apps, **Heimdall** links to them, **Beszel** shows system health, and **Dozzle** shows their logs.
- **TSDProxy** lets you securely access the apps via a Tailscale VPN.

This guide makes the choices so you can get something working. You will
outgrow parts of it later; that is expected.

## The path

Ten short tasks take you from a blank machine to a working lab:

1. Set Up Your Computer
2. Install Proxmox
3. Create Your LXC
4. Connect to Your LXC
5. Install Docker
6. Install Dockhand
7. Build Your Dashboard
8. Break It on Purpose
9. Add Monitoring
10. Connect Remotely

## What you need

- An old desktop or laptop with a 64-bit processor and a wired network connection.
- 8 GB of RAM or more
- A 64 GB drive or larger that can be erased
- A USB stick of 2 GB or larger that can be erased
- Your everyday Windows, macOS, or Linux computer
- A weekend to work through it at your own pace
