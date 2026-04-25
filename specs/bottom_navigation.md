# Bottom Navigation Bar Spec
## 🎯 Purpose
Provide fast and simple navigation across main sections of the Cube Test app.

---

## 🧭 Sections
Navigation bar contains 4 tabs:
- Sites (default)
- Tests (Recent & Upcoming)
- Dashboard
- Settings

---

## 🎨 Design
### Icon
- Icon only (no label, no tooltip text shown in UI)
- Must be clear and commonly understood
- Keep style consistent
- Selected icon must be visually distinguishable (color + optional slight scale)
- Icons must have semantic labels for accessibility (screen readers)

Suggested icons:
- Sites → location / building
- Tests → schedule / calendar
- Dashboard → dashboard / chart
- Settings → settings

### Colors
- Background: light color with subtle top shadow (low elevation)
- Selected icon: primary color (darker shade)
- Unselected icon: primary color (lighter shade)

---

## 🎞️ Interaction
- Tap to switch tab
- Transition must be fast and smooth
- No heavy animations

### Icon Feedback
- Small animation on select (scale or fade)
- Duration: ~150–200ms
- Animation must be subtle and not distract from navigation

---

## ⚡ Behavior
- Default tab: Sites
- Preserve page state when switching tabs
- No reload when switching
- Tab switching must NOT use route push/pop
- Must behave as persistent root navigation
- Switching tabs should feel instant (<100ms perceived delay)
- Maintain scroll position when switching tabs
- Tapping the currently active tab should have no effect
- Respect bottom safe area (no overlap with system navigation)

---

## 🧪 Current Page State (MVP)
- Sites → sites page
- Tests → Empty page
- Dashboard → “Upcoming Feature”
- Settings → Empty page

---

## 📌 Notes / Suggestions
- Provide visual tap feedback (e.g. ripple)
- Consider using IndexedStack to preserve state
- Ensure tap area is large enough (accessibility)
- Optional (future):
  - Badge for upcoming tests
  - Haptic feedback on tap
- Support deep linking to specific tab (future)

---