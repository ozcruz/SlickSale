Loads only when editing UI files.

---

globs:

  - "lib/core/**"

  - "lib/features/*/presentation/**"

---

# Design System Rules

ALL visual styling MUST come from lib/core/theme.dart.

## What this means

- Colors: only from AppColors class

- Typography: only defined styles (Display 28/700, Heading 20/600,

  Subheading 16/600, Body 14/400, Caption 12/400, Overline 11/500)

- Spacing: only scale values (xs=4, sm=8, md=12, lg=16, xl=24,

  xxl=32, xxxl=48)

- Components: use defined Card, Button, TextField, Badge, ListTile

## What to never do

- No inline Color(0xFF...)

- No ad-hoc TextStyle() with custom sizes/weights

- No magic padding/margin numbers

- No new accent colors beyond the two defined (blue + green)

- No shadows, no gradients (except the subtle avatar backdrop)

If the design system doesn't have what you need, add it to

theme.dart following existing patterns. Don't inline it.
