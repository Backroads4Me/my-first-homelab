---
title: Break It on Purpose
description: Delete your dashboard, restore a snapshot, and practice cloning your LXC.
sidebar:
  label: 8. Break It on Purpose
  order: 9
---

You are going to break your LXC on purpose. Knowing you can undo an experiment is what makes a homelab fun instead of scary.

## Delete the dashboard

1. Open Dockhand and select the `heimdall` stack.
2. Choose the stack's delete action. In the **Remove stack** dialog, leave **Delete files on disk** checked and choose **Remove**.
3. Open `http://LXC-IP:8080`. The dashboard should be gone.

## Roll it back

1. In Proxmox, select your LXC and open **Snapshots**.
2. Select `working-dashboard` and choose **Rollback**.
3. Confirm that changes made after the snapshot will be discarded.
4. Wait for the rollback task to finish, then start the LXC. Proxmox always leaves it stopped after a rollback.
5. Reload `http://LXC-IP:8080` and watch Heimdall return.

The snapshot restored the LXC's filesystem and configuration to the moment you captured it.

## Clone your working LXC

Stop the LXC, then choose **More <span class="ui-arrow" role="img" aria-label="then"></span> Clone**. Enter `docker-sandbox` for the hostname, keep the suggested CT ID, and choose **Clone**. Proxmox always makes a full clone of a normal LXC, so there is no clone mode to pick.

Keep the original stopped while you test the clone. A clone copies system
identity files along with the apps, so running both at once can cause a network
address conflict. Start the clone and find its address on its **Summary** page.
Open `http://` followed by that address and `:8080` to confirm Heimdall is
there, then stop the clone. Select it, choose **More <span class="ui-arrow" role="img" aria-label="then"></span> Remove**, type the
clone's CT ID into the confirmation box, and choose **Remove**. Then start the
original again.

Use a clone when you want to try a larger change without touching the original.

You have proved you can break something and get it back.
