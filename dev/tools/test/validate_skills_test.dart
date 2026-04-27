// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'package:dart_skills_lint/dart_skills_lint.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import 'check_backticks_relative_paths_rule.dart';

Directory _findSkillsDir() {
  Directory dir = Directory.current;
  while (dir.path != dir.parent.path) {
    final skillsDir = Directory(path.join(dir.path, '.agents', 'skills'));
    if (skillsDir.existsSync()) {
      return skillsDir;
    }
    dir = dir.parent;
  }
  throw StateError(
    'Could not find .agents/skills directory starting from ${Directory.current.path}',
  );
}

void main() {
  final Directory skillsDir = _findSkillsDir();
  final String skillsDirectory = skillsDir.path;
  final Directory repoRoot = skillsDir.parent.parent;

  test('Validate Flutter Skills', () async {
    final Level oldLevel = Logger.root.level;
    Logger.root.level = Level.ALL;
    final StreamSubscription<LogRecord> subscription = Logger.root.onRecord.listen((record) {
      print(record.message);
    });

    try {
      final bool isValid = await validateSkills(
        skillDirPaths: [skillsDirectory],
        resolvedRules: {
          'check-relative-paths': AnalysisSeverity.error,
          'check-absolute-paths': AnalysisSeverity.error,
          'check-trailing-whitespace': AnalysisSeverity.error,
        },
      );
      expect(isValid, isTrue, reason: 'Skills validation failed. See above for details.');
    } finally {
      Logger.root.level = oldLevel;
      await subscription.cancel();
    }
  });

  test('Relative to root paths are not in backticks', () async {
    final Level oldLevel = Logger.root.level;
    Logger.root.level = Level.ALL;
    final StreamSubscription<LogRecord> subscription = Logger.root.onRecord.listen((record) {
      print(record.message);
    });

    try {
      final valid2SegmentPaths = <String>{};

      final List<FileSystemEntity> entities = repoRoot.listSync();
      for (final entity in entities) {
        if (entity is Directory) {
          final String dirName = path.basename(entity.path);
          if (dirName.startsWith('.')) {
            continue;
          }

          final List<FileSystemEntity> subEntities = entity.listSync();
          for (final subEntity in subEntities) {
            if (subEntity is Directory) {
              final String subDirName = path.basename(subEntity.path);
              if (subDirName.startsWith('.')) {
                continue;
              }
              valid2SegmentPaths.add('$dirName/$subDirName');
            }
          }
        }
      }

      final bool isValid = await validateSkills(
        skillDirPaths: [skillsDirectory],
        customRules: [CheckBackticksRelativePathsRule(valid2SegmentPaths)],
        // Disable because the default is warn and it is not relevant to this test.
        resolvedRules: {'check-absolute-paths': AnalysisSeverity.disabled},
      );
      expect(isValid, isTrue, reason: 'Skills validation failed. See above for details.');
    } finally {
      Logger.root.level = oldLevel;
      await subscription.cancel();
    }
  });
}
