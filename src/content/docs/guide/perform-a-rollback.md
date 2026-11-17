---
title: Perform a Rollback
description: Delete your dashboard, restore a snapshot, and practice cloning your LXC.
sidebar:
  label: 10. Perform a Rollback
  order: 11
---

You are going to break your LXC on purpose. Knowing you can undo an experiment is what makes a homelab fun instead of scary.

## Delete the dashboard

1. Open Dockhand and select the `heimdall` stack.
2. Choose the stack's delete action. In the **Remove stack** dialog, leave **Delete files on disk** checked and choose **Remove**.
3. Open `http://LXC-IP`. The dashboard should be gone.

## Roll it back

1. In Proxmox, select your LXC and open **Snapshots**.
2. Select your most recent snapshot and choose **Rollback**.
3. Confirm that changes made after the snapshot will be discarded.
4. Wait for the rollback task to finish, then start the LXC. Proxmox always leaves it stopped after a rollback.
5. Reload `http://LXC-IP` and watch Heimdall return.

_❗ Rollback returns the LXC to the state at that snapshot and discards everything after it. A snapshot newer than the one you chose cannot be used afterwards: if Proxmox refuses with a message about more recent snapshots, delete those newer snapshots and roll back again. Keeping only the newest snapshot, as this guide does, avoids the situation._

The snapshot restored the LXC's filesystem and configuration to the moment you captured it.

## Clean up your snapshots

You should have finished the previous task with a single snapshot, `remote-access`. If the list shows more, select each older one and choose **Delete**. A snapshot holds space on the disk your LXC runs on, and an old one stops that disk reusing space, so keep only the state you would actually return to.

## Clone your working LXC

Stop the LXC, then choose **More <span class="ui-arrow" role="img" aria-label="then"></span> Clone**. Enter `docker-sandbox` for the hostname, keep the suggested CT ID, and choose **Clone**. Proxmox always makes a full clone of a normal LXC, so there is no clone mode to pick.

Keep the original stopped while you test the clone. A clone copies system
identity files along with the apps, so running both at once can cause a network
address conflict. Start the clone and find its address on its **Summary** page.
Open `http://` followed by that address to confirm Heimdall is there, then
stop the clone. Select it, choose **More <span class="ui-arrow" role="img" aria-label="then"></span> Remove**, type the
clone's CT ID into the confirmation box, and choose **Remove**. Then start the
original again.

Use a clone when you want to try a larger change without touching the original.

You have proved you can break something and get it back.
