// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:coffee_repository/coffee_repository.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_service/network_service.dart';
import 'package:path_provider_service/path_provider_service.dart';

import 'coffee_repository_test.mocks.dart';

@GenerateMocks([
  NetworkService,
  PathProviderService,
])
void main() {
  group('CoffeeRepository', () {
    const imageUrl = 'www.image.com/myImage.jpg';
    const uniqueFilePath = 'app/favorites/20220925125532.jpg';
    const extension = 'jpg';
    const subDir = '/favorites';
    const path = '/random.json';
    const jsonResponse = {'file': 'www.image.com/myImage.jpg'};
    final fileList = [File(uniqueFilePath)];

    late CoffeeRepository sut;
    late MockNetworkService mockNetworkService;
    late MockPathProviderService mockPathProviderService;

    setUp(() {
      mockNetworkService = MockNetworkService();
      mockPathProviderService = MockPathProviderService();
      sut = CoffeeRepository(mockNetworkService, mockPathProviderService);
    });

    group('saveImage', () {
      setUp(() {
        when(
          mockPathProviderService.generateUniqueFilePath(
            extension: extension,
            subDir: subDir,
          ),
        ).thenAnswer((_) => Future.value(uniqueFilePath));

        when(mockNetworkService.download(imageUrl, uniqueFilePath))
            .thenAnswer((_) => Future.value());
      });

      test('calls generateUniqueFilePath', () async {
        await sut.saveImage(imageUrl);
        verify(
          mockPathProviderService.generateUniqueFilePath(
            extension: extension,
            subDir: subDir,
          ),
        );
      });

      test('calls download', () async {
        await sut.saveImage(imageUrl);
        verify(mockNetworkService.download(imageUrl, uniqueFilePath));
      });

      test('succeeds', () async {
        expect(sut.saveImage(imageUrl), completes);
      });
    });

    group('getImageUrl', () {
      setUp(() {
        when(mockNetworkService.getJson(path))
            .thenAnswer((_) => Future.value(jsonResponse));
      });

      test('calls getJson', () async {
        await sut.getImageUrl();
        verify(mockNetworkService.getJson(path));
      });

      test('returns imageUrl', () async {
        final urlResponse = await sut.getImageUrl();
        expect(urlResponse, imageUrl);
      });
    });

    group('getFavoriteCoffee', () {
      setUp(() {
        when(mockPathProviderService.getDirectoryFiles(subDir))
            .thenAnswer((_) => Future.value(fileList));
      });

      test('calls getDirectoryFiles', () async {
        await sut.getFavoriteCoffee();
        verify(mockPathProviderService.getDirectoryFiles(subDir));
      });

      test('returns File list', () async {
        final list = await sut.getFavoriteCoffee();
        expect(list, fileList);
      });
    });
  });
}
