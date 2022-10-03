// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart' as path;

/// Thrown when getApplicationDirectory fails
class GetDirectoryException implements Exception {}

/// {@template path_provider_service}
/// Service that retrieves paths to app directories
/// {@endtemplate}
class PathProviderService {
  /// {@macro path_provider_service}
  const PathProviderService();

  /// Creates a unique file path
  Future<String> generateUniqueFilePath({
    required String extension,
    String subDir = '',
  }) {
    assert(
      subDir.isEmpty || subDir.startsWith('/'),
      'Sub Directory must begin with "/"',
    );
    final filename = DateFormat('yddMMhhmmss').format(DateTime.now());
    try {
      return path
          .getApplicationDocumentsDirectory()
          .then((directory) => '${directory.path}$subDir/$filename.$extension');
    } catch (_) {
      throw GetDirectoryException();
    }
  }

  /// Returns a list of files
  Future<List<File>> getDirectoryFiles(String subDir) async {
    assert(
      subDir.isEmpty || subDir.startsWith('/'),
      'Sub Directory must begin with "/"',
    );
    final files = <File>[];
    final directory = await path.getApplicationDocumentsDirectory();

    final entities = Directory('${directory.path}$subDir').listSync();
    for (final fileSystemEntity in entities) {
      files.add(File(fileSystemEntity.path));
    }

    return files;
  }
}

// /// A wrapper class for path_provider.dart static methods
// class PathProviderWrapper {
//
//   /// Retrieves the applicationDocumentDirectory from the path_provider library
//   Future<Directory> getApplicationDocumentsDirectory() {
//     return path.getApplicationDocumentsDirectory();
//   }
// }
