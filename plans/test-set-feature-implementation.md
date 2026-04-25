# Test Set Feature — Clean Architecture Implementation Plan

## Context

The Site feature is implemented end-to-end (`lib/features/site/`) with sqflite + Clean Architecture, and the shared scaffolding (`core/`, `config/di.dart`, `app.dart`, `main.dart`) is live. `site_repository_impl.dart` currently has a `testSets = 0` TODO awaiting the Test Set feature.

This plan implements Test Set per `specs/test_set.md` and — now that test_set exists — wires Site's `testSets` count through a shared abstraction so the two features stay isolated.

### Decisions confirmed with user
1. **Day values**: `7 / 14 / 28` per `specs/test_set.md`. `specs/test.md`'s `day7/day14/day24` is out of date (follow-up for when Test feature ships).
2. **Due-date formula**: `appointDate + N days`. Back-dated `appointDate` is allowed.
3. **Auto-generate tests**: **skip for now**. Test Set is stored without any accompanying Test rows. The spec's CRITICAL auto-generation requirement is knowingly deferred until the Test feature is built. Consequences:
   - `UpdateTestSet` status-transition prompts (active/not-started/blocked/completed vs underlying test statuses, spec §6) are **deferred** — UI just updates status directly with a `// TODO` referencing spec §6.
   - `DeleteTestSet` cascade to tests is a **no-op** with a `// TODO`.
4. **Wire Site's `testSets` count**: via a shared abstraction in `core/ports/`. Site consumes the port; test_set provides the impl. Preserves feature isolation (no `site → test_set` or `test_set → site` imports).

---

## Folder scaffold (new — test_set feature only)

```
lib/features/test_set/
├── data/
│   ├── datasource/test_set_local_datasource.dart
│   ├── models/test_set_model.dart
│   └── repository/test_set_repository_impl.dart
├── domain/
│   ├── entities/test_set.dart                     (TestSet + TestSetStatus enum)
│   ├── repository/test_set_repository.dart
│   └── usecases/
│       ├── create_test_set_usecase.dart
│       ├── get_test_sets_usecase.dart
│       ├── get_test_set_usecase.dart
│       ├── update_test_set_usecase.dart
│       └── delete_test_set_usecase.dart
└── presentation/
    ├── blocs/
    │   ├── test_sets_cubit/{test_sets_cubit.dart, test_sets_state.dart}
    │   ├── test_set_detail_cubit/{test_set_detail_cubit.dart, test_set_detail_state.dart}
    │   └── test_set_form_cubit/{test_set_form_cubit.dart, test_set_form_state.dart}
    ├── pages/
    │   ├── test_sets_page.dart
    │   ├── test_set_detail_page.dart
    │   └── test_set_form_page.dart
    └── widgets/
        ├── test_set_list_item.dart
        ├── test_set_status_chip.dart
        └── test_set_form.dart
```

Tests mirror under `test/features/test_set/`.

### New shared abstraction (core/)

```
lib/core/ports/
└── site_test_set_counter.dart        (abstract contract read by site, implemented by test_set)
```

---

## Phase 1 — Domain

### `TestSet` entity
```dart
enum TestSetStatus { notStarted, active, blocked, completed }

class TestSet extends Equatable {
  const TestSet({
    required this.id,
    required this.siteId,
    required this.appointDate,
    this.name,
    this.description,
    this.status = TestSetStatus.active,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.isDeleted = false,
  });
  final String id;
  final String siteId;
  final DateTime appointDate;
  final String? name;
  final String? description;
  final TestSetStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool isDeleted;

  TestSet copyWith({...});
  @override List<Object?> get props => [...];
}
```

(`progress`, `totalTests`, `completedTests` are intentionally omitted — cannot be derived until Test feature exists. UI displays "—" or "0/0" with a TODO in the widget.)

### `TestSetRepository`
```dart
abstract class TestSetRepository {
  Future<Either<Failure, TestSet>> createTestSet({required CreateTestSetUsecaseParam param});
  Future<Either<Failure, List<TestSet>>> getTestSets({String? siteId, bool? isDeleted});
  Future<Either<Failure, TestSet>> getTestSet({required String id});
  Future<Either<Failure, TestSet>> updateTestSet({required UpdateTestSetUsecaseParam param});
  Future<Either<Failure, bool>> deleteTestSet({required DeleteTestSetUsecaseParam param});
}
```

### Usecases (one file each, all `@injectable`, extend `UseCase<Either<Failure,T>, P>`)

