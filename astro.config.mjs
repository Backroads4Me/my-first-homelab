// @ts-check
import { defineConfig } from "astro/config";
import Icons from "starlight-plugin-icons";
import UnoCSS from "unocss/astro";
import starlightThemeSix from "@six-tech/starlight-theme-six";
import sitemap from "@astrojs/sitemap";
import rehypeExternalLinks from "rehype-external-links";

/** @type {NonNullable<import("@astrojs/starlight/types").StarlightUserConfig["sidebar"]>} */
const sidebar = [
  {
    label: "The Path",
    items: [
      { autogenerate: { directory: "start-here" } },
      { autogenerate: { directory: "guide" } },
    ],
  },
  {
    label: "Reference",
    items: [{ autogenerate: { directory: "reference" } }],
  },
];

// https://astro.build/config
export default defineConfig({
  site: "https://myfirsthomelab.com",
  output: "static",

  markdown: {
    rehypePlugins: [
      [rehypeExternalLinks, { target: "_blank", rel: ["noopener"] }],
    ],
  },

  integrations: [
    sitemap(),
    UnoCSS(),
    Icons({
      starlight: {
        title: "MyFirstHomelab",
        head: [
          {
            tag: "link",
            attrs: { rel: "sitemap", href: "/sitemap-index.xml" },
          },
          {
            tag: "link",
            attrs: {
              rel: "apple-touch-icon",
              sizes: "180x180",
              href: "/icons/apple-touch-icon.png",
            },
          },
          {
            tag: "link",
            attrs: { rel: "manifest", href: "/icons/site.webmanifest" },
          },
          {
            tag: "script",
            content:
              'document.addEventListener("DOMContentLoaded",()=>{for(const a of document.querySelectorAll(\'a[href^="http"]\'))if(a.hostname!==location.hostname){a.target="_blank";a.relList.add("noopener")}});',
          },
          {
            tag: "meta",
            attrs: {
              property: "og:image",
              content: "https://myfirsthomelab.com/og-default.png",
            },
          },
          {
            tag: "meta",
            attrs: { name: "twitter:card", content: "summary_large_image" },
          },
          {
            tag: "meta",
            attrs: {
              name: "twitter:image",
              content: "https://myfirsthomelab.com/og-default.png",
            },
          },
        ],
        plugins: [
          starlightThemeSix({
            footerText:
              'MyFirstHomelab • Your First Homelab Made Simple • <a href="/reference/about/">About</a> • Content licensed under <a href="https://creativecommons.org/licenses/by-sa/4.0/" target="_blank" rel="noopener">CC BY-SA 4.0</a>',
          }),
        ],
        customCss: ["./src/styles/custom.css"],
        favicon: "/icons/favicon.svg",
        logo: {
          src: "./public/logo.svg",
          replacesTitle: false,
        },
        lastUpdated: false,
        social: [
          {
            icon: "github",
            label: "GitHub",
            href: "https://github.com/Backroads4Me/my-first-homelab",
          },
        ],
        // starlight-plugin-icons 1.1.6 types autogenerate entries in the pre-0.39 form (label
        // required), which Starlight 0.39 rejects; the sidebar is checked against Starlight's
        // own type in `sidebar` above instead.
        sidebar: /** @type {any} */ (sidebar),
      },
    }),
  ],

  // Fail instead of moving to the next port, so a Paseo proxy never points at a stale port.
  vite: {
    server: { strictPort: true },
  },
});
