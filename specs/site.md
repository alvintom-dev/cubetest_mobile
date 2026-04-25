# 🏢 Site Feature Specification

## 🎯 Purpose
Manage construction sites where test sets and tests are conducted.

---

## 🧩 Requirements

### 1. Create Site
User can create a site with:
- name (required)
  - location (optional)
  - description (optional)
  - status (default as open, options are open/close)

Validation:
- name must not be empty

---

### 2. View Site List
Display list of all sites.

Each item should show:
- site name
  - number of test sets
  - status

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
  - description
  - status

---

### 5. Delete Site
User can delete a site.

Rule:
- Deleting a site should also remove all related test sets and tests (cascade delete)

Mechanism:
- Deleted sites will be marked as deleted and moved to archived.
  - The data will be deleted if user explicitly delete the site from archive.

---

## 🧱 Data Model

Site:
- id: String
  - name: String
  - location: String?
  - description: String?
  - status: enum(open, close)
  - createdAt: DateTime
  - updatedAt: DateTime
  - deletedAt: DateTime
  - isDeleted: bool
  - test sets: int 
    - default value 0, we will add this after we implement the test_set spec later
    - get from number of associated test linked to the site.id
    - override in repository 
    - get from test local datasource totalTestSetsBySitId

---

## 🔗 Relationships
- One Site → Many Test Sets

---

## 📌 Usecases
- CreateSite -> create new site
- GetSites -> get site list exclude the deleted sites
- GetSite -> get single site with detail
- UpdateSite
- DeleteSite -> must provide parameter for isPermanentDelete

---

## 📌 Business Rules
- Site name is required
  - Site must exist before creating test set