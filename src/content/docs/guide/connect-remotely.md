---
title: Connect Remotely
description: Reach your apps from anywhere with Tailscale and TSDProxy.
sidebar:
  label: 9. Connect Remotely
  order: 10
---

Your apps only work at home so far. This task lets you open them from your
phone or laptop anywhere, without exposing your home network to risk.

Tailscale creates a secure private network that connects all the devices signed
in to your account. TSDProxy automatically gives each Docker app with the
`tsdproxy.enable` label its own private address on that network. This makes your
apps accessible from any of your signed-in devices.

## Create your Tailscale account

Sign up at [login.tailscale.com/start](https://login.tailscale.com/start). The
free Personal plan covers everything in this guide.

Then install the Tailscale app on your everyday computer and optionally your phone, and
sign in with the same account. Tailscale's own install guides walk through each
one; you do not need to change any settings in the app:

- [Windows](https://tailscale.com/docs/install/windows),
  [macOS](https://tailscale.com/docs/install/mac), or
  [Linux](https://tailscale.com/docs/install/linux)
- [iPhone and iPad](https://tailscale.com/docs/install/ios) or
  [Android](https://tailscale.com/docs/install/android)

## Turn on HTTPS

1. In the [Tailscale admin console](https://console.tailscale.com), open the
   [DNS](https://console.tailscale.com/admin/dns) page.
2. Confirm **MagicDNS** is enabled.
3. Under **HTTPS Certificates**, choose **Enable HTTPS** and accept the notice.

## Create an auth key

TSDProxy uses an auth key to add your apps to Tailscale without a browser
sign-in for each one.

1. In the [Tailscale admin console](https://console.tailscale.com), open **Settings** and choose the [Keys](https://console.tailscale.com/admin/settings/keys) page.
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
      - /opt/volumes/tsdproxy/data:/data
      - /opt/volumes/tsdproxy/config:/config
    extra_hosts:
      - "host.docker.internal:host-gateway"
```

TSDProxy reads the labels through the Docker socket and reaches each app
through the port it already publishes. The
`/opt/volumes/tsdproxy/data` folder keeps each app's Tailscale identity, so the
addresses survive restarts. On its first start, TSDProxy writes its settings
file into `/opt/volumes/tsdproxy/config`.

## Add your auth key

In the VS Code terminal connected to your LXC, open the settings file:

```bash
nano /opt/volumes/tsdproxy/config/tsdproxy.yaml
```

Find the line that begins with `authKey:`, paste your key between its quotes,
save with `Ctrl+O` and `Enter`, and close with `Ctrl+X`. In Dockhand, open the `tsdproxy` stack and choose **Restart** so
TSDProxy reads the key.

## Open your apps from anywhere

Within a minute or two, the
[Machines](https://console.tailscale.com/admin/machines) page lists
`dockhand`, `heimdall`, `beszel`, and `dozzle`. For each one, open the **...**
menu at the end of its row and choose **Disable Key Expiry**. Otherwise
Tailscale asks each app to sign in again after 180 days.

The examples below use `tail1234` as the tailnet name. Tailscale chose yours
when you created your account, so your addresses will differ from these.

Select `heimdall` on the Machines page to see its full address, such as
`heimdall.tail1234.ts.net`. On your phone, if you set it up, turn off Wi-Fi, make sure the
Tailscale app is connected, and open `https://heimdall.tail1234.ts.net` with
your own address. The first visit to each app can take a minute while it gets
its certificate.

The other apps follow the same pattern: `https://dockhand.`, `https://beszel.`,
and `https://dozzle.` with the same ending.

The auth key expires after 90 days. That only matters when you add a new app;
generate a new key then, replace the old one in `tsdproxy.yaml`, and restart
the `tsdproxy` stack.

## Add Proxmox to Tailscale

The apps are reachable from anywhere; Proxmox itself is not yet. In Proxmox,
select `pve` in the tree on the left, choose **Shell**, and paste these
commands:

```bash
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up
```

`tailscale up` prints an address. Open it in your browser and sign in to
Tailscale to add the machine. Within a minute the
[Machines](https://console.tailscale.com/admin/machines) page lists `pve`
beside your apps.

Then give Proxmox a real HTTPS certificate, the same kind your apps have. In
the same Shell, run:

```bash
tailscale serve --bg https+insecure://localhost:8006
```

If it prints an address asking you to enable Serve on your tailnet, open it,
enable Serve, and run the command again. Tailscale now answers on
`https://pve.tail1234.ts.net`, with your own tailnet name in place of
`tail1234`, passes each request to Proxmox, and renews the certificate on its
own. The address has no `:8006`, and the browser shows no certificate warning.

## Update your dashboard

Heimdall's tiles still point to your home addresses, which do not work away
from home. In Heimdall, open the **Application list**, edit the Proxmox,
Dockhand, Beszel, and Dozzle tiles, and replace each **URL** with the app's
`https://` Tailscale address. These addresses work at home too, on any device with Tailscale connected.

In Proxmox, select your LXC, open **Snapshots**, choose **Take
Snapshot**, enter `remote-access` in the **Name** field, and choose **Take
Snapshot**. Then select `monitoring-installed` and choose **Delete**, so only the newest snapshot remains.

You now have Proxmox, an LXC, Docker, a dashboard, monitoring,
live logs, and remote access. The path is complete.
