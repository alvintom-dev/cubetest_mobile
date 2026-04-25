# 📅 Test Feature Specification

## 🎯 Purpose
Track individual tests (7, 14, 28 days) including status and results.

---

## 🧩 Requirements

### 1. Create Tests
There are two ways to create tests:

#### 1.1 Auto Create (Primary)
When a **Test Set** is created, the system automatically generates:

- 7-day test
- 14-day test
- 28-day test

Each test will have:
- type (day7 / day14 / day28)
- due date (auto-calculated)
- default status = pending

##### Due Date Calculation
- day7 → testSet.createdAt + 7 days
- day14 → testSet.createdAt + 14 days
- day28 → testSet.createdAt + 28 days

#### 1.2 Manual Create (Secondary)
User can manually create a test under a test set.

User inputs:
- type (day7 / day14 / day28)
- due date (required in form, auto-filled using default calculation but editable)

#### Rules
- Test types must be **unique per test set**
    - ❌ Cannot create duplicate (e.g., two 7-day tests)
- If a test type already exists:
    - system should prevent creation
    - UI should indicate (e.g., “7-day test already exists”)
- Auto-created tests follow standard workflow
- Manual creation is allowed for flexibility, but not the primary flow

---

### 2. View Tests
User can view all tests under a test set.

Each test shows:
- type (day7 / day14 / day28)
- due date
- status (pending / passed / failed / skipped)
- average strength (MPa)
  - Average strength = sum(all cube strengths) / number of results
- overdue indicator

---

### 3. Update Test Status
User can mark test as:
- pending
- passed
- failed
- skipped

Rules:
- Cannot mark passed/failed without results
- skipped does not require results

---

### 4. Manage Test Result
Each test contains multiple cube results (default: 3)

User can:
- add/edit/delete cube result

Each result includes:
- load (kN) (optional but recommended)
- strength (MPa) (required OR auto-calculated)
- notes (optional)

---

### 5. Test Calculations (Suggestion Only)
System automatically calculates:
- average strength
- result consistency (optional future enhancement)

---

### 6. Mark Test Completed
When marked:
- completedAt is set
- status must be:
  - passed / failed / skipped

---

### 7. Overdue Detection
A test is overdue if:
- current date > dueDate
- status is still pending

#### Rules
- Overdue is only a visual indicator
- It does not affect test status

---

## 🧱 Data Model

Test:
- id: String
- testSetId: String
- type: enum (day7, day14, day28)
- dueDate: DateTime
- status: enum (pending, passed, failed, skipped)
- remark: String?
- completedAt: DateTime?
- createdAt: DateTime?
- updatedAt: DateTime?

TestResult:
- id: String
- testId: String
- load: double? // kN (optional but recommended)
- strength: double // MPa
- notes: String?
- createdAt: DateTime?
- updatedAt: DateTime?

---

## 🔗 Relationships
- Test belongs to Test Set
- Test has many TestResults

---

## 📌 Business Rules

### Due Date Calculation
Even with the default due date, user can manually edit the due date as well
- 7-day = createdAt + 7 days
- 14-day = createdAt + 14 days
- 28-day = createdAt + 28 days

---

### Status Rules
- Default status = pending
- passed / failed:
  - requires at least 3 cube results (recommended minimum standard)
  - average strength is used for evaluation
- skipped:
  - no result required

---

### Smart Status Suggestion (Optional)
System can suggest test status based on results:
- required strength is available in TestSet.requiredStrength
- Suggested PASS:
  - At least 3 results exist
  - Average strength ≥ required design strength
- Suggested FAIL:
  - At least 3 results exist
  - Average strength < required design strength

#### Rules
- User must explicitly confirm before applying any suggested status.
- System must NEVER auto-change status
- Status can only be changed by user action
- Suggestions are advisory only

---

### Validation
- Cannot mark test as passed/failed without results
- Cannot mark test completed without status
- Strength must be > 0
- Test type must be unique per test set