# 🎨 Global UI / UX Specification

## 🎯 Purpose
Defines consistent UI behavior, layout rules, and screen patterns across the entire app.

This file is the single source of truth for:
- UI structure
- layout rules
- component usage
- UX patterns

It DOES NOT define implementation details (ThemeData, fonts, colors).

---

# 🧠 DESIGN PRINCIPLES

- Keep UI simple and functional
- Prioritize readability over visual decoration
- Maintain consistency across all screens
- Avoid unnecessary UI elements or complexity
- Reuse components instead of creating new UI variations

---

# 📐 DESIGN TOKENS (STRICT USAGE ONLY)

## Spacing System

Only use the following spacing values:

- 4px → tight spacing (icons, small gaps)
- 8px → compact spacing
- 12px → medium spacing
- 16px → default padding (MOST COMMON)
- 24px → section spacing

❌ No arbitrary spacing allowed

---

# 📱 PAGE STRUCTURE (MANDATORY)

Every screen MUST follow:

- Scaffold
- AppBar (title comes from ThemeData)
- Body (content area)
- Optional FloatingActionButton

❌ No exceptions unless explicitly approved

---

# 🧱 LAYOUT RULES

- Use ListView for vertical scrolling screens
- Use Column + Expanded for structured layouts
- Always wrap content with Padding (16px default)
- Avoid deeply nested widgets (>4 levels)
- Prefer flat and readable widget trees

---

# 🎨 THEME DEPENDENCY RULE (CRITICAL)

This UI layer MUST NOT define visual styling directly.

You MUST use ThemeData for:
- typography
- colors
- text styles
- icon colors

❌ Forbidden:
- TextStyle(fontSize: ...)
- Color(0xFF...)
- Hardcoded font weights

✔ Allowed:
- Theme.of(context).textTheme
- Theme.of(context).colorScheme

---

# 🔤 FONT RULE (CRITICAL)

The ONLY allowed font for the entire app is:

- Lexend Deca

## Implementation Rule

The font MUST be applied globally using GoogleFonts package:

- Use: google_fonts package
- Apply via ThemeData ONLY
- Do NOT apply GoogleFonts inside individual widgets

---

## ❌ FORBIDDEN

- GoogleFonts.lexendDeca() inside Text widgets
- Any manual fontFamily overrides
- Any fallback fonts

---

## ✔ REQUIRED APPROACH

Font MUST be defined once in ThemeData:

- via GoogleFonts.lexendDecaTextTheme()
- or equivalent ThemeData integration

All text MUST inherit from ThemeData automatically.

---

# 📐 TYPOGRAPHY USAGE RULE

All text styling MUST follow ThemeData.textTheme only.

## Allowed usage:
- headlineSmall → Titles
- titleMedium → Section headers
- titleSmall → Card titles / subtitles
- bodyMedium → Default text
- bodySmall → Secondary text
- labelSmall → Metadata

---

## ❌ FORBIDDEN

- TextStyle(fontSize: ...)
- TextStyle(fontWeight: ...)
- Any inline text styling

---

## PRINCIPLE

UI defines structure only.
Typography is fully controlled by ThemeData.

---

# 🧩 COMPONENT SYSTEM

## 🧾 Cards (STRICT)

All grouped content MUST use Card.

Rules:
- Border radius: 16
- Padding: 16
- Margin between cards: 12
- Elevation: 2–4 (low elevation only)
- Background: Theme surface color

---

## 🔘 Buttons

- Primary action → ElevatedButton
- Secondary action → OutlinedButton
- Max 2 primary buttons per screen

❌ No custom button styling unless reusable component

---

## 🧾 Inputs

- Use TextFormField only
- Must include label or hint
- Required validation must show clear error text
- No custom input widgets unless shared component

---

## 🏷️ STATUS SYSTEM (UNIFIED RULE)

This system applies to ALL status indicators.

### Allowed Status Types:
- Success (Passed / Open)
- Warning (Pending / Upcoming)
- Error (Failed / Overdue)

---

### Status Chip Rules

- Fully rounded pill shape
- Padding: 8 horizontal / 4 vertical
- Font size: 12–13
- Must use semantic status colors only
- Must include icon when applicable

---

### Status Visualization Rules

- Success → Green + check icon
- Warning → Orange + clock icon
- Error → Red + cross icon

❌ No alternative status styling allowed

---

# 📊 LIST ITEM DESIGN (STRICT)

Every list item MUST:

- Be wrapped in a Card
- Follow hierarchy:
    1. Title (primary, bold)
    2. Subtitle (secondary text)
    3. Status indicator (mandatory if applicable)

- Be tappable if navigation exists
- Maintain consistent spacing between items

---

# 📅 DATE DISPLAY RULES

- Format: "20 Apr 2026"
- Must be human-readable
- Overdue → Error color (red)
- Upcoming → Warning color (orange)

---

# 🧭 NAVIGATION RULES

- Use consistent navigation strategy 
  - goRouter MUST be used for all navigation.
  - Navigator.push should not be used unless explicitly required.
- Back navigation MUST always work
- Avoid deep or unnecessary navigation stacks
- Do not bypass standard routing flow

---

# 📌 DASHBOARD PATTERN (MANDATORY)

Dashboard screens MUST include:

1. Summary section (top cards)
2. Sectioned lists:
    - Upcoming items
    - Overdue items

---

# 🔁 REUSABILITY RULE (STRICT)

- Always reuse widgets from shared/widgets
- If a UI pattern appears 2+ times → MUST be extracted
- Do NOT duplicate UI implementations
- Prefer composable reusable widgets over inline UI

---

# 🚫 FORBIDDEN UI PRACTICES

- Arbitrary spacing values outside defined system
- Inline font sizes or weights
- Hardcoded colors
- Mixed UI styles across screens
- Overcrowded layouts
- Deep widget nesting (>4 levels)
- Duplicated UI logic

---

# 📐 CONSISTENCY RULE (CRITICAL)

All features MUST strictly follow:

- spacing system
- ThemeData typography
- ThemeData colors
- card design system
- button system
- status system
- Lexend Deca MUST be used for all text via ThemeData only

❌ Any deviation is NOT allowed unless explicitly approved.

---

# 🧠 FINAL PRINCIPLE

This UI system defines structure and behavior only.

All visual implementation details belong to ThemeData.

UI = HOW screens are structured  
Theme = HOW they look