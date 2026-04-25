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

```
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
```

---

# 🧩 FEATURE STRUCTURE (MANDATORY)

Every feature MUST follow this structure:

```
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
    └── blocs/
```

---

# 📌 LAYER RESPONSIBILITY RULES

## 🎨 presentation/
ONLY UI code:
- Pages (screens)
- Widgets
- State management (Bloc logic)

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
- API calls - remote_datasource
- Local database logic - local_datasource - injectable
- Repository implementations (follow `<repository>_impl.dart` naming format)
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

✅ Example
```
shared/
  widgets/
    app_button.dart
    app_card.dart
```

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
- Routing

---

## config/
ONLY configuration:
- Dependency injection
- Environment setup

---

# 📦 REQUIRED PACKAGES (MANDATORY)

## 🧩 Functional Error Handling — dartz
- You MUST use Either<Failure, Success> from dartz
- All usecases MUST return Either<Failure, T>
- DO NOT return raw values or throw exceptions

Rules:
- No try-catch in presentation layer
- Exceptions are handled ONLY in data layer
- Data layer MUST convert exceptions → Failure
- Domain layer works ONLY with Failure, never Exception
- Presentation layer maps Failure → UI state

---

## 🧠 Dependency Injection — getIt
- You MUST use getIt for dependency injection
- All dependencies MUST be registered in config/di.dart

Rules:
- DO NOT instantiate classes manually inside:
  - Widgets
  - Pages
  - Blocs
- ALWAYS resolve dependencies via getIt
- Use lazySingleton or factory appropriately
- Injection setup MUST be centralized

---

## 🧭 Navigation — go_router
- You MUST use go_router for navigation
- All routes MUST be defined in core/route/router.dart

## Rules:
- DO NOT use Navigator directly
- Navigation logic MUST NOT be scattered in UI
- Route paths and names MUST be centralized
- Use typed route parameters where possible

---

# 🧠 BLOC STRUCTURE RULE (UPDATED)
## 📁 Structure (MANDATORY)
```
presentation/
  blocs/
    test_cubit/
      test_cubit.dart
      test_state.dart
```

## 📌 Rules
- Use Cubit (preferred) unless complexity requires Bloc
- State MUST be separated into `test_state.dart`
- Use part and part of

## 📌 Example
test_cubit.dart
```
part 'test_state.dart';

class TestCubit extends Cubit<TestState> {
  TestCubit() : super(TestInitial());
}
```

test_state.dart
```
part of 'test_cubit.dart';

abstract class TestState extends Equatable {
  const TestState();

  @override
  List<Object?> get props => [];
}

class TestInitial extends TestState {}
```

---

# 💾 DATASOURCE RULE (STRICT)
## 📁 Structure
```
data/
  datasource/
    test_remote_datasource.dart
    test_local_datasource.dart
```

## 📌 Rules
- Remote and Local MUST be separate files
- Naming MUST follow:
  - <feature>_remote_datasource.dart
  - <feature>_local_datasource.dart
- NO additional folders inside datasource/
- NO mixing remote + local logic in one file
- API response parsing MUST stay in datasource

---

# 🧩 USECASE RULE (STRICT)
## 📁 Naming Convention
```
get_tests_usecase.dart
create_test_usecase.dart
delete_test_usecase.dart
```

## 📌 Base Structure
```
@injectable
class CreateTestUsecase extends UseCase<Either<Failure, bool>, CreateTestUsecaseParam> {
  const CreateTestUsecase(this.repository);

  final TestRepository repository;

  @override
  Future<Either<Failure, bool>> call(
    CreateTestUsecaseParam? params,
  ) async {
    if (params == null) {
      return const Left(InternalAppError('Params cannot be null'));
    }

    return await repository.createTest(param: params);
  }
}
```

## 📌 Params Class
```
class CreateTestUsecaseParam extends Equatable {
  const CreateTestUsecaseParam({
    required this.name,
  });

  final String name;

  @override
  List<Object?> get props => [name];
}
```

