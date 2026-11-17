---
title: Next Steps
description: Decide what to explore after completing the core path.
sidebar:
  order: 1
---

You have a working lab, and you have proved that one bad change does not have
to mean starting over.

Choose one small problem you would genuinely like your homelab to solve. Read
the project's official documentation, find out where it stores its data, and
make one careful experiment through Dockhand. When you want ideas or deeper
detail, [Further Reading](/reference/further-reading/) lists the official docs
and a few communities. Keep the habit: snapshot before every experiment.

## Back it up

Snapshots and clones are both stored on the disk your LXC runs on, so neither
survives a dead drive. [Proxmox Backup Server](https://pbs.proxmox.com/docs/)
(PBS) is the next step: it keeps deduplicated backups of your containers on
separate storage, such as a second drive or another machine, and restores a
container in a few clicks.

Run PBS as its own VM or on a second computer rather than as a container
alongside the apps it protects. A backup that shares the drive is not much of a
backup.

## One final note

You will likely come across helper scripts which install
many apps on Proxmox with one command each. I suggest waiting before using any
of them. Each script runs with full control of your Proxmox server, so use them
once you can read one and judge what it does. They also skip the steps where
you learn how the pieces fit together.
