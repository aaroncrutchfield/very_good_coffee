// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

/// Thrown when GET request fails.
class GetRequestException implements Exception {}

/// Thrown when downloading file from url fails.
class DownloadException implements Exception {}

/// Json data returned from GET requests.
typedef Json = Map<String, dynamic>;

/// {@template network_service}
/// Service that manages network requests with Dio
/// {@endtemplate}
class NetworkService {
  /// {@macro network_repository}
  NetworkService({
    @visibleForTesting Dio? dio,
    required String baseUrl,
  }) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = baseUrl;
  }

  final Dio _dio;

  /// Retrieves a JSON response from the given [path].
  ///
  /// Throws [GetRequestException] when operation fails.
  Future<Json?> getJson(String path) async {
    final Json? json;
    try {
       json = await _dio
          .get<Json?>(path, options: _jsonOptions)
          .then((value) => value.data);
    } catch (_) {
      throw GetRequestException();
    }
    return json;
  }

  /// Downloads a file from the [url] and saves it to [savePath].
  ///
  /// Throws [DownloadException] when the operation fails.
  Future<void> download(String url, String savePath) async {
    try {
      await _dio.download(url, savePath);
    } catch (_) {
      throw DownloadException();
    }
    return;
  }

  Options get _jsonOptions {
    return Options(
      responseType: ResponseType.json,
      contentType: 'application/json',
    );
  }
}
