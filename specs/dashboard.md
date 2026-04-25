# 📊 Dashboard Feature Specification

## 🎯 Purpose
Provide a quick overview of all test activities.

---

## 🧩 Requirements

### 1. Summary Metrics
Display:
- total active sites
- total active test sets
- overdue tests count
- upcoming tests count

---

### 2. Upcoming Tests
Show tests due within next 7 days.

Each item:
- site name
- test type
- due date

---

### 3. Overdue Tests
Show tests where:
- dueDate < today
- status = pending

Highlight:
- urgency

---

### 4. Recent Activity (optional)
Show recently updated tests.

---

## 📌 Business Rules
- Overdue tests have highest priority
- Upcoming = next 7 days only