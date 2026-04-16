---
name: testing-guidance
description: Use this skill when an agent needs to know how to run specific test files or where to add new tests (unit, integration, etc.) in the Flutter codebase. This skill is specific to the flutter/flutter codebase.
---

## Instructions

1. **Determine Intent**: Check if the request is about *running* existing tests or *authoring* new tests.

2. **Identify Test Category**: Use the file path or test type to categorize the test. Refer to the [Test-Types-Overview.md](file:///Users/reidbaker/flutter-work/docs/contributing/testing/Test-Types-Overview.md) for the full inventory.
    - `packages/flutter/test/` -> Framework Tests (Dart)
    - `packages/flutter_tools/test/` -> Tool Tests (Dart)
    - `dev/integration_tests/` -> Integration Tests (Dart, Native)
    - `dev/devicelab/` -> DeviceLab Tests (Dart)
    - `engine/src/` -> Engine Tests (C++, Dart, Java, etc.)

    *Note: Always look at adjacent code files to see where their tests are located.*

3. **Provide Minimal Answer**:
    - **Framework Tests**: Run `bin/flutter test <file_path>`.
    - **Tool Tests**: Run `bin/flutter test <file_path>`.
    - **Integration Tests**: Run `flutter drive -t <test> --driver <driver>`.
    - **DeviceLab Tests**: Run `../../bin/cache/dart-sdk/bin/dart bin/test_runner.dart test -t <test_name>` from the `dev/devicelab` directory.
    - **Engine Tests**: Use `testing/run_tests.py` or `et` (Engine Tool).

4. **Prerequisites and Non-Obvious Details**:
    - **DeviceLab**: Ensure a target device is connected or environment variables (like `ANDROID_SDK_ROOT`) are set. Check if the test requires specific hardware.
    - **Engine**: Requires full engine development environment.

5. **Link to Documentation**: For complex answers or full details, link to [Test-Types-Overview.md](file:///Users/reidbaker/flutter-work/docs/contributing/testing/Test-Types-Overview.md).

## Examples

### Running Tests

- **User:** "How do I run test file packages/flutter/test/foundation/assertions_test.dart?"
- **Agent:** Run `bin/flutter test packages/flutter/test/foundation/assertions_test.dart`.

- **User:** "How do I run a DeviceLab test named `complex_layout__start_up`?"
- **Agent:** Navigate to `dev/devicelab` and run `../../bin/cache/dart-sdk/bin/dart bin/test_runner.dart test -t complex_layout__start_up`. Ensure you have a device connected if the test requires it.

- **User:** "How do I run engine tests?"
- **Agent:** You can use `testing/run_tests.py --type=engine` or the Engine Tool: `et test //flutter/impeller:impeller_unittests`.

### Authoring Tests

- **User:** "How do I add a Dart unit test for the framework?"
- **Agent:** Add it to the appropriate directory under `packages/flutter/test/`. Look at adjacent files for examples.

- **User:** "Where do I add flutter gradle plugin kotlin tests?"
- **Agent:** These are typically located in `packages/flutter_tools/test/` or within the specific integration test directories in `dev/integration_tests/` that exercise build features.

- **User:** "Where do I add java engine tests?"
- **Agent:** These belong in the engine source tree, typically under `flutter/shell/platform/android/test/`.
