import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _variantNames = {
  'w100': 'Thin',
  'w200': 'ExtraLight',
  'w300': 'Light',
  'w400': 'Regular',
  'w500': 'Medium',
  'w600': 'SemiBold',
  'w700': 'Bold',
  'w800': 'ExtraBold',
  'w900': 'Black',
};

Set<String> _requiredFontFiles() {
  final call = RegExp(r'GoogleFonts\.([a-zA-Z]+)\(');
  final weight = RegExp(r'fontWeight:\s*FontWeight\.(w\d00)');
  final required = <String>{};
  for (final entity in Directory('lib').listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final source = entity.readAsStringSync();
    for (final match in call.allMatches(source)) {
      var depth = 0;
      var end = match.end - 1;
      for (; end < source.length; end++) {
        if (source[end] == '(') depth++;
        if (source[end] == ')' && --depth == 0) break;
      }
      final args = source.substring(match.end, end);
      final family = match.group(1)!;
      final variant = weight.firstMatch(args)?.group(1) ?? 'w400';
      required.add(
        '${family[0].toUpperCase()}${family.substring(1)}'
        '-${_variantNames[variant]}.ttf',
      );
    }
  }
  return required;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'every GoogleFonts variant used in lib is bundled as an asset',
    () async {
      final required = _requiredFontFiles();
      expect(required, isNotEmpty);
      for (final file in required) {
        final bytes = await rootBundle.load('assets/google_fonts/$file');
        expect(bytes.lengthInBytes, greaterThan(0), reason: file);
      }
    },
  );
}
