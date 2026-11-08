# Worked example: Leitneria (Ahouei-FlashCards) main-app UI/UX

A real, shipped mobile-first PWA (flashcards + grammar curriculum + AI dictionary).
Single-file `index.html`, all CSS via custom properties, no framework.

## The hard rule against sub-text — stated verbatim by the project owner

The project's own `CLAUDE.md` opens with this as its single highest-priority,
owner-mandated UI rule, ahead of everything else in the file:

> ⛔ **HARD UI RULE (owner-mandated, do NOT violate):** Never add explanatory
> sub-text / helper notes / descriptions underneath a title, label, button, or
> option in the UI — no "Cards as rules/tips…", no "what this does" captions.
> Titles/options stand alone. This includes hints sourced from our conversation.
> The only exception is when the owner *explicitly* asks for a description in a
> specific spot. When in doubt, leave it out.

This came from real, repeated friction — a design that kept accreting small gray
explanatory lines under every button/option, making every screen visually noisier and
slower to scan, when the actual fix was almost always a clearer label instead.

## Two-axis theming: style × light/dark, not just one theme toggle

```css
[data-style="clean"][data-theme="light"]{
  --bg:#f4f4f6; --bg-2:#ececef;
  --surface:#ffffff; --surface-2:#f7f7f9; --surface-3:#eeeef1;
  --text:#16161a; --text-2:#5b5b63; --text-3:#6f6f7a;
  --line:#e4e4e9; --line-2:#d6d6dd;
  --accent:#d9622b; --accent-ink:#fff; --accent-soft:rgba(217,98,43,.10); --accent-2:#c8541f;
  --shadow:0 14px 34px -18px rgba(20,16,12,.30);
  --ok:#2fae72; --ok-soft:rgba(47,174,114,.12);
  --no:#e5544b; --no-soft:rgba(229,84,75,.12);
}
[data-style="clean"][data-theme="dark"]{
  --bg:#0d0d10; --bg-2:#141417;
  --surface:#18181c; --surface-2:#202025; --surface-3:#2a2a30;
  --text:#f3f3f5; --text-2:#a3a3ad; --text-3:#797985;
  --accent:#f0743a; --accent-ink:#1a0f08; --accent-soft:rgba(240,116,58,.14); --accent-2:#ff8147;
  --ok:#3cc285; --no:#f0635a;
  /* ... */
}
[data-style="studio"][data-theme="light"]{
  --bg:#eef0f6; --bg-2:#e6e9f2;
  --surface:rgba(255,255,255,.91); --surface-2:rgba(255,255,255,.75); --surface-3:rgba(255,255,255,.6);
  --accent:#e0662b; --accent-ink:#fff;
  --shadow:0 22px 50px -22px rgba(60,55,80,.30);
  /* semi-transparent surfaces + a softer, warmer palette -- a genuinely different visual identity,
     not just a recolor, selected independently of light/dark */
}
```
Every component's CSS references only the semantic token names (`var(--surface)`,
`var(--text-2)`, `var(--accent)`) — never a literal hex value — so both axes
(`data-style` and `data-theme` attributes on the root element) can be changed
independently, at runtime, with zero component-level CSS changes. Three tiers of
surface elevation (`--surface`/`--surface-2`/`--surface-3`) and three tiers of text
emphasis (`--text`/`--text-2`/`--text-3`) give components a consistent vocabulary for
"how prominent should this be" without inventing a new shade per component.

## Bottom tab bar — icon + label, active-state driven by one enumerated screen name

```html
<nav class="tabbar">
  <button class="tab active" data-screen="home">
    <svg viewBox="0 0 24 24" ...>...</svg>
    <span class="lab" data-i18n="nav_home">Start</span>
  </button>
  <button class="tab" data-screen="learn">...<span class="lab" data-i18n="nav_learn">Lernen</span></button>
  <button class="tab" data-screen="quiz">...<span class="lab" data-i18n="nav_quiz">Quiz</span></button>
  <!-- Home · Learn · Quiz · Cards -- 4 top-level destinations, matches the app's
       actual primary sections, not every screen (card editors, settings, and topic
       detail views are all reached FROM inside these tabs, never tabs themselves) -->
</nav>
```
```js
function switchScreen(name) {
  // sets curScreen, toggles .active on the matching .tab button + shows the
  // matching .screen section — a single enumerated `name` drives both, so the
  // tab bar's visual active state can never drift out of sync with what's
  // actually rendered
}
```
Each label carries a `data-i18n` key rather than hardcoded text — the app is
localized (German/English/Persian with full RTL support), so every UI string,
including tab labels, routes through a translation lookup rather than being
literal text in the markup.

## Sheets for focused actions — a single reusable `openSheet(html)` primitive

```js
function openSheet(html) {
  // renders `html` into a bottom-sheet container with a standard header
  // (title + close button), overlays the current screen without navigating
  // away from it, and is closed by closeSheet() -- used for: card editors,
  // confirmation dialogs ("delete this?"), the AI menu, bulk-action menus,
  // deck creation, and more -- one component, many contents
}
```
Editing a single flashcard, confirming a deletion, picking an AI action — all of these
open as a sheet over whatever screen the user was already on (a card list, a study
session), and closing the sheet returns them to exactly that state, never navigating
them away from their place in a list.

## Timer-free card-flip transition — a real bug this fixes

The project's own architecture notes flag this explicitly as a lesson learned:
> Card advance must be **timer-free / robust** — never leave a card stuck
> invisible (the old `swap-out` opacity-timer caused flashing). Prefer simple over
> clever.
The original implementation faded a card out via a fixed-duration CSS opacity
transition, then swapped content via a `setTimeout` matched to that duration. Under
rapid repeated interaction (fast tapping through cards) or on a slower device, the
timeout and the actual animation could desync, leaving a card invisible (faded out,
next content not yet swapped in) for a beat — visually read as "the app froze." Fixed
by driving the swap off the actual interaction state rather than a guessed timer
duration.

## Long text scrolls inside its own container

```css
.facebody { overflow-y: auto; overscroll-behavior: auto; /* ... */ }
```
A flashcard's text content (`.facebody`) scrolls internally when it overflows the
card's fixed height, and `overscroll-behavior: auto` deliberately lets the scroll
gesture chain to the page once the inner content's scroll is exhausted, rather than
either trapping the gesture inside the card or having it silently do nothing at the
boundary — and critically, scrolling inside the card must not also trigger the card's
flip gesture, since both live on the same tappable/swipeable surface.
