---
title: Connect Remotely
description: Reach your apps from anywhere with Tailscale and TSDProxy, without opening any ports.
sidebar:
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
`tsdproxy`. Paste this file, replace `PASTE-YOUR-AUTH-KEY` with your key, and
choose **Create & Start**:

```yaml
services:
  tsdproxy:
    image: almeidapaulopt/tsdproxy:2
    container_name: tsdproxy
    restart: unless-stopped
    environment:
      TSDPROXY_AUTHKEY: "PASTE-YOUR-AUTH-KEY"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./data:/data
    extra_hosts:
      - "host.docker.internal:host-gateway"
```

TSDProxy reads the labels through the Docker socket and reaches each app
through the port it already publishes. The `./data` folder keeps each app's
Tailscale identity, so the addresses survive restarts.

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
and `https://dozzle.` with the same ending. Heimdall's tiles still point to
your home addresses, so use these addresses when you are away. Proxmox itself
stays reachable only at home.

The auth key expires after 90 days. That only matters when you add a new app;
generate a new key then and replace it in the `tsdproxy` stack with **Save &
redeploy**.

In Proxmox, select the Debian container, open **Snapshots**, choose **Take
Snapshot**, enter `remote-access` in the **Name** field, and choose **Take
Snapshot**.

Your homelab now goes wherever your phone goes.
