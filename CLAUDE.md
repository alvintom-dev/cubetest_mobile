# 🧱 Cube Test App — Claude Code Architecture Rules

## ⚠️ PURPOSE
This file defines strict architecture rules for generating and modifying Flutter code in this project. All AI-generated code MUST follow these rules.

---

# 🚨 GLOBAL RULES (NON-NEGOTIABLE)

- You MUST strictly follow this architecture.
- You MUST NOT introduce alternative folder structures.
- You MUST NOT mix UI, business logic, and data layers.
- You MUST NOT create random folders (e.g. utils, helpers inside features).
- If something does not fit the structure, STOP and ask first.
- Consistency is more important than speed.

---

# 📁 PROJECT STRUCTURE (MANDATORY)

lib/
├── main.dart
├── app.dart
├── core/
├── features/
│   ├── site/
│   ├── test_set/
│   ├── test/
│   └── dashboard/
├── shared/
├── services/
└── config/

---

# 🧩 FEATURE STRUCTURE (MANDATORY)

Every feature MUST follow this structure:

features/<feature_name>/
├── data/
│   ├── models/
│   ├── datasource/
│   └── repository/
│
├── domain/
│   ├── entities/
│   ├── repository/
│   └── usecases/
│
└── presentation/
    ├── pages/
    ├── widgets/
    └── state/

---

# 📌 LAYER RESPONSIBILITY RULES

## 🎨 presentation/
ONLY UI code:
- Pages (screens)
- Widgets
- State management (Provider / Bloc / Riverpod UI logic)

❌ No API, no business logic, no database

---

## 🧠 domain/
ONLY business logic:
- Entities (pure models)
- Use cases
- Repository interfaces

❌ No Flutter UI, no API calls, no DB code

---

## 💾 data/
ONLY data handling:
- API calls
- Local database logic
- Repository implementations
- Data models (DTOs)

❌ No UI, no business rules

---

# 🔁 SHARED MODULE RULES

## shared/
ONLY reusable UI components:
- Buttons
- Cards
- Inputs
- Loading indicators

❌ No business logic allowed

---

## services/
ONLY external integrations:
- API clients
- Notification service
- Local storage service
- Third-party SDK wrappers

---

## core/
ONLY global system utilities:
- Constants
- Themes
- Base classes
- Utility functions

---

## config/
ONLY configuration:
- Routing
- Dependency injection
- Environment setup

---

# 🚫 FORBIDDEN PRACTICES

You MUST NOT:
- Mix layers in one file
- Skip domain layer
- Put models inside presentation/
- Create "utils/" inside features
- Duplicate logic across features
- Bypass feature structure

---

# 📍 FILE PLACEMENT RULE (CRITICAL)

| Type | Location |
|------|----------|
| UI Screen | presentation/pages |
| UI Component | presentation/widgets |
| State | presentation/state |
| Business Logic | domain/usecases |
| Entity | domain/entities |
| API / DB | data/datasource |
| Model | data/models |
| Repository Impl | data/repository |
| Shared UI | shared/widgets |
| External Service | services/ |

---

# 🧠 BEHAVIOR RULES

- If unsure → ASK before creating code
- Never guess architecture
- Never simplify by breaking structure rules
- Always follow strict feature boundaries
- Prefer modular design over shortcuts

---

# 🚀 PROJECT START RULE

When starting any new feature or task:

1. Scaffold folder structure first (if missing)
2. Create empty files first
3. Implement feature step-by-step
4. Never generate full app in one pass

---

# 📌 ENFORCEMENT RULE

Any deviation from this architecture MUST be explicitly justified and approved before implementation.