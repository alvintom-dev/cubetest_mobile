# 🔔 Test Alert Specification

## 🎯 Purpose

Define a reliable notification system for cube tests (7, 14, 28 days).

The system should:

* Notify users when tests are due
* Support multiple tests on the same day
* Remain consistent even after app restarts or data changes
* Be simple to maintain and extend

---

# 🧠 Design Principle

> Notifications are a **derived state** from tests.

* Tests are the **source of truth**
* Notifications are **generated from test data**

The system must always be able to:

> Rebuild all notifications from existing test records

---

# 🧩 Data Model

## scheduleData

- Represents scheduled notifications (cache layer).
- scheduleData can be safely:
  - cleared
  - rebuilt entirely via syncNotifications()

Fields:

* `id`
* `triggerDate` LocalDate (Date only, no timezone, no time)
* `testCount` (number of tests due on that date)

---

## Notes

* `triggerDate` must not include time (avoid grouping issues)
* `testCount` is used to determine notification message
* This table is **not the source of truth**

---

# 🔑 Notification Identifier Strategy

Notification IDs must be deterministic.

```
notificationId = YYYYMMDD (int)
```

### Benefits

* No need to store notification ID in database
* Easy to cancel or update notifications
* Prevents duplicate scheduling

---

# 🔄 Core Logic

## syncNotifications()

### Purpose

Synchronize notifications with current test data.

This is the **only function responsible** for:

* Creating notifications
* Updating notifications
* Deleting notifications

---

## Steps

### 1. Fetch Tests
- Fetch all tests where dueDate is today or in the future

---

### 2. Group Tests by dueDate

Example:

```
2026-04-25 → 3 tests
2026-04-26 → 1 test
```

---

### 3. Fetch scheduleData

---

### 4. Compare Data

| Case      | Condition                                    | Action                                               |
|-----------|----------------------------------------------|------------------------------------------------------|
| CREATE    | Date exists in tests but not in scheduleData | Schedule notification + insert scheduleData          |
| UPDATE    | Date exists in both but `testCount` differs  | Cancel + recreate notification + update scheduleData |
| DELETE    | Date exists in scheduleData but not in tests | Cancel notification + delete scheduleData            |
| NO CHANGE | Same date and same count                     | Do nothing                                           |

---

### 5. Scheduling Rules (Execution Logic)
- triggerTime = 8:00 AM (local time)
- When scheduling:
  - If dueDate == today:
    - schedule ONLY if currentTime < triggerTime
  - Else:
    - schedule normally

---

### 6. Apply Changes

#### CREATE

* Schedule notification
* Insert scheduleData

#### UPDATE

* Cancel existing notification
* Recreate with updated message
* Update scheduleData
* Cancel should be safe to call even if notification does not exist

#### DELETE

* Cancel notification
* Remove scheduleData
* Cancel should be safe to call even if notification does not exist

### 7. On Complete syncNotifications()

* Update lastSyncAt = now

### 8. scheduleData and notification rules
- Only update scheduleData if notification scheduling completes without error.
- If scheduling fails:
  - Do NOT update scheduleData
  - Retry on next sync

---

# 🔔 Notification Message Rules

### Single Test

```
You have 1 cube test due on {date}
```

### Multiple Tests

```
You have {n} cube tests due on {date}
```

---

# ⏰ Scheduling Rules

* Use timezone-aware scheduling
* Trigger time: **8:00 AM (local time)**
* Trigger date = test due date

---

# 🔁 Trigger Points

## 1. On Any Test Change

Call:

```
syncNotifications()
```

Applies to:

* Test creation (auto or manual)
  - auto -> when create a testSet
  - manual -> manually create new test(7Day,14Day,28Day) under a testSet
* Test update (due date change)
  - update when we update the appointDate of testSet
  - recheck for the (7Day,14Day,28Day) due date calculation
* Test deletion
  - This might takes place when user delete testSet or delete a single test under testSet

---

## 2. On App Startup
Run syncNotifications() ONLY IF:
- first launch
  - the scheduleData is empty
- app version updated
- lastSync
  - ```
    shouldSync =
        lastSyncAt == null ||
        now.difference(lastSyncAt) > Duration(hours: 12) ||
        scheduleData.isEmpty;
    ```
  - lastSyncAt is kept in sharedPreferences(using flutter shared_preference package)
    - `const String kLastSyncKey = 'notification_last_sync_at';`

```
onAppStart():
  evaluate shouldSync
  if shouldSync is true:
    call syncNotifications()
```

### Purpose

* Recover notifications after app restart
* Ensure consistency with stored data

---

# ⚠️ Non-Goals (Out of Scope)

The system does NOT:

* Manage notifications per test individually
* Depend on event-specific logic (onCreate/onUpdate/onDelete branching)
* Store notification state as source of truth

---

# 🚀 Benefits

### Simplicity

Single entry point for all notification logic

### Reliability

Always consistent with test data

### Maintainability

Easy to extend without breaking existing logic

### Scalability

Supports future enhancements easily

---

# 🧪 Example Scenarios

## Scenario 1: New Test Set Created

3 tests created (7, 14, 28 days)

Result:

```
3 notifications scheduled (1 per day)
```

---

## Scenario 2: Multiple Tests on Same Day

2 tests share same due date

Result:

```
1 notification → "You have 2 cube tests due on {date}"
```

---

## Scenario 3: Test Date Updated

* Old date → notification removed or updated
* New date → notification created or updated

Handled automatically via sync

---

# 🔮 Future Enhancements

* Custom notification time
* Reminder before due date (e.g. 1 day earlier)
* Per-test notification instead of grouped
* Notification actions (e.g. open test, mark complete)

---

# 🧾 Summary

* Notifications are derived from test data
* `syncNotifications()` is the single source of scheduling logic
* `scheduleData` is used only as a helper/cache
* System is designed for consistency, simplicity, and scalability
* syncNotifications() is idempotent. Running it multiple times produces the same result.

---
