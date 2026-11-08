---
name: app-ui-ux-patterns
description: >
  UI/UX design patterns for a consumer app's main interface: bottom tab-bar navigation
  for a mobile-first PWA, a design-token theming system that supports multiple visual
  styles times light/dark (not just one dark-mode toggle), sheet/modal conventions for
  editors and confirmations instead of full-screen navigation, and the hard rule
  against adding explanatory sub-text under every title/button (a UI smell that
  signals the design isn't self-evident). Use whenever designing or reviewing a tab
  bar, bottom navigation, a home/dashboard screen's layout, a modal/sheet/bottom-sheet
  component, a CSS custom-property theming setup, or any "should this have a caption
  under it" question — even if the user just says "make the nav" or "add dark mode"
  without naming a design system. Grounded in a real shipped implementation — see
  references/leitneria-example.md.
---

# Main-app UI/UX patterns

These are patterns for the primary, everyday-use surface of a consumer app — the
screens a user opens dozens of times, where speed of navigation and visual clarity
compound over every single session. This is a different design problem from an admin
panel (see the sibling `admin-panel-design` skill): here, every extra tap, every
unnecessary line of text, every visual inconsistency is felt at scale by real users,
not occasionally by an internal operator.

## 1. Bottom tab bar for the app's primary sections, not a hamburger menu

For a mobile-first (or mobile-primary) app with a small, fixed number of top-level
destinations (typically 3–5), a persistent bottom tab bar beats a hidden hamburger
menu or a top nav bar: every primary destination is always visible and reachable in
one tap, with no discovery cost. Each tab needs an icon (recognizable even before the
label is read) plus a short label — icon-only tab bars save space but cost
recognizability, especially for less-common destinations; keep both unless you have
strong evidence your specific icons are unambiguous to new users.

Keep the tab set to your actual top-level app sections, not every screen in the app —
a card editor, a settings page, a detail view are not tabs, they're navigated *into*
from within a tab (or from a sheet/modal — see below), and a tab bar item's active
state should reflect exactly one of your enumerated top-level screens at a time, not
try to track deep sub-navigation state.

## 2. Design tokens for theming, not hardcoded colors — and plan for more than one axis

If your app supports light/dark mode, don't hardcode colors anywhere in component
CSS — define a fixed set of semantic CSS custom properties once (`--bg`, `--surface`,
`--text`, `--text-2` for secondary text, `--accent`, `--line` for borders, `--ok`/
`--no` for success/error) and have every component reference only those tokens. This
makes a full theme swap a matter of redefining the token values in one place, with
zero component-level changes.

If your app might ever offer more than one *visual style* (not just light/dark —
e.g. a "clean/minimal" look vs. a "warm/studio" look, or a brand-refresh you want to
A/B), design the token system with **two independent axes** from the start: a style
attribute and a theme (light/dark) attribute, each combination defining its own full
token set (`[data-style="clean"][data-theme="dark"] { --accent: ...; }`). Retrofitting
a second style axis onto a theming system that only ever anticipated light/dark is
much more painful than designing for it up front, even if you only ship one style
initially — the cost of the extra axis when you don't need it yet is close to zero.

## 3. Sheets/modals for focused, in-context actions; full navigation for browsing

Use a bottom sheet or modal (appearing over the current screen, not replacing it) for:
editing a single record, a confirmation dialog, a short focused menu of actions, a
quick-add form. These are interruptions to a task the user is already doing — they
want to finish the sheet's action and return to exactly where they were, not lose
their place in a list they were browsing.

Reserve full screen-to-screen navigation (tab switch, or a genuine "detail page") for
actual **browsing** — moving from a list to an item's full detail view, or between
top-level sections. If you find yourself building a full-screen "editor" that the user
reaches by tapping something in a list and always immediately backs out of after one
edit, that's very likely better as a sheet.

## 4. Never caption a title, button, or option — if it needs an explanation, the label is wrong

A pervasive but easy-to-fall-into anti-pattern: adding a small gray line of
explanatory text underneath every heading, button, or settings option ("Cards as
rules/tips…", "What this does: …"). This is almost always compensating for an
unclear label rather than adding real value — and it compounds badly at scale,
because every screen in the app ends up half sub-text, visually noisy, and slower to
scan. The fix is nearly always to make the **label itself** self-evident (a better verb,
a clearer noun) rather than keeping a vague label and explaining it underneath.
Reserve genuine explanatory text for the rare case where a control's effect is
irreversible or non-obvious even with a good label (e.g. "This deletes X permanently"
next to a destructive action) — and even then, put it in a confirmation step, not
as permanent chrome under every instance of the control.

## 5. Timer-free, robust state transitions — never leave the UI in a stuck-looking state

Any transition that depends on a fixed timeout to "finish" (a fade-out that removes
an element after N milliseconds, a flip animation gated on `setTimeout`) is fragile:
a slow device, a backgrounded tab, or rapid repeated interaction can leave the UI
stuck mid-transition — invisible, half-faded, or showing stale content — because the
timer either fired too early relative to a real async operation, or the user moved on
before it fired at all. Prefer transitions driven by real state changes and CSS
transition/animation *end events* (or a state machine keyed off actual data readiness)
over a guessed timeout duration. If you must use a timer as a fallback safety net,
make sure the "real" completion path can also resolve the state independently, so the
timer is a backstop, not the only path to a resolved UI state.

## 6. Long content scrolls inside its container, not the page underneath it

If a card, panel, or sheet can contain arbitrarily long text (a long definition, a
long note), that text needs its own internal scroll region — don't let it push the
container's height and disrupt the surrounding layout, and don't let a scroll gesture
that starts inside that region accidentally scroll the whole page instead (or vice
versa) once the inner region hits its own scroll limit. Get the CSS overscroll
behavior right (chain to the page scroll once the inner content is exhausted, rather
than trapping the gesture or bubbling it unexpectedly) — this is a small detail users
never consciously notice when it's right, and immediately notice when it's wrong.

## Worked example

See `references/leitneria-example.md` for the exact token definitions across multiple
style×theme combinations, the tab bar markup, the sheet component's open/close
pattern, and the project's own explicit "never add sub-text" rule as stated by its
owner.
