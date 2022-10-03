// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:io';

import 'package:network_service/network_service.dart';
import 'package:path_provider_service/path_provider_service.dart';

/// {@template coffee_repository}
/// Repository that manages coffee
/// {@endtemplate}
class CoffeeRepository {
  /// {@macro coffee_repository}
  const CoffeeRepository(this._networkService, this._pathProviderService);

  final NetworkService _networkService;
  final PathProviderService _pathProviderService;

  /// Saves an image from the provided [imageUrl] to the favorites directory
  Future<void> saveImage(String imageUrl) async {
    final filePath = await _pathProviderService.generateUniqueFilePath(
      extension: 'jpg',
      subDir: '/favorites',
    );
    return _networkService.download(imageUrl, filePath);
  }

  /// Retrieves the image URL from the response JSON
  Future<String?> getImageUrl() async {
    return _networkService
        .getJson('/random.json')
        .then((json) => json?['file'].toString());
  }

  /// Retrieves favorite coffee image files
  Future<List<File>> getFavoriteCoffee() {
    return _pathProviderService.getDirectoryFiles('/favorites');
  }
}
