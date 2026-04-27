// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dart_skills_lint/dart_skills_lint.dart';
import 'package:path/path.dart' as path;

class CheckBackticksRelativePathsRule extends SkillRule {
  CheckBackticksRelativePathsRule(this.valid2SegmentPaths);

  final Set<String> valid2SegmentPaths;

  @override
  String get name => 'check-backticks-relative-paths';

  @override
  AnalysisSeverity get severity => AnalysisSeverity.error;

  @override
  Future<List<ValidationError>> validate(SkillContext context) async {
    final errors = <ValidationError>[];
    final String content = context.rawContent;
    const relativePathToRoot = '../../../';

    final backtickRegex = RegExp(r'`([^`]+)`');
    final Iterable<RegExpMatch> matches = backtickRegex.allMatches(content);

    for (final match in matches) {
      final String textInBackticks = match.group(1)!;

      for (final String validPath in valid2SegmentPaths) {
        if (textInBackticks.startsWith(validPath)) {
          if (textInBackticks.startsWith('/')) {
            continue;
          }

          errors.add(
            ValidationError(
              ruleId: name,
              file: 'SKILL.md',
              message:
                  'Found root-relative path "$textInBackticks" in backticks. Suggested fix: [${path.basename(textInBackticks)}]($relativePathToRoot$textInBackticks)',
              severity: severity,
            ),
          );
        }
      }
    }

    return errors;
  }
}
