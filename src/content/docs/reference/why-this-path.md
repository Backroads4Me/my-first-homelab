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
- **One container for every app.** Separate containers isolate apps better.
  One container means one thing to snapshot and one address to remember.
- **An SSH key with no passphrase.** SSH on the server is reachable only from
  the home network, and a passphrase is one more place for a beginner to get
  stuck.
- **A web interface for Docker.** Dockhand lets the reader deploy and change
  apps without learning the Docker command line first. The Compose files are
  still there to read.
- **Tailscale and TSDProxy for remote access.** A reverse proxy with your own
  domain is more flexible. Tailscale needs no open router ports, no domain,
  and no certificates to manage.
- **Few apps.** The guide installs a dashboard, monitoring, and a log viewer,
  and stops there. Choosing what to run next is the reader's job.

## You are expected to outgrow it

The guide is a starting point. A reader who finishes it and then moves Docker
into a virtual machine, adds backups, or replaces half the tools has used it
as intended.

## Suggestions and pull requests

I am happy to take corrections, suggestions, and pull requests. A step that
is wrong, unclear, or out of date is the most useful thing to report.

- [Open an issue](https://github.com/Backroads4Me/my-first-homelab/issues) to report a problem or suggest a change.
- Read the [contributing guide](https://github.com/Backroads4Me/my-first-homelab/blob/main/CONTRIBUTING.md) before a pull request. It lists the writing rules and what is out of scope.

A suggestion that adds a second way to do a step will probably be declined,
because one path is the point. A simpler or safer way to do the same step is
welcome.
