# 🧪 Test Set Feature Specification

## 🎯 Purpose
Group tests under a specific site and automatically generate test schedule.

---

## 🧩 Requirements

### 1. Create Test Set
User can create a test set under a site.

Fields:
- siteId (required)
- appointDate (required)(allow back date)
- name (optional)
- description (optional)
- requiredStrength: double   // 💡 minimum passing strength (MPa)

---

### 2. Auto Generate Tests (CRITICAL)
When a test set is created, system MUST automatically create tests(n days from the appointDate):

- 7-day test
- 14-day test
- 28-day test

---

### 3. View Test Sets (by Site)
Display all test sets for a selected site.

Each item should show:
- name
- appointDate (appoint date can be back dated)
- progress (e.g. 2/3 completed — see [Progress Rule](#progress-rule))
- status (not started/active/blocked/completed)

---

### 4. Test Set Detail
Display:
- Test set information
- all tests
- overall progress (see [Progress Rule](#progress-rule))

---

### Progress Rule
Progress is displayed as `completed / total` (e.g. `2/3`).

- A test is counted as **completed** if its status is `passed`, `failed`, or `skipped`.
- A test is **NOT** counted as completed if its status is `pending`.
- Deleted tests are excluded from both `completed` and `total`.
- If the test set has no tests, display `0/0`.
- The same rule MUST be used in both the list view and the detail view.

---

### 5. Test Set statuses
User can mark test set as:
- not started
- active (default)
- blocked
- completed

---

### 6. Update Test set
User can update test set details:
- name
- description
- status
  - this will check for tests statuses. 
  - if the status updated to active and all test are completed, only notify the user
  - if the status updated to not started and some tests already started/completed, only notify the user
  - if the status updated to blocked and all tests are completed, only notify the user
  - if the status updated to complete and some tests are not completed, prompt option if user want to overwrite all tests status to complete
- appointDate(this will prompt option if user want to overwrite the tests date as well)
- requiredStrength (this will prompt user to confirm the change before saving)

---

### 7. Delete Test Set
User can delete a test set.

Rule:
- Deleting a test set should also remove all related tests(cascade delete)

Mechanism:
- Deleted test set will be marked as deleted.
- The data will be deleted if user explicitly delete the test set.

---

## 🧱 Data Model

TestSet:
- id: String
- siteId: String
- appointDate: DateTime (refers to the target date the test will start)
- name: String?
- description: String?
- requiredStrength: double (minimum passing strength in MPa, must be > 0)
- status: enum (not started, active, blocked, completed)
- createdAt: DateTime
- updatedAt: DateTime
- deletedAt: DateTime

---

## 🔗 Relationships
- One Test Set → Can have many Tests(default 3)
- Belongs to Site

---

## 📌 Usecases
- CreateTestSet -> create new test set
- GetTestSets -> get test set list exclude the deleted test set with nullable parameter of siteId and isDeleted
- GetTestSet -> get single test set with detail
- UpdateTestSet
- DeleteTestSet -> must provide parameter for isPermanentDelete

---

## 📌 Business Rules
- Test set MUST belong to a valid site
- Tests are auto-generated on creation