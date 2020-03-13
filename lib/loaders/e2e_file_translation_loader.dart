import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';

import 'file_translation_loader.dart';

class _CustomAssetBundle extends PlatformAssetBundle {
  Future<String> loadString(String key, {bool cache = true}) async {
    try {
      final ByteData data = await load(key);
      return utf8.decode(data.buffer.asUint8List());
    } catch (e) {
      return "{}";
    }
  }
}

class E2EFileTranslationLoader extends FileTranslationLoader {
  final bool useE2E;

  AssetBundle customAssetBundle = _CustomAssetBundle();

  E2EFileTranslationLoader(
      {forcedLocale,
      fallbackFile = "en",
      basePath = "assets/flutter_i18n",
      useCountryCode = false,
      this.useE2E = true})
      : super(
          fallbackFile: fallbackFile,
          basePath: basePath,
          useCountryCode: useCountryCode,
          forcedLocale: forcedLocale,
        );

  Future<String> loadString(final String fileName, final String extension) {
    return useE2E
        ? customAssetBundle.loadString('$basePath/$fileName.$extension')
        : super.loadString(fileName, extension);
  }
}