- `CreateTestSetUsecase` / `CreateTestSetUsecaseParam(siteId, appointDate, name?, description?)` — validates siteId non-empty; appointDate non-null; past dates allowed.
- `GetTestSetsUsecase` / `GetTestSetsUsecaseParam({siteId, isDeleted})` — both nullable, per spec §Usecases.
- `GetTestSetUsecase` / `GetTestSetUsecaseParam(id)` — validates non-empty id.
- `UpdateTestSetUsecase` / `UpdateTestSetUsecaseParam(id, name?, description?, status, appointDate)` — validates id.
- `DeleteTestSetUsecase` / `DeleteTestSetUsecaseParam(id, isPermanentDelete)` — validates id.

Null params → `InternalAppError('Params cannot be null')` per CLAUDE.md §USECASE RULE.

---

## Phase 2 — Data

### `TestSetModel`
`@JsonSerializable` + sqflite `fromMap/toMap` + `toEntity()` / `fromEntity(TestSet)`. Status serialized as the enum name string. Dates as ISO8601.

### `TestSetLocalDatasource` (`@injectable`)
```sql
CREATE TABLE test_sets (
  id TEXT PRIMARY KEY,
  site_id TEXT NOT NULL,
  appoint_date TEXT NOT NULL,
  name TEXT,
  description TEXT,
  status TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  deleted_at TEXT,
  is_deleted INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX idx_test_sets_site ON test_sets(site_id);
```

Methods: `create`, `getAll({siteId?, isDeleted?})`, `getById`, `update`, `softDelete`, `hardDelete`, `countBySiteId(String siteId)`.

**Schema bootstrap**: extend the existing `onCreate` in `SiteLocalDatasource.openDatabaseInstance()` (the shared DB opener) to also create `test_sets`. No version migration needed — app is pre-release.

### `TestSetRepositoryImpl` (`@Injectable(as: TestSetRepository)`)
Constructor-injects `TestSetLocalDatasource` + `Uuid`. Maps exceptions → `CacheFailure`. Comments:
- In `createTestSet`: `// TODO: auto-generate 7/14/28-day tests via appointDate + N (spec §2) once Test feature exists.`
- In `updateTestSet`: `// TODO: implement status-transition validation prompts (spec §6) once Test feature exists.`
- In `deleteTestSet`: `// TODO: cascade-delete related tests (spec §7) once Test feature exists.`

### `SiteTestSetCounterImpl` (lives in `lib/features/test_set/data/`)

Implements the shared port. `@Injectable(as: SiteTestSetCounter)`:

```dart
@Injectable(as: SiteTestSetCounter)
class SiteTestSetCounterImpl implements SiteTestSetCounter {
  const SiteTestSetCounterImpl(this._datasource);
  final TestSetLocalDatasource _datasource;

  @override
  Future<int> countActiveForSite(String siteId) =>
      _datasource.countBySiteId(siteId); // excludes soft-deleted
}
```

---

## Phase 3 — Shared port + Site wiring

### New — `lib/core/ports/site_test_set_counter.dart`
```dart
abstract class SiteTestSetCounter {
  Future<int> countActiveForSite(String siteId);
}
```

### Modified — `lib/features/site/data/repository/site_repository_impl.dart`
- Add constructor param `SiteTestSetCounter _counter`.
- Change `_toEntityWithTestSets` to `Future<Site> _toEntityWithTestSets(SiteModel model)` and `await _counter.countActiveForSite(model.id)`.
- Update the 5 call sites that currently do `.map(_toEntityWithTestSets).toList()` — use `Future.wait(models.map(_toEntityWithTestSets))`.
- Remove the hardcoded-0 TODO.

Site tests use `MockSiteRepository` (not the impl) — no test changes needed. If any impl-level test exists (none currently), update it.

### Modified — `lib/features/site/presentation/pages/site_detail_page.dart`
Add a "View test sets" action (button in the AppBar or a link in the Associated Test Sets section) that navigates to `AppRoutes.testSets` with `pathParameters: {'siteId': siteId}`. Site stays isolated — it only uses route names.

---

## Phase 4 — Presentation

### `TestSetsCubit` (list scoped to a site)
States: `Initial, Loading, LoadedData(List<TestSet>), LoadedNoData, Error`. Action `fetch(String siteId)`.

### `TestSetDetailCubit`
States: `Initial, Loading, Loaded(TestSet), Deleted, Error`. Actions `load(id)`, `softDelete(id)`.

