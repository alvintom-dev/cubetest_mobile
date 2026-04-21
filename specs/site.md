# 🏢 Site Feature Specification

## 🎯 Purpose
Manage construction sites where test sets and tests are conducted.

---

## 🧩 Requirements

### 1. Create Site
User can create a site with:
- name (required)
- location (optional)
- notes (optional)

Validation:
- name must not be empty

---

### 2. View Site List
Display list of all sites.

Each item should show:
- site name
- number of test sets
- last test status (if available)

---

### 3. View Site Detail
Display:
- site information
- list of associated test sets

---

### 4. Update Site
User can edit:
- name
- location
- notes

---

### 5. Delete Site
User can delete a site.

Rule:
- Deleting a site should also remove all related test sets and tests (cascade delete)

---

## 🧱 Data Model

Site:
- id: String
- name: String
- location: String?
- notes: String?
- createdAt: DateTime

---

## 🔗 Relationships
- One Site → Many Test Sets

---

## 📌 Business Rules
- Site name is required
- Site must exist before creating test set