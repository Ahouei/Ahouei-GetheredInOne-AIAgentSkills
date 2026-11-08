# Ahouei-GetheredInOne-AIAgentSkills

**One repository, 885 ready-to-install agent skills.** A curated set of 53 hand-picked skills (documents, design, mobile and iOS design, accessibility, React, testing, writing, productivity) plus 832 app-integration skills that let an agent work inside tools like Spotify, Slack, Stripe, Notion, HubSpot and hundreds more.

Everything is a plain folder with a `SKILL.md` file in it, so it works with any agent that supports the Claude Skills format. Claude Code is the primary target.

> **Status:** collected and organised, not independently audited or run end to end. Read [Security and trust](#security-and-trust) before installing the lot.

---

## Contents

- [At a glance](#at-a-glance)
- [Quick start](#quick-start)
- [How skills work](#how-skills-work)
- [The 53 curated skills](#the-53-curated-skills)
- [The 832 app-integration skills](#the-832-app-integration-skills)
- [Repository layout](#repository-layout)
- [Maintaining the collection](#maintaining-the-collection)
- [Security and trust](#security-and-trust)
- [Licensing and attribution](#licensing-and-attribution)
- [Provenance](#provenance)

---

## At a glance

| | Count | Needs an account? |
|---|---:|---|
| Curated skills: documents, design, mobile and iOS design, accessibility, React, dev tooling, writing, productivity | 53 | Mostly no |
| App-integration skills (`*-automation`) | 832 | Yes: a Composio account and the Rube MCP server |
| Support folder (`shared/`, read by the accessibility skills) | 1 | n/a |
| Slash commands that drive the mobile skills (`commands/`) | 5 | No |
| **Total skill folders** | **885** (+1 support folder) | |

Size on disk is about 21 MB, mostly fonts, templates and data files bundled with a few skills (`canvas-design`, `ui-ux-pro-max`, `theme-factory`, the document skills).

---

## Quick start

### Install everything

```bash
git clone https://github.com/Ahouei/Ahouei-GetheredInOne-AIAgentSkills.git
cd Ahouei-GetheredInOne-AIAgentSkills
scripts/install.sh                 # all skills -> ~/.claude/skills (every project)
```

Installing all 885 means the agent sees 885 skill descriptions at startup. If you do not use Composio, install the curated set instead:

```bash
scripts/install.sh --core          # the 53 curated skills (+ shared/) only
```

### Other ways to install

```bash
scripts/install.sh --project .                 # into ./.claude/skills for one project
scripts/install.sh frontend-design pdf xlsx    # only the skills you name
scripts/install.sh --dry-run --core            # preview, copy nothing
scripts/install.sh --force --core              # overwrite folders that already exist
scripts/install.sh --dest /some/path/skills    # any other skills directory
scripts/install.sh -- -21risk-automation       # folder names that start with a dash need "--"
```

The installer skips folders that already exist unless you pass `--force`. When you install any `accessibility-*` skill it also installs `shared/`, because those skills read `shared/methodology.md`.

### Manual install

A skill is just a folder. Copy the ones you want:

```bash
cp -R skills/frontend-design ~/.claude/skills/        # personal, all projects
cp -R skills/frontend-design ./.claude/skills/        # one project, can be committed
```

Start a new Claude Code session afterwards so the skills are picked up.

### Claude.ai and the API

The folders follow the standard skill layout, so they can also be zipped and uploaded as custom skills on Claude.ai or through the Skills API. Skills that run scripts or need an MCP server (see the notes per skill below) only work where those can run.

---

## How skills work

Each skill folder contains a `SKILL.md` with a short YAML header and the instructions:

```markdown
---
name: file-organizer
description: Intelligently organizes your files and folders ...
---
# File Organizer
...
```

The agent reads only the `name` and `description` of every installed skill up front. When a request matches a description, it loads the full `SKILL.md` and any files next to it (scripts, templates, reference documents). That keeps the context small until a skill is actually needed. Because the description decides when a skill triggers, you can also invoke one explicitly by asking for it by name.

---

## The 53 curated skills

### Documents and files (Anthropic)

| Skill | What it does |
|---|---|
| [`docx`](skills/docx) | Create, edit and analyse Word documents, including tracked changes, comments and formatting. |
| [`pdf`](skills/pdf) | Extract text and tables, create, merge, split and fill PDFs. |
| [`pptx`](skills/pptx) | Build and edit PowerPoint decks, layouts, notes and templates. |
| [`xlsx`](skills/xlsx) | Create and edit spreadsheets with formulas, formatting and analysis. |

> These four are **proprietary** (all rights reserved by Anthropic). See [Licensing](#licensing-and-attribution).

### Design, UI and UX

| Skill | What it does |
|---|---|
| [`frontend-design`](skills/frontend-design) | Aesthetic direction, typography and layout choices that avoid generic, templated UI. |
| [`ui-ux-pro-max`](skills/ui-ux-pro-max) | Searchable design database: styles, palettes, font pairings, UX rules, charts and stack-specific guidance, with a Python search tool. |
| [`bencium-controlled-ux-designer`](skills/bencium-controlled-ux-designer) | Accessible, disciplined UX guidance. Asks before making design decisions. |
| [`bencium-innovative-ux-designer`](skills/bencium-innovative-ux-designer) | Builds an original visual language through typography-led design directions. For differentiation, not routine UI fixes. |
| [`web-design-guidelines`](skills/web-design-guidelines) | Reviews UI code against the Web Interface Guidelines (accessibility, UX, best practices). |
| [`canvas-design`](skills/canvas-design) | Original visual art as PNG or PDF, with a bundled font library. |
| [`theme-factory`](skills/theme-factory) | Applies one of 10 preset themes (or a generated one) to slides, docs and landing pages. |
| [`brand-guidelines`](skills/brand-guidelines) | Applies Anthropic's brand colours and typography to artifacts. |
| [`artifacts-builder`](skills/artifacts-builder) | Scaffolds and bundles multi-component claude.ai HTML artifacts (React, Tailwind, shadcn/ui). |
| [`slack-gif-creator`](skills/slack-gif-creator) | Animated GIFs sized for Slack, with validators and animation primitives. |
| [`image-enhancer`](skills/image-enhancer) | Improves resolution, sharpness and clarity of images and screenshots. |

### Accessibility (AccessLint)

Five skills that cover the whole accessibility workflow against WCAG 2.2. They share one methodology file in [`shared/`](skills/shared).

| Skill | Role |
|---|---|
| [`accessibility-scan`](skills/accessibility-scan) | One page, automated: runs a rule engine on a live page and returns violations with selectors and source locations. |
| [`accessibility-inspect`](skills/accessibility-inspect) | One page, manual tier: keyboard, focus order, screen-reader names, reflow and zoom, target size. |
| [`accessibility-audit`](skills/accessibility-audit) | Whole site: samples pages per the WCAG-EM method and writes one conformance report. |
| [`accessibility-fix`](skills/accessibility-fix) | Applies fixes in a baseline, edit and verify loop. |
| [`accessibility-diff`](skills/accessibility-diff) | Regression check: which violations did your change add or fix. Usable as a CI gate. |

Scanning and inspecting need a Chrome the agent can drive and a live URL to test.

### React and mobile (Vercel)

| Skill | What it does |
|---|---|
| [`react-best-practices`](skills/react-best-practices) | React and Next.js performance rules from Vercel Engineering, ordered by impact. |
| [`composition-patterns`](skills/composition-patterns) | Compound components, render props, context providers, avoiding boolean-prop sprawl, React 19 changes. |
| [`react-native-skills`](skills/react-native-skills) | React Native and Expo performance and UI patterns: lists, animation, native modules. |

### Building, testing and debugging

| Skill | What it does |
|---|---|
| [`webapp-testing`](skills/webapp-testing) | Drives local web apps with Playwright: verify behaviour, capture screenshots, read browser logs. |
| [`mcp-builder`](skills/mcp-builder) | Guide to building good MCP servers. |
| [`skill-creator`](skills/skill-creator) | How to design, write and package new skills. Use this to extend the collection. |
| [`langsmith-fetch`](skills/langsmith-fetch) | Debug LangChain and LangGraph agents by fetching traces from LangSmith. |
| [`changelog-generator`](skills/changelog-generator) | Turns git history into a user-facing changelog. |
| [`developer-growth-analysis`](skills/developer-growth-analysis) | Reviews your recent Claude Code history for patterns and learning gaps. |

### Writing, research and communication

| Skill | What it does |
|---|---|
| [`content-research-writer`](skills/content-research-writer) | Research, citations, outlines and section-by-section feedback for long-form writing. |
| [`internal-comms`](skills/internal-comms) | Status reports, leadership updates, newsletters, FAQs and similar internal writing. |
| [`meeting-insights-analyzer`](skills/meeting-insights-analyzer) | Finds communication patterns and feedback in meeting transcripts. |
| [`tailored-resume-generator`](skills/tailored-resume-generator) | Tailors a resume to a specific job description. |
| [`twitter-algorithm-optimizer`](skills/twitter-algorithm-optimizer) | Rewrites tweets using insights from Twitter's open-source ranking algorithm. |

### Business and productivity

| Skill | What it does |
|---|---|
| [`lead-research-assistant`](skills/lead-research-assistant) | Finds and ranks target companies for your product, with outreach suggestions. |
| [`competitive-ads-extractor`](skills/competitive-ads-extractor) | Pulls competitors' ads from public ad libraries and analyses messaging. |
| [`domain-name-brainstormer`](skills/domain-name-brainstormer) | Generates domain ideas and checks availability across TLDs. |
| [`invoice-organizer`](skills/invoice-organizer) | Reads, renames and files invoices and receipts for tax time. |
| [`file-organizer`](skills/file-organizer) | Finds duplicates and reorganises messy folders. |
| [`raffle-winner-picker`](skills/raffle-winner-picker) | Fair random winner selection from lists or sheets. |
| [`video-downloader`](skills/video-downloader) | Downloads YouTube videos in chosen quality and format. Respect the platform's terms and copyright. |

### Design craft and motion

| Skill | What it does |
|---|---|
| [`premium-web-design`](skills/premium-web-design) | Awwwards-level sites: a named structural concept per site, typography as identity, deep reference research, verified 3D, scroll choreography, and a blacklist of AI-template tells. |
| [`emil-design-eng`](skills/emil-design-eng) | Design engineering in the spirit of Emil Kowalski: when to animate, custom easing, springs, press feedback, clip-path tricks, gesture physics and performance rules. |
| [`apple-design`](skills/apple-design) | Apple's fluid-interface principles for the web: response, interruptibility, springs, velocity handoff, momentum, materials, typography and the eight design principles. |
| [`app-ui-ux-patterns`](skills/app-ui-ux-patterns) | Main-app patterns: bottom tab bars, two-axis theme tokens, sheets for focused actions, and the rule against explanatory sub-text, with a worked example from Leitneria. |

### Mobile and iOS design

| Skill | What it does |
|---|---|
| [`ios-screens`](skills/ios-screens) | Builds iPhone screens that feel native in SwiftUI, UIKit, React Native, Expo or Flutter: tab bars, navigation, sheets, safe areas, Dynamic Type, dark mode, 44 pt targets. |
| [`ios-review`](skills/ios-review) | Reviews an existing iPhone screen or flow and lists what to fix, most important first. |
| [`ios-flows`](skills/ios-flows) | Plans multi-step iOS flows (onboarding, sign-in, paywall, permissions, cancellation, account deletion) from how real apps handle them. |
| [`mobile-design-system`](skills/mobile-design-system) | Bootstraps a design system for a brand-new mobile app: tokens, a full component catalogue as a living HTML style guide, and a two-screen concept. Follows Material 3, Apple HIG, or both. |
| [`mobile-release-check`](skills/mobile-release-check) | Checks a React Native, Flutter, Android or iOS project for store-rejection and security problems before release. Ships a Python checker. |

The `ios-*` skills can optionally connect to UXKIN's MCP server for real app screens and journeys; they work without it.

Matching slash commands live in [`commands/`](commands): `onboarding`, `paywall` and `review-screen` (for the iOS skills), and `mobile-check` and `mobile-release` (for the release check). Copy a folder's `.md` files into `~/.claude/commands/` to use them as `/onboarding`, `/paywall` and so on.

### Connecting to apps

| Skill | What it does |
|---|---|
| [`connect`](skills/connect) | Lets the agent take real actions in Gmail, Slack, GitHub and similar apps through Composio. |
| [`connect-apps`](skills/connect-apps) | Variant of the above, triggered by requests to send, create or post in external services. |
| [`skill-share`](skills/skill-share) | Creates a new skill and shares it to Slack through Rube. |

`connect` and `connect-apps` overlap heavily. Keep one if you want fewer competing triggers.

---

## The 832 app-integration skills

Every folder ending in `-automation` is a skill for one service: Spotify, Slack, Stripe, Notion, HubSpot, Shopify, Cloudflare, Google Drive, Salesforce, Ahrefs, Apify and so on. Each one documents the service's tools, parameters, common workflows and known pitfalls, so the agent can call them correctly instead of guessing.

**What you need:**

1. A [Composio](https://composio.dev) account.
2. The Rube MCP server added to your agent: `https://rube.app/mcp`.
3. Authorise each service the first time you use it. The agent gives you a link.

Without those, the skills load but cannot do anything.

**Good to know:**

- They tell the agent to search for current tool schemas first, because the toolkits change.
- They act on **your real accounts** (send email, post messages, charge cards, delete records). Use them deliberately, and do not install ones you will never use.
- Some services appear twice, once with an underscore and once with a hyphen (for example `docker_hub-automation` and `docker-hub-automation`). That comes from the source collection and is kept intact.
- Two folder names begin with a dash (`-21risk-automation`, `-2chat-automation`). Use `--` before them in shell commands.

Browse the complete list with descriptions in [`docs/CATALOG.md`](docs/CATALOG.md).

---

## Repository layout

```
.
├── README.md
├── NOTICE.md                  Sources, licenses and attribution
├── skills/                    886 folders: 885 skills + shared/
│   ├── <skill-name>/
│   │   ├── SKILL.md           Required: name, description, instructions
│   │   └── ...                Optional scripts, templates, references
│   └── shared/                Support files, not a skill
├── docs/
│   └── CATALOG.md             Generated table of every skill
├── commands/                  Slash commands for the mobile skills
└── scripts/
    ├── install.sh             Copy skills into a skills directory
    ├── validate.py            Structure checks for every skill
    └── generate_catalog.py    Rebuilds docs/CATALOG.md
```

---

## Maintaining the collection

```bash
python3 scripts/validate.py          # every skill has SKILL.md, a description, no broken symlinks
python3 scripts/generate_catalog.py  # refresh docs/CATALOG.md after adding or removing skills
```

To add a skill, create `skills/<name>/SKILL.md` (the `skill-creator` skill in this repo walks you through writing a good one), run both commands, update the counts in this README, and add the source to [`NOTICE.md`](NOTICE.md).

---

## Security and trust

A skill is instructions plus, sometimes, scripts the agent will run. Treat installing one like installing a dependency.

- **Review before you install**, especially skills that ship scripts: `mobile-release-check`, `artifacts-builder`, `docx`, `pdf`, `pptx`, `xlsx`, `mcp-builder`, `skill-creator`, `slack-gif-creator`, `ui-ux-pro-max`, `video-downloader`, `webapp-testing`.
- **Prefer a small install.** `--core` or named skills expose far less than all 885.
- **Integration skills touch real accounts** through a third-party gateway. Only connect services you intend to automate, and use the narrowest permissions the service offers.
- **Content comes from third parties** (see below) and is bundled as found. It was not security-reviewed here.
- Pin to a commit if you rely on this repository, since skills can change on `main`.

---

## Licensing and attribution

This repository is a **collection**. It does not relicense anything: each skill keeps the terms of the place it came from, and the license files that shipped with a skill are preserved in its folder. The full source table is in [`NOTICE.md`](NOTICE.md). In short:

| Group | Source | License |
|---|---|---|
| `artifacts-builder`, `brand-guidelines`, `canvas-design`, `frontend-design`, `internal-comms`, `mcp-builder`, `skill-creator`, `slack-gif-creator`, `theme-factory`, `webapp-testing` | Anthropic example skills | Apache-2.0 (license file in each folder) |
| `docx`, `pdf`, `pptx`, `xlsx` | Anthropic document skills | **Proprietary, all rights reserved.** Governed by the `LICENSE.txt` in each folder. Check that it allows your use, and consider removing these four from any public fork. |
| `web-design-guidelines`, `react-best-practices`, `composition-patterns`, `react-native-skills` | Vercel (`vercel-labs/agent-skills`) | MIT |
| `ui-ux-pro-max` | `nextlevelbuilder/ui-ux-pro-max-skill` | MIT |
| `bencium-controlled-ux-designer`, `bencium-innovative-ux-designer` | `bencium/bencium-claude-code-design-skill` | MIT |
| `accessibility-*`, `shared` | AccessLint (`accesslint/claude-marketplace`) | MIT |
| `ios-screens`, `ios-review`, `ios-flows`, `commands/mobile-app-design` | UXKIN (`uxkin/agent`) | MIT (license file in each folder) |
| `mobile-design-system` | rikucherry1993 (`rikucherry1993/mobile-design-system-skill`) | MIT (license file in the folder) |
| `mobile-release-check`, `commands/mobile-release-check` | Stefan Petrovici | MIT (license file in each folder) |
| `premium-web-design`, `emil-design-eng`, `apple-design`, `app-ui-ux-patterns` | Ahouei's own skills | Published by the owner. No license file; ask before reusing outside this collection. |
| Other curated skills and all `*-automation` skills | Composio's *Awesome Claude Skills* collection | Apache-2.0 for the collection. Individual skills may differ, so check each folder. |

MIT and Apache-2.0 both require keeping the copyright and license notices. The upstream `LICENSE` text for the MIT sources is not copied into every folder, so keep the attribution above and in `NOTICE.md` if you redistribute.

---

## Provenance

- **Base collection:** the contents of the `skills/` directory of [Ahouei/Telegram-Music-App](https://github.com/Ahouei/Telegram-Music-App) (commit "Skills Added"), which is a copy of Composio's Awesome Claude Skills. Container folders were flattened: the four document skills moved out of `document-skills/` and the 832 integration skills out of `composio-skills/`. The blank `template-skill` was left out.
- **UI/UX additions:** the skills named in Snyk's article [Top Claude skills for UI/UX engineers](https://snyk.io/articles/top-claude-skills-ui-ux-engineers/), each fetched from the repository the article links to.
- **Left out on purpose:** the AccessLint reviewer agent and MCP server (they are not skills), the other skills in the Bencium repository, and the community lists the article links to.