### `TestSetFormCubit`
States: `Initial, Submitting, Success(TestSet), ValidationError(String), Error(String)`. Actions `submitCreate(param)`, `submitUpdate(param)`. Maps `ValidationFailure → SiteFormValidationError`-equivalent.

### Pages

- **`TestSetsPage(siteId)`**: AppBar, FAB to create, `ListView` of `TestSetListItem`s. `LoadedNoData` shows "No test sets yet."
- **`TestSetDetailPage(testSetId)`**: shows fields + appointDate + status + placeholder "Tests (0/0) — available once Test feature ships" (with TODO comment). Edit + delete actions.
- **`TestSetFormPage(siteId, {testSetId?})`**: shared create/edit. Date picker for appointDate (supports past dates), optional name/description, status dropdown (visible in edit mode only; create defaults to `active`).

### Widgets

- `TestSetListItem`: name-or-`(Unnamed)`, formatted `appointDate`, `TestSetStatusChip`, progress placeholder.
- `TestSetStatusChip`: color-coded by `TestSetStatus`.
- `TestSetForm`: form with validator for date, name/description optional, status dropdown.

### Routing additions

**`lib/core/route/routes.dart`** — append:
```dart
static const testSets          = 'testSets';
static const testSetsPath      = 'test-sets';      // relative (nested under siteDetail)
static const testSetDetail     = 'testSetDetail';
static const testSetDetailPath = ':testSetId';
static const testSetCreate     = 'testSetCreate';
static const testSetCreatePath = 'create';
static const testSetEdit       = 'testSetEdit';
static const testSetEditPath   = ':testSetId/edit';
```

**`lib/core/route/router.dart`** — nest under the existing site routes. Each builder extracts `siteId` / `testSetId` from `pathParameters`.

---

## Phase 5 — Tests

### Usecase tests (`test/features/test_set/domain/usecases/*_test.dart`)
One file per usecase. Each: null-params → `InternalAppError`; validation failure; success delegates to repo; propagates repo failure. Use `class MockTestSetRepository extends Mock implements TestSetRepository {}`.

### Cubit tests (`test/features/test_set/presentation/blocs/*_test.dart`)
`bloc_test` for each cubit:
- `TestSetsCubit`: `[Loading, LoadedData]`, `[Loading, LoadedNoData]`, `[Loading, Error]`.
- `TestSetDetailCubit`: `[Loading, Loaded]`, `[Loading, Error]`, `[Deleted]` after softDelete.
- `TestSetFormCubit`: `[Submitting, Success]` (create + update), `[Submitting, ValidationError]`, `[Submitting, Error]`.

All mocks via mocktail. No mockito, no build_runner mocks.

---

## Critical files

**New**:
- `lib/core/ports/site_test_set_counter.dart`
- Entire `lib/features/test_set/**` tree
- `test/features/test_set/**` mirror

**Modified**:
- `lib/features/site/data/datasource/site_local_datasource.dart` — extend `onCreate` to also create `test_sets` table + index.
- `lib/features/site/data/repository/site_repository_impl.dart` — inject `SiteTestSetCounter`, async `_toEntityWithTestSets`.
- `lib/features/site/presentation/pages/site_detail_page.dart` — add "View test sets" navigation.
- `lib/core/route/routes.dart` + `lib/core/route/router.dart` — add nested test-set routes.

**Regenerated** (via `dart run build_runner build`):
- `lib/config/di.config.dart`
- `lib/features/test_set/data/models/test_set_model.g.dart`

---

## Verification (per CLAUDE.md ANALYZE & TEST RULE)

1. `flutter pub get` (no new dependencies).
2. `dart run build_runner build --delete-conflicting-outputs` — regenerates `di.config.dart` + `test_set_model.g.dart`.
3. **Stage 1 (targeted)**: `flutter test test/features/test_set` → all green.
4. **Stage 1 (targeted for Site regression)**: `flutter test test/features/site` → all green (repository signature changed, but tests mock the interface so should stay green).
5. **Stage 2 (full)**: `flutter analyze` → zero issues, then `flutter test` → all green.
6. Manual smoke via `flutter run`:
   - Create a site → open it → tap "Test sets" action → empty state shows.
   - FAB → create test set with today's date + name "Batch A" → lands back on list with one item; Site list's `testSets` now shows 1.
   - Back-date a test set → accepted.
   - Edit name / description / status / appointDate → persists.
   - Soft-delete → removed from list; Site's count decrements.
   - Permanent delete (archive → delete) — available once test_set archive UI lands (or deferred; spec §7 describes soft+permanent, same as Site).
