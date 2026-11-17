---
title: Set Up Your Computer
description: Install VS Code and create the SSH key that connects you to your LXC.
sidebar:
  label: 1. Set Up Your Computer
  order: 2
---

Everything you type in this guide is typed here, on the computer you already use, which the guide calls your **everyday computer**. The old PC becomes the server, and once Proxmox is installed on it you manage it from a browser instead of typing on it.

_❗ This guide asks you to copy commands from a website and run them with full control of your systems. They are based on each project's official documentation, but you do **not** have to take that on trust. When a command is unclear, paste it into an AI chat such as [Claude](https://claude.ai) or [ChatGPT](https://chatgpt.com) and ask what it does and whether it is safe. Do the same with every other guide you follow._

## Install VS Code and Remote - SSH

Download [Visual Studio Code](https://code.visualstudio.com/download), run the installer for Windows, macOS, or Linux, and open it. Skip the download if you already have VS Code.

Open **Extensions** from the side bar, search for **Remote - SSH** by Microsoft (`ms-vscode-remote.remote-ssh`), and select **Install**. This is the only extension you need.

_📌 Prefer your own terminal? No problem. Nothing in this guide depends on VS Code specifically._

## Create your key

Open **Terminal <span class="ui-arrow" role="img" aria-label="then"></span> New Terminal** inside VS Code, and run:

```bash
ssh-keygen -t ed25519
```

Press Enter three times: once to accept the default file, then twice to leave the passphrase empty. If the default file already exists, answer `n` when asked whether to overwrite it. Your existing key will work.

Your key is ready, and the VS Code terminal you just opened is where every command in the rest of the guide runs.
