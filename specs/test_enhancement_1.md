# 📅 Test Enhancement 1 Specification

## 🎯 Purpose
Refine test result structure to better represent real-world cube testing, where each test consists of **3 cube samples per result set**, and improve calculation clarity.

---

## 🧩 Changes Overview

### ✅ Key Improvements
- Each **CubeResultSet** represents a **set of 3 cube results**
- Strength is captured per cube (not per result)
- Average strength is calculated per result set
- Test-level average strength is removed
- Status requirement simplified (minimum 1 result set)
- Improved naming clarity for long-term scalability
- Manage Result UI updated to support 3-cube input

---

## 1. 🧱 Updated Data Model

### CubeResultSet (Renamed from TestResult)
Represents **one cube result set (3 cubes)**

- id: String
- testId: String

#### Load (Optional)
- load1: double?
- load2: double?
- load3: double?

#### Strength (Required)
- strength1: double
- strength2: double
- strength3: double

#### Derived
- averageStrength: double (computed)

#### Other
- notes: String?
- createdAt: DateTime?
- updatedAt: DateTime?

---

## 2. 📊 Result Calculation

### Average Strength (Per Result Set)

Average Strength = (strength1 + strength2 + strength3) / 3

#### Rules
- Always calculated automatically
- Not editable by user
- Must be displayed in UI (Result List Item)
- Should be recalculated instantly when user edits any strength field

---

## 3. 👁️ UI Changes

### 3.1 Test Result List
Each item should display:
- strength1, strength2, strength3
- averageStrength (primary value)
- optional: load values
- notes (if any)

> Note:
> UI label can still use **"Result"** for simplicity.
> Internal naming uses **CubeResultSet** for clarity.

---

### 3.2 Manage Test Result Page (Create / Edit)

#### Input Structure

Each result form must include:

**Strength Inputs (Required)**
- strength1 (MPa)
- strength2 (MPa)
- strength3 (MPa)

**Load Inputs (Optional)**
- load1 (kN)
- load2 (kN)
- load3 (kN)

**Other**
- notes (optional)

---

#### UI Behavior

- Show **3 grouped input fields** for strengths
- Show **3 grouped input fields** for loads (optional section)
- Display **calculated average strength in real-time**
    - Updates immediately when any strength field changes
    - Displayed as read-only

---

#### Validation Rules

- All strength fields are required:
    - strength1, strength2, strength3 must be filled
    - values must be > 0

- Load fields:
    - optional
    - if provided, must be > 0

---

#### UX Considerations

- Group fields clearly:
    - Cube 1 → load1 + strength1
    - Cube 2 → load2 + strength2
    - Cube 3 → load3 + strength3

- Avoid clutter:
    - Use section grouping or card layout per cube
    - Keep average strength visually prominent

---

### 3.3 Test Overview Screen

#### Remove:
- ❌ Test-level average strength

#### Keep:
- Test status
- Due date
- Result list

---

## 4. ✅ Status Rules (Updated)

### Passed / Failed Requirements

#### Previous:
- Required ≥ 3 results

#### Updated:
- Requires ≥ 1 CubeResultSet

#### Reason:
- Each CubeResultSet already contains 3 cube strengths

---

### Validation Rules

- Cannot mark as **passed / failed** if:
    - No CubeResultSet exists

- Each CubeResultSet must:
    - Have all 3 strength values
    - strength1, strength2, strength3 > 0

---

## 5. 🧠 Smart Status Suggestion (Updated)

### Suggested PASS
- At least 1 CubeResultSet exists
- Average strength of the result set ≥ required strength

### Suggested FAIL
- At least 1 CubeResultSet exists
- Average strength of the result set < required strength

#### Note
- Suggestion should be based on:
    - latest result OR
    - user-selected result (implementation choice)

---

## 6. 🔄 Migration Consideration

Not required for this phase.

> App is in early development — reinstall / data reset is acceptable.

---

## 7. 📌 Summary of Changes

| Area | Change |
|------|-------|
| Data Model | Renamed TestResult → CubeResultSet |
| Structure | Each result contains 3 strengths |
| Calculation | Average moved to result level |
| UI | Show average per result, remove test-level average |
| Manage Page | Updated to support 3-cube input |
| Status Rule | Only 1 result required |
| Naming | Clearer domain modeling |

---

## 🚀 Future Enhancements (Optional)

- Result consistency check (variance between 3 cubes)
- Detect abnormal cube values (outliers)
- Flag invalid result sets
- Provide validation warnings before marking pass/fail