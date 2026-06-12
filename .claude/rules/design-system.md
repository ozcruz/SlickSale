Loads only when editing UI files.

---

globs:

  - "lib/core/**"

  - "lib/features/*/presentation/**"

---

# Design System Rules

ALL visual styling MUST come from lib/core/theme.dart.

## Color palette (dark premium — Linear/Raycast aesthetic)

- Background base: #09090B

- Surface (cards, panels): #111114

- Elevated surface (hover, active): #18181B

- Input backgrounds: #0F0F12

- Border default: #27272A

- Border focus: #6366F1

- Primary: #6366F1 (indigo)

- Primary hover: #818CF8

- Primary muted: rgba(99,102,241,0.12)

- Success: #10B981

- Warning: #F59E0B

- Error: #EF4444

- Text primary: #FAFAFA

- Text secondary: #A1A1AA

- Text tertiary: #71717A

## Typography (Inter from Google Fonts)

- Display: 28px / weight 700

- Heading: 20px / weight 600

- Subheading: 16px / weight 600

- Body: 14px / weight 400

- Caption: 12px / weight 400

- Overline: 11px / weight 500, uppercase, 0.5px letter-spacing

## Spacing scale

xs=4, sm=8, md=12, lg=16, xl=24, xxl=32, xxxl=48

## Radii

sm=6px, md=8px, lg=12px, xl=16px, full=9999px

## Components

- Cards: surface bg, 1px border, 12px radius, 24px padding

- Buttons: 8px radius. Primary = filled indigo. Outline = transparent

  with border. Ghost = no border, text only.

- Inputs: input bg, 1px border, 8px radius, 10px 14px padding

- Badges: pill shape (full radius), muted bg + colored text

- Score colors: >=75 green, 50-74 yellow, <50 red

## What to never do

- No inline Color(0xFF...)

- No ad-hoc TextStyle() with custom sizes/weights

- No magic padding/margin numbers

- No new accent colors beyond primary (indigo) + success/warning/error

- No shadows, no gradients (except the subtle avatar backdrop)

If the design system doesn't have what you need, add it to

theme.dart following existing patterns. Don't inline it.
