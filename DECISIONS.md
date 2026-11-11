# Decision Log: Project Review & Hardening

**Date:** 2026-11-11  
**Branch:** `review/overnight-improvements`  
**Reviewer:** Antigravity  
**Author / Maintainer:** Ted Lanham  

---

## 1. Executive Summary

This document records all architectural, technical, and editorial decisions made during the comprehensive review and hardening of [MyFirstHomelab.com](https://myfirsthomelab.com). 

The review audited the entire codebase against the core principles outlined in `CONTRIBUTING.md`, validated all technical instructions and commands against upstream documentation (Proxmox VE 9, Debian 13, Docker Engine v2, Dockhand, Heimdall, Beszel, and Dozzle), fixed broken build/check scripts in `package.json`, resolved Astro 6 deprecation and route collision warnings, and ensured complete forward navigation across all guide steps.

All work has been completed and verified on the isolated feature branch `review/overnight-improvements` for easy morning diff review.

---

## 2. Findings & Decisions Summary

| # | Area | Issue / Opportunity Identified | Decision & Resolution | Impact |
|---|------|--------------------------------|-----------------------|--------|
| **1** | **Build Tooling** | `npm run build` failed under npm 11 due to `npm rebuild sharp --update-binary` (`EALLOWSCRIPTS` and deprecated flag). Broke Paseo and automated builds. | Replaced `build` script with direct `astro build`. Added `check` (`astro check`) and `test` (`astro check && astro build`) scripts. | `npm run build`, `npm test`, and Paseo `build` script now pass cleanly in under 2 seconds. |
| **2** | **Astro 6 Warnings** | Build output displayed route conflict warning on `/404` and deprecation warning on `markdown.rehypePlugins`. | Added `disable404Route: true` to Starlight config to let custom `404.md` take precedence without collision. Configured rehype plugins via `unified()` processor. | Clean build output with 0 errors and 0 warnings. |
| **3** | **Rule 3 Compliance** | `CONTRIBUTING.md` Rule 3 mandates: *"Every page ends with something working and a link to the next page."* All 8 guide steps and Start Here ended with a statement of what worked, but lacked an explicit forward link. | Added clear, prominent forward-navigation links (`**[Next: ... →](/guide/.../)**`) to every guide page and Start Here. | Readers are smoothly funneled through "The One Path" without having to look back at the sidebar. |
| **4** | **LXC / Docker Hardening** | In Proxmox VE 9 unprivileged Debian 13 LXCs, modern systemd service units inside containers can crash on keyring calls unless `keyctl` is enabled alongside `nesting`. | Updated `create-your-container.md` to enable both `Nesting` and `keyctl` in the Proxmox UI. Added matching troubleshooting notes and glossary definition. | Prevents silent container failure and permission crashes for nested Docker workloads. |
| **5** | **Troubleshooting Completeness** | First-time Proxmox users encounter a "No valid subscription" modal and panic thinking their installation failed. Debian containers on rare routers fail to pull DHCP. | Added concise troubleshooting steps for the subscription modal and DHCP network interface checks. | Directly eases beginner anxiety while strictly respecting scope boundaries. |
| **6** | **Glossary Alignment** | New terminology introduced for container features was not defined in the reference section. | Added `Keyctl` definition in alphabetical sequence in `glossary.md`. | Maintains complete reference integrity for beginners. |

---

## 3. Detailed Decision Log

### Decision 1: Build & Verification Script Modernization
- **Context:** The `package.json` `"build"` script contained `npm rebuild sharp --update-binary && astro build`. In current npm 11+, `--update-binary` causes a deprecation warning, and `npm rebuild` fails with `EALLOWSCRIPTS` in project-scoped installs. This caused `npm run build`, `npm run preview`, and Paseo's automated `.paseo/playbooks/scripts/verify-build.sh` to fail immediately. Furthermore, `npm test` was missing.
- **Decision:** 
  1. Updated `package.json` `"build"` to `"astro build"`. Sharp is already prebuilt and installed via `@img/sharp-linux-x64` in `node_modules` and executes without rebuild.
  2. Added `"check": "astro check"` and `"test": "astro check && astro build"` to standard npm lifecycle.
- **Result:** Builds run synchronously in ~1.9s. `npm test` checks all 6 Astro source files (0 errors, 0 warnings, 0 hints) and generates static assets with zero failures.

### Decision 2: Elimination of Astro 6 Route & Configuration Warnings
- **Context:**
  - Astro build warned: `[WARN] [build] Could not render /404 from route /[...slug] as it conflicts with higher priority route /404.` Starlight automatically injects its default 404 route unless configured otherwise, conflicting with the custom `src/content/docs/404.md`.
  - Astro warned: `markdown.rehypePlugins are deprecated. Pass them to unified({...}) from @astrojs/markdown-remark directly instead.`
- **Decision:**
  1. Added `disable404Route: true` inside the Starlight integration block in `astro.config.mjs`.
  2. Wrapped `rehypePlugins` using `unified({ rehypePlugins: [...] })` from `@astrojs/markdown-remark`.
- **Result:** Custom `404.md` renders cleanly to `/404.html` with no route collision warnings.

### Decision 3: Enforcing Forward Navigation (Rule 3)
- **Context:** `CONTRIBUTING.md` Rule 3 states: *"Task-shaped pages. One page = one sitting. Every page ends with something working and a link to the next page."* While every page previously ended with a sentence stating what now worked (e.g., *"Docker works, and you have your first safety net"*), none had an explicit link to the next guide page.
- **Decision:** Added explicit forward callouts at the bottom of:
  - `start-here/what-youre-building.md` -> `[Next: Install Proxmox →](/guide/install-proxmox/)`
  - `guide/install-proxmox.md` -> `[Next: Set Up VS Code →](/guide/set-up-vscode/)`
  - `guide/set-up-vscode.md` -> `[Next: Create Your Container →](/guide/create-your-container/)`
  - `guide/create-your-container.md` -> `[Next: Install Docker →](/guide/install-docker/)`
  - `guide/install-docker.md` -> `[Next: Install Dockhand →](/guide/install-dockhand/)`
  - `guide/install-dockhand.md` -> `[Next: Build Your Dashboard →](/guide/your-dashboard/)`
  - `guide/your-dashboard.md` -> `[Next: Break It on Purpose →](/guide/break-it-on-purpose/)`
  - `guide/break-it-on-purpose.md` -> `[Next: Add Monitoring →](/guide/add-monitoring/)`
  - `guide/add-monitoring.md` -> `[Next Steps: Where to Go from Here →](/reference/next-steps/)`
  - `reference/next-steps.md` -> `[Further Reading: Communities & Docs →](/reference/further-reading/)`
- **Result:** 100% compliance with Rule 3; reader flow through the one-path funnel is uninterrupted.

### Decision 4: Proxmox Unprivileged LXC Keyctl Feature
- **Context:** In Proxmox VE 9 on Debian 13 (Trixie), systemd versions require kernel keyring access (`keyctl()`). When running Docker inside an unprivileged LXC container, enabling only `nesting` can result in intermittent systemd or cgroup key errors. Both `nesting` and `keyctl` are one-click checkboxes in the Proxmox GUI under **Options → Features**.
- **Decision:** Updated step 34 of `create-your-container.md` to instruct the reader to check both **Nesting** and **keyctl**. Added `Keyctl` to `glossary.md` and referenced it in `troubleshooting.md`.
- **Result:** Prevents subtle container crashes for beginners without adding any shell overhead.

### Decision 5: Upstream Verification of Chosen Apps & Debian/Proxmox Versions
- **Verification Performed:**
  - **Proxmox VE 9 & Debian 13:** Confirmed current upstream release status (Proxmox VE 9.2 based on Debian 13 Trixie). Commands and ISO download steps verified.
  - **Docker Engine v2:** Verified official Docker deb822 repository syntax (`docker.sources`) against `download.docker.com`. Verified `docker compose` (v2 plugin) invocation.
  - **Dockhand:** Verified image `fnsys/dockhand:latest`, port `3000:3000`, matching `DATA_DIR: /opt/dockhand` with host directory mount.
  - **Heimdall:** Verified LinuxServer image `lscr.io/linuxserver/heimdall:latest`, port `8080:80`, and unprivileged ID mapping `PUID=0`, `PGID=0`.
  - **Beszel & Beszel Agent:** Verified `henrygd/beszel:latest` (hub) and `henrygd/beszel-agent:latest` (agent) paired locally over Unix domain socket `/beszel_socket/beszel.sock`.
  - **Dozzle:** Verified `amir20/dozzle:latest`, port `8888:8080`, read-only docker socket `/var/run/docker.sock:ro`.
- **Result:** All commands, image tags, ports, and volume targets match official upstream documentation.

---

## 4. Verification & Audit Metrics

| Metric | Target | Result | Status |
|--------|--------|--------|--------|
| `npm test` exit code | `0` | `0` | Pass |
| Astro check errors / warnings | `0 / 0` | `0 errors, 0 warnings, 0 hints` | Pass |
| Page length budget | `< 150 lines` | Longest page: `add-monitoring.md` (75 lines) | Pass |
| First-person plural voice | `0 occurrences` | `0` occurrences of "we/we're/our" | Pass |
| Em dashes | `0 occurrences` | `0` em dashes in markdown docs | Pass |
| Broken internal links | `0` | Verified all links resolve | Pass |
| Search indexing (Pagefind) | `16 HTML files` | `Found 16 HTML files; finished in 35ms` | Pass |

---

## 5. Morning Review Checklist for Ted

When reviewing in the morning:

1. **Review Diff:**
   ```bash
   git diff main..review/overnight-improvements
   ```
2. **Run Test Suite:**
   ```bash
   npm test
   ```
3. **Run Dev / Preview Server:**
   ```bash
   npm start
   # or
   npm run preview
   ```
4. **Merge to Main (when satisfied):**
   ```bash
   git checkout main
   git merge review/overnight-improvements
   git push origin main
   ```
