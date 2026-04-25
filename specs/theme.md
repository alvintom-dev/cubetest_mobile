# 🎨 Theme Specification (Flutter Implementation Layer)

## 🎯 Purpose
Defines how the UI system is implemented using Flutter ThemeData.

This includes:
- Google Font (Lexend Deca)
- Typography system
- Color system
- Component themes

---

# 🔤 FONT SYSTEM (MANDATORY)

## Primary Font

- Font Family: Lexend Deca
- Source: GoogleFonts package

---

## IMPLEMENTATION RULE

The ONLY allowed implementation is:

```
ThemeData(
  textTheme: GoogleFonts.lexendDecaTextTheme(
    Theme.of(context).textTheme,
  ),
)
```

## ❌ FORBIDDEN
- Using GoogleFonts inside widgets
- Setting fontFamily manually
- Mixing multiple fonts
- Overriding font per screen
- TextStyle() anywhere in UI layer
- overriding fontSize directly in widgets

## ✅ ONLY ALLOWED
- Theme.of(context).textTheme.*

# 📐 TYPOGRAPHY SYSTEM (STRICT MAPPING)
This defines how Flutter TextTheme maps to UI spec.

## 🧾 Headings
### headlineSmall
- Use headlineSmall only once per screen (primary title)
- screen-level identity (top of page)
- Size: 16
- Weight: 700
- Usage:
  - Page titles
  - Main headers

### titleMedium
- Use titleMedium for major sections within a screen
- section grouping inside screen
- Size: 14
- Weight: 600
- Usage:
  - Section headers

### titleSmall
- Use titleSmall for repeated UI items (cards, list items)
- item-level grouping
- Size: 13
- Weight: 600
- Usage:
  - Card titles
  - Item titles
  
## 🧾 Body Text
### bodyMedium (DEFAULT TEXT)
- Use bodyMedium for all primary readable content
- Size: 13
- Weight: 400
- Usage:
  - Normal content
  - Descriptions

### bodySmall
- Use bodySmall only for secondary or supporting text
- Size: 12
- Weight: 400
- Usage:
  - Secondary text
  - Hints

## 🏷️ Metadata
### labelSmall
- Use labelSmall only for metadata or system information
- Size: 12
- Weight: 400
- Usage:
  - Dates
  - Small labels
  - System metadata