## 📌 Rules
- ONE usecase = ONE action
- MUST extend UseCase
- MUST return Either<Failure, T>
- MUST validate params
- MUST NOT contain UI logic
- MUST NOT access datasource directly

---

# 🔄 MODEL ↔ ENTITY MAPPING RULE (CRITICAL)
## 📌 Rules
- Data models (DTO) MUST NOT be used in domain layer
- Models MUST handle fromJson/toJson
- Entities are used ONLY in domain & presentation
- Mapping MUST happen in:
  - Model (toEntity())
  - OR Repository (preferred)

## 📌 Example
```
class TestModel extends Equatable {
 const TestModel({
  required this.id,
  required this.name,
 });

 final String id;
 final String name;

 TestEntity toEntity() {
  return TestEntity(
   id: id,
   name: name,
  );
 }

 @override
 List<Object?> get props => [id, name];
}
```

---

# 🗂️ REPOSITORY IMPLEMENTATION RULE
## 📁 Location
```
data/repository/
```

## 📌 Naming
```
test_repository_impl.dart
```

## 📌 Rules
- MUST implement domain repository interface
- MUST handle:
  - datasource calls
  - error mapping (Exception → Failure)
- MUST NOT contain UI logic

## 📌 Example
```
@Injectable(as: TestRepository)
class TestRepositoryImpl implements TestRepository {
  final TestRemoteDatasource remoteDatasource;
  final TestLocalDatasource localDatasource;

  TestRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<Either<Failure, bool>> createTest({
    required CreateTestUsecaseParam param,
  }) async {
    try {
      final result = await remoteDatasource.createTest(param);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

---

# 🔁 REPOSITORY RESPONSIBILITY RULE (DATA FLOW)
## 📌 Rules
- Repository decides:
  - Remote vs Local
  - Caching strategy
- Usecases MUST NOT decide data source
- Datasources MUST NOT contain business logic
- Remote-first vs Local-first must be explicitly defined per feature
- Cache invalidation rules must be documented

## 📌 Example Flow
```
Usecase
  → Repository
    → RemoteDatasource
    → LocalDatasource
```

---

# ⚡ ASYNC & CONCURRENCY RULE
## 📌 Rules
- All async operations MUST return Future<Either<Failure, T>>
- Parallel calls MUST be handled in repository layer
- No async logic inside UI widgets
- Avoid nested awaits in presentation layer

---

# 🧨 CORE ERROR HANDLING (MANDATORY)

# 📁 Location
```
core/error/failure.dart
```

## 📌 Base Failure Definition

```
abstract class Failure extends Equatable {
  const Failure([
    List properties = const <dynamic>[],
  ]);

  @override
  List<Object?> get props => [];
}
```

## 📌 Standard Failure Types

All failures MUST extend `Failure`.

```
class ServerFailure extends Failure {
  const ServerFailure([this.message]);

  final String? message;
}

class CacheFailure extends Failure {
  const CacheFailure([this.message]);

  final String? message;
}

class NetworkFailure extends Failure {
  const NetworkFailure([this.message]);

  final String? message;
}

class ValidationFailure extends Failure {
  const ValidationFailure([this.message]);

  final String? message;
}

class InternalAppError extends Failure {
  const InternalAppError([this.message]);

