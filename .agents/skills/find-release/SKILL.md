---
name: find-release
description: A skill to find the lowest Dart and Flutter release containing a given commit.
---

# find-release

A skill to find the lowest Dart and Flutter release containing a given commit.

## Description

This skill helps developers in the `flutter/flutter` repository (and `dart-lang/sdk`) to identify when a specific commit landed in a release. It determines which repository the commit belongs to and then finds the lowest version tag and corresponding release version for a specified channel (stable, beta, or dev).

## Triggers

- "When did commit [SHA] land?"
- "Which release is [SHA] in?"
- "Is commit [SHA] in stable?"
- "Find the release for [SHA]"
- "Has [SHA] landed in beta yet?"

## Instructions

1.  **Extract Information:**
    - Identify the commit SHA from the user's request (e.g., `02abc57`).
    - Identify the target channel (one of: `stable`, `beta`, `dev`). If not specified, default to `stable`.

2.  **Execute Search:**
    - Run the `find_release.dart` tool using the absolute path to ensure it works from any directory within the workspace.
    - Command: `dart run /Users/reidbaker/flutter-work/engine/src/flutter/third_party/dart/tools/find_release.dart --commit=<SHA> --channel=<CHANNEL>`

3.  **Interpret and Report Results:**
    - The tool will report which repository (`dart-lang/sdk` or `flutter/flutter`) the commit was found in.
    - It will provide the "Lowest release tag" (the git tag containing the commit).
    - It will provide the "Lowest Flutter release" and/or "Lowest Dart release" version for the specified channel.
    - Present these findings clearly to the user. If the commit is not found or not yet in a release for that channel, inform the user accordingly.

## Examples

- **User:** "When did commit 02abc57 land in stable?"
- **Agent:** Runs `dart run /Users/reidbaker/flutter-work/engine/src/flutter/third_party/dart/tools/find_release.dart --commit=02abc57 --channel=stable` and reports the release version.

- **User:** "Is 02abc57 in beta?"
- **Agent:** Runs the command with `--channel=beta`.
