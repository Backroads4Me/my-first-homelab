---
title: Why This Path
description: Who this guide is for, the trade-offs it makes on purpose, and how to suggest a change.
sidebar:
  order: 5
---

If you already run a homelab, you will see choices here that you would make
differently. They are deliberate. This page explains them.

## Who this guide is for

The reader is someone with a spare PC, little technical experience, and a
worry about breaking things. Most homelab advice offers that person ten ways
to do every step. This guide offers one, so they can finish with something
working.

Every choice below has a reasonable alternative. I picked the option that
gets a beginner to a working result with the fewest decisions.

## The trade-offs

- **Docker in an LXC, not a virtual machine.** Proxmox recommends a virtual
  machine for Docker. The guide uses an unprivileged LXC because its snapshots
  and clones are fast and light on modest hardware, which makes mistakes cheap
  to undo.
- **One Debian container holds every app.** Many homelabs give each app its
  own LXC or virtual machine, which isolates them from each other. Here a
  single snapshot covers everything, and every app is at the same address.
- **An SSH key with no passphrase.** SSH on the server is reachable only from
  the home network, and a passphrase is one more place for a beginner to get
  stuck.
- **A web interface for Docker.** Dockhand lets the reader deploy and change
  apps without learning the Docker command line first. The Compose files are
  still there to read.
- **Tailscale and TSDProxy for remote access.** A reverse proxy with your own
  domain is more flexible. Tailscale needs no open router ports, no domain,
  and no certificates to manage.
- **Typed steps, not helper scripts.** The
  [Proxmox VE Helper-Scripts](https://community-scripts.org/) could build most
  of this in a few commands. The guide has the reader do each step, because
  that is where the learning happens, and because a beginner cannot yet judge
  a script that runs as root on the Proxmox server.
  [Next Steps](/reference/next-steps/) points to the scripts for later.
- **Few apps.** The guide installs a dashboard, monitoring, and a log viewer,
  and stops there. Choosing what to run next is the reader's job.

## Readers are expected to outgrow it

The guide is a starting point. A reader who finishes it and then moves Docker
into a virtual machine, adds backups, or replaces half the tools has used it
as intended.

## Suggestions and pull requests

I am happy to take corrections, suggestions, and pull requests. A step that
is wrong, unclear, or out of date is the most useful thing to report.

- [Open an issue](https://github.com/Backroads4Me/my-first-homelab/issues) to report a problem or suggest a change.
- Read the [contributing guide](https://github.com/Backroads4Me/my-first-homelab/blob/main/CONTRIBUTING.md) before a pull request. It lists the writing rules and what is out of scope.

Additions are welcome too. I would like the site to grow a second phase that
picks up where the nine tasks end, with a few more pieces to build. Ideas for
that phase, and links worth adding to
[Further Reading](/reference/further-reading/), are both useful.

The nine tasks themselves stay one path. A suggestion that adds a second way
to do one of those steps will probably be declined. A simpler or safer way to
do the same step is welcome.