  final String? message;
}
```

## 📌 Rules
- ONLY Failure is allowed beyond data layer
- Exceptions MUST NOT cross into domain/presentation

- Data layer MUST map:
```
Exception → Failure
```

- Usecases MUST return:
```
Either<Failure, T>
```

---

# ⏳ LOADING STATE RULE

## 📌 Rules
Every async Cubit action MUST follow a strict state flow:
- Emit Loading state first
- Then emit Success, Error, or Empty state
- Applies to all async operations (API, DB, cache, etc.)

## 📌 Standard Flow (General)
```
Initial → Loading → Success / Error
```

## 📌 Flow (List-Based Screens)
For any feature involving list data (e.g. tests, sites, test sets):
```
Initial → Loading → Success (data) / Empty / Error
```

## 📌 State Definitions
### 🟡 Loading
- Data is being fetched
- UI should show loading indicator

### 🟢 Success
- Data is successfully loaded
- List contains 1 or more items

### ⚪ Empty Data (loadedNoData)
- Request succeeded
- BUT no data is available

Example:
- empty test list
- no sites found

👉 Must use explicit state:
```
LoadedNoDataState
```

### 🔴 Error
- Request failed
- Exception converted to Failure
- UI should show error message + retry option

## 📌 Example Flow (List Feature)
```
Initial
↓
Loading
↓
LoadedData (items exist)
OR
LoadedNoData (empty list)
OR
Error
```

📌 Rules
- ❌ DO NOT return empty list inside Success state
- ❌ DO NOT treat empty data as Success
- ❌ DO NOT skip Loading state
- ✅ ALWAYS explicitly handle Empty state for lists
- ✅ Error MUST come from Failure mapping only

🧠 Design Principle
- “Empty is not success — it is a valid state that must be handled explicitly.”

---

# 📦 TEST DEPENDENCIES (MANDATORY)
All testing MUST use the following packages:

```
dependencies:
  equatable: latest version
  injectable: latest version
  json_annotation: latest version

dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: latest version
  bloc_test: latest version
  injectable_generator: latest version
  json_serializable: latest version
```

## 📌 MOCKING — mocktail (REQUIRED)
- You MUST use mocktail for mocking
- DO NOT use mockito
- DO NOT use code generation for mocks

✅ Example
```
class MockTestRepository extends Mock implements TestRepository {}
```

## 📌 BLOC TESTING — bloc_test (REQUIRED)
- You MUST use bloc_test for Cubit/Bloc testing
- DO NOT manually test Cubit streams

✅ Example
```
blocTest<TestCubit, TestState>(
  'emits [Loading, Success] when createTest succeeds',
  build: () {
    when(() => mockRepository.createTest(any())).thenAnswer((_) async => const Right(true));
    return TestCubit(createTestUsecase);
  },
  act: (cubit) => cubit.createTest(param),
  expect: () => [
    TestLoading(),
    TestSuccess(),
  ],
);
```

## 📌 CORE TESTING — flutter_test
- Use flutter_test for:
  - unit tests
  - widget tests (if needed)

## 📌 GENERAL RULES
- Each Usecase MUST have: success test + failure test
- Each Cubit MUST cover: initial → loading → success/failure
- Repository implementations MUST be mockable
- Tests MUST NOT depend on real implementations
- Always use mocks for:
  - repositories
  - usecases (when testing Cubits)
- Prefer testing:
  - Usecases (core logic)
  - Cubits (state transitions)
- Avoid:
  - testing UI widgets unless necessary
  - mocking low-level datasources (unless explicitly required)

## 🚫 FORBIDDEN
- ❌ Using mockito
- ❌ Running build_runner for mocks
- ❌ Hitting real API/database in tests
- ❌ Writing unstructured or inline mocks

## 🧠 DESIGN PRINCIPLE
Testing MUST be:
- deterministic
- fast
- isolated
- architecture-aligned

---

# 🧭 NAVIGATION ARCHITECTURE RULE (MANDATORY)
## 📁 File Structure
```
core/route/
  router.dart       ← Route definitions (ONLY place that knows pages)
  routes.dart       ← Route names & paths (single source of truth)
```

## 📌 1. ROUTE CONSTANTS (REQUIRED)
📁 Location
```
core/route/routes.dart
```

📌 Rules
- ALL route names MUST be defined here
- ALL route paths MUST be defined here
- MUST use static constants
- MUST NOT hardcode route strings anywhere else

📌 Example
```
class AppRoutes {
  const AppRoutes._();

  // Route Names
  static const tests = 'tests';
  static const sites = 'sites';

