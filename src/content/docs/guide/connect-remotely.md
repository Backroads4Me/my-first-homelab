---
title: Connect Remotely
description: Reach your apps from anywhere with Tailscale and TSDProxy, without opening any ports.
sidebar:
  label: 9. Connect Remotely
  order: 10
---

Your apps only work at home so far. This task lets you open them from your
phone or laptop anywhere, without opening a single port on your router.

Tailscale builds a private network between the devices you sign in to it.
TSDProxy watches Docker and gives every app with the `tsdproxy.enable` label
its own address on that network, with a real HTTPS certificate. That label is
the one you added to every Compose file earlier. Only devices signed in to
your Tailscale account can reach these addresses.

## Create your Tailscale account

Sign up at [login.tailscale.com/start](https://login.tailscale.com/start). The
free Personal plan covers everything in this guide.

Then install the Tailscale app on your everyday computer and your phone, and
sign in with the same account. Tailscale's own install guides walk through each
one; you do not need to change any settings in the app:

- [Windows](https://tailscale.com/docs/install/windows),
  [macOS](https://tailscale.com/docs/install/mac), or
  [Linux](https://tailscale.com/docs/install/linux)
- [iPhone and iPad](https://tailscale.com/docs/install/ios) or
  [Android](https://tailscale.com/docs/install/android)

## Turn on HTTPS

1. In the Tailscale admin console, open the
   [DNS](https://console.tailscale.com/admin/dns) page.
2. Confirm **MagicDNS** is enabled.
3. Under **HTTPS Certificates**, choose **Enable HTTPS** and accept the notice.

The notice says machine names are published in public certificate logs. Your
app names (`dockhand`, `heimdall`, `beszel`, `dozzle`) are the only names this
publishes.

## Create an auth key

TSDProxy uses an auth key to add your apps to Tailscale without a browser
sign-in for each one.

1. Open the [Keys](https://console.tailscale.com/admin/settings/keys) page.
2. Choose **Generate auth key**.
3. Enter `tsdproxy` as the description, turn on **Reusable**, and leave the
   expiration at 90 days.
4. Choose **Generate key** and copy the key that starts with `tskey-auth-`.

## Install TSDProxy

In Dockhand, open **Stacks**, choose **Create**, and name the stack
`tsdproxy`. Paste this file and choose **Create & Start**:

```yaml
services:
  tsdproxy:
    image: almeidapaulopt/tsdproxy:2
    container_name: tsdproxy
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./data:/data
      - /opt/tsdproxy/config:/config
    extra_hosts:
      - "host.docker.internal:host-gateway"
```

TSDProxy reads the labels through the Docker socket and reaches each app
through the port it already publishes. The `./data` folder keeps each app's
Tailscale identity, so the addresses survive restarts. On its first start,
TSDProxy writes its settings file into `/opt/tsdproxy/config`.

## Add your auth key

In the VS Code terminal connected to Debian, open the settings file:

```bash
code /opt/tsdproxy/config/tsdproxy.yaml
```

Find the line that begins with `authKey:`, paste your key between its quotes,
and save. In Dockhand, open the `tsdproxy` stack and choose **Restart** so
TSDProxy reads the key.

## Open your apps from anywhere

Within a minute or two, the
[Machines](https://console.tailscale.com/admin/machines) page lists
`dockhand`, `heimdall`, `beszel`, and `dozzle`. For each one, open the **...**
menu at the end of its row and choose **Disable Key Expiry**. Otherwise
Tailscale asks each app to sign in again after 180 days.

Select `heimdall` on the Machines page to see its full address, such as
`heimdall.tail1234.ts.net`. On your phone, turn off Wi-Fi, make sure the
Tailscale app is connected, and open `https://heimdall.tail1234.ts.net` with
your own address. The first visit to each app can take a minute while it gets
its certificate.

The other apps follow the same pattern: `https://dockhand.`, `https://beszel.`,
and `https://dozzle.` with the same ending.

The auth key expires after 90 days. That only matters when you add a new app;
generate a new key then, replace the old one in `tsdproxy.yaml`, and restart
the `tsdproxy` stack.

## Update your dashboard

Heimdall's tiles still point to your home addresses, which do not work away
from home. In Heimdall, open the application list, edit the Dockhand, Beszel,
and Dozzle tiles, and replace each **URL** with the app's `https://` Tailscale
address. These addresses work at home too, on any device with Tailscale
connected. The Proxmox tile keeps its home address; Proxmox itself stays
reachable only at home.

In Proxmox, select the Debian container, open **Snapshots**, choose **Take
Snapshot**, enter `remote-access` in the **Name** field, and choose **Take
Snapshot**.

You now have Proxmox, a Debian container, Docker, a dashboard, monitoring,
live logs, and remote access. The path is complete.
