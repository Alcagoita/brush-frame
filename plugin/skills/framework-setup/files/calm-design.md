# The calm design: a starting look

Use this for a first-look mockup, or a first design, when the person hasn't described a look of their own. It is Brush's design, the app Brush Frame was proven on: calm, warm, uncluttered. It's a base, not a rule. Their taste wins, and the design can grow into anything from here.

## Colours

| Token | Light | Dark | Use |
|---|---|---|---|
| `bg` | `#fdfcfa` | `#0e0e0c` | Page background |
| `surface` | `#f4f2ed` | `#232321` | Cards, grouped rows |
| `surface2` | `#ece9e2` | `#2c2c2a` | Icon tiles, pressed rows |
| `line` | `rgba(40,33,20,0.08)` | `rgba(255,255,255,0.13)` | The only separator: 1px lines |
| `text` | `#1f1c16` | `#f6f5f2` | Text |
| `muted` | `#8b857a` | `#96968f` | Secondary text, labels |
| `faint` | `#c1bbac` | `#6e6e69` | Hints, disabled |
| `accent` | `#e8a86a` | `#d4955a` | The one colour: the main action, what's happening now |

Text on an accent surface is white. Use the accent for one thing per screen.

## Type

- **Geist** (Google Fonts), falling back to the system font. Weights 400, 500 and 600 only.
- Sizes: page title 28–32, section title 18–20, body 15–16, labels and notes 13.
- Numbers that change (counts, times, prices) use tabular figures.
- Sentence case everywhere. No ALL CAPS.

## Shape and space

- **No shadows.** Depth comes from the surface colours and 1px lines.
- Corners: cards 16–18, buttons 12–14, small tiles 10.
- Space in steps of 4; a page margin of 22. Generous: let things breathe.
- One clear main action per screen, at the bottom on a phone.
- Icons are simple line icons, never emoji.

## Voice in the mockup

- Calm, warm and short. No pressure: nothing is late, overdue or failed. Things are waiting, or done.
- Questions over labels ("What do you need?", not "Add item").
- Use their idea's real words for the content, never lorem ipsum.

## What to make

- **Phone app:** a phone frame (about 390 × 844), the first screen they'd see, and one more if it helps tell the idea.
- **Website:** a browser frame, the top of the main page.
- Mark it **"A first look. Nothing is built yet."** in small `muted` text under the frame.
- One self-contained HTML file; the font is the only thing loaded from outside.