  // Route Paths
  static const testsPath = '/tests';
  static const sitesPath = '/sites';
}
```

## 📌 2. ROUTER DEFINITION (STRICT)
📁 Location
```
core/route/router.dart
```

📌 Rules
- This is the ONLY file allowed to import:
  - feature pages
- MUST use AppRoutes constants
- MUST NOT define inline strings

📌 Example
```
final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.testsPath,
      name: AppRoutes.tests,
      builder: (context, state) => const TestsPage(),
    ),
    GoRoute(
      path: AppRoutes.sitesPath,
      name: AppRoutes.sites,
      builder: (context, state) => const SitesPage(),
    ),
  ],
);
```

## 📌 3. NAVIGATION USAGE (UI LAYER)
📌 Rules
- UI MUST navigate using route names
- MUST NOT import other feature pages
- MUST NOT use raw strings
- MUST NOT use Navigator directly

✅ Correct
```
context.pushNamed(AppRoutes.sites);
```

❌ Forbidden
```
context.pushNamed('sites'); // ❌ hardcoded
import 'features/site/presentation/pages/sites_page.dart'; // ❌
Navigator.push(...); // ❌
```

## 📌 4. DATA PASSING RULE
📌 Rules
- Data MUST be passed via:
  - extra
  - or query/path parameters
- MUST NOT pass objects via direct constructor calls

✅ Example
```
context.pushNamed(
  AppRoutes.sites,
  extra: siteId,
);
```

In router.dart
```
GoRoute(
  path: AppRoutes.sitesPath,
  name: AppRoutes.sites,
  builder: (context, state) {
    final siteId = state.extra as String?;
    return SitesPage(siteId: siteId);
  },
),
```

## 📌 5. CROSS-FEATURE NAVIGATION RULE
📌 Rules
- Features MUST NOT import other feature pages
- Navigation MUST go through router
- Communication between features MUST use:
  - route params
  - domain entities (if needed)

## 📌 6. OPTIONAL (RECOMMENDED) — ROUTE GROUPING
For scalability, group routes by feature:
```
class AppRoutes {
  const AppRoutes._();

  // Test
  static const tests = 'tests';
  static const testsPath = '/tests';

  // Site
  static const sites = 'sites';
  static const sitesPath = '/sites';
}
```

## 📌 7. ERROR HANDLING IN NAVIGATION
📌 Rules
- Invalid or missing params MUST be handled in router
- MUST NOT crash UI

Example
```
builder: (context, state) {
  final siteId = state.extra as String?;
  if (siteId == null) {
    return const ErrorPage();
  }
  return SitesPage(siteId: siteId);
},
```

## 🚫 FORBIDDEN PRACTICES (NAVIGATION)
You MUST NOT:
- Import pages across features
- Hardcode route strings
- Use Navigator directly
- Instantiate pages outside router
- Pass complex objects without validation

## 🧠 DESIGN PRINCIPLE
Navigation is a global concern, not a feature concern.
- Features define UI
- Router controls navigation
- Routes define contract

---

# 🏷️ NAMING CONVENTION RULE
## 📌 File Naming
- MUST use snake_case.dart

## 📌 Class Naming
- MUST use PascalCase

## 📌 Examples
| Type    | Example |
|---------|----------|
| Cubit   | TestCubit |
| State   | TestState |
| Usecase | CreateTestUsecase |
| Model   | TestModel |
| Entity  | Test |

---

# 🧱 BASE USECASE CLASS (RECOMMENDED)
## 📁 Location
```
core/usecase/usecase.dart
```

## 📌 Definition
```
abstract class BaseUseCase<T> {
  const BaseUseCase();
}

abstract class UseCase<T, P> extends BaseUseCase<T> {
  const UseCase() : super();

  Future<T> call(P? params);
}

abstract class NoParamsUseCase<T> extends BaseUseCase<T> {
  const NoParamsUseCase() : super();

  Future<T> call();
}

```

## 📌 Rules
- Nullable params ONLY if explicitly required
- Prefer NoParamsUseCase when no params needed

---

# 🚧 FEATURE ISOLATION RULE (CRITICAL)

- Features MUST be independent
- Features MUST NOT import other features
- Shared logic MUST go to:
  - domain (if business)
  - shared (if UI)

- Cross-feature communication ONLY via:
  - navigation params
  - domain entities

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

| Type             | Location                           |
|------------------|------------------------------------|
| UI Screen        | presentation/pages                 |
| UI Component     | presentation/widgets               |
| State            | presentation/blocs/<feature>_cubit |
| Cubit            | presentation/blocs/<feature>_cubit |
| Business Logic   | domain/usecases                    |
| Entity           | domain/entities                    |
| API / DB         | data/datasource                    |
| Model            | data/models                        |
| Repository Impl  | data/repository                    |
| Shared UI        | shared/widgets                     |
| External Service | services/                          |

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
5. For read-only features with no local storage, local_datasource may be omitted with approval

---

# ✅ ANALYZE & TEST RULE (MANDATORY)

Every code change MUST be verified by the analyzer and the test suite before a task is considered complete.

## 📌 Rules

- `flutter analyze` MUST pass with **zero issues** (no errors, no warnings, no infos).
- All tests MUST pass — **zero failing, zero skipped**.
- A task is NOT complete until BOTH the analyzer AND the full suite return clean.

## 📌 Test Execution Workflow (STRICT)

Tests MUST be run in **two stages**: targeted first, then full.

### 🎯 Stage 1 — Targeted Tests (during iteration)

While implementing or fixing a change, run ONLY the tests related to the code you touched. Fast feedback loop, lower cost.

Scope the run to the feature / file / directory you are actively changing:

```bash
# single test file
flutter test test/features/site/domain/usecases/create_site_usecase_test.dart

# single feature (all tests under a directory)
flutter test test/features/site

# a layer within a feature
flutter test test/features/site/domain
flutter test test/features/site/presentation/blocs

# filter by test name
flutter test --name "emits [Loading, LoadedData]"
```

Rules for targeted runs:
- Targeted tests MUST pass before moving to Stage 2.
- Targeted scope MUST cover **every** file you modified (usecase edit → run that usecase's test + its cubit's test; entity edit → run all tests in that feature).
- Targeted runs are for speed, NOT for narrowing coverage to hide failures elsewhere.

### 🧪 Stage 2 — Full Suite (before marking done)

Once targeted tests are green, run the ENTIRE suite to catch cross-feature regressions:

```bash
flutter analyze
flutter test
```

Rules for the full run:
- MUST be executed before declaring any task complete — no exceptions.
- MUST be re-run after every additional edit (however small) made after a previous full run.
- If ANY test outside your targeted scope fails, treat it as part of your change — investigate and fix before completing the task.

## 📌 Overall Flow

```
make change
  ↓
targeted tests   ← fast feedback (Stage 1)
  ↓ green
flutter analyze  ← zero issues
  ↓ clean
flutter test     ← full suite, all green (Stage 2)
  ↓ green
task complete
```

## 🚫 FORBIDDEN

You MUST NOT:
- Mark a task as done while `flutter analyze` reports any issue.
- Mark a task as done after running ONLY targeted tests — full `flutter test` is mandatory.
- Mark a task as done while any test is failing or skipped (targeted OR full).
- Suppress analyzer issues with `// ignore:` comments just to make analyze pass — fix the root cause instead (exceptions require explicit approval).
- Delete, comment out, or `skip:` tests to make the suite pass.
- Claim success without actually running both the targeted AND full stages.

## 🧠 DESIGN PRINCIPLE
Targeted tests give speed, the full suite gives safety — both are required. "Green analyze + green full suite" is the definition of done.

---

# 📌 ENFORCEMENT RULE

- Any deviation from this architecture MUST be explicitly justified and approved before implementation.
- For extremely simple features (read-only, no logic), domain layer MAY be simplified with approval.