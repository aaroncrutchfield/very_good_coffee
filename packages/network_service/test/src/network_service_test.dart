// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_service/network_service.dart';

import 'network_service_test.mocks.dart';

const testPath = '/test';
const urlPath = 'www.image.com/myImage.jpg';
const json = {'file': 'www.image.com/myImage.jpg'};
const savePath = 'app/favorites/20220930102243.jpg';

@GenerateMocks([Dio, BaseOptions, Response])
void main() {
  group('NetworkService', () {
    late MockDio mockDio;
    late MockBaseOptions mockBaseOptions;
    late MockResponse<Json?> getResponse;
    late MockResponse<dynamic> downloadResponse;
    late NetworkService sut;

    setUp(() {
      mockDio = MockDio();
      getResponse = MockResponse<Json?>();
      downloadResponse = MockResponse<dynamic>();
      mockBaseOptions = MockBaseOptions();

      when(mockDio.options).thenReturn(mockBaseOptions);
      when(mockBaseOptions.baseUrl).thenReturn('');

      sut = NetworkService(dio: mockDio, baseUrl: urlPath);
    });

    test(
        'baseUrl set to BaseOptions '
        'when instantiated', () {
      verify(mockBaseOptions.baseUrl = urlPath);
    });

    group('getJson', () {
      setUp(() {
        when(getResponse.data).thenReturn(json);
        when(mockDio.get<Json?>(testPath, options: anyNamed('options')))
            .thenAnswer((_) => Future.value(getResponse));
      });

      test('calls Dio.get', () async {
        await sut.getJson(testPath);
        verify(mockDio.get<Json?>(testPath, options: anyNamed('options')));
      });

      test('calls Response.data', () async {
        await sut.getJson(testPath);
        verify(getResponse.data);
      });

      test('returns a JSON response', () async {
        final responseJson = await sut.getJson(testPath);
        expect(responseJson, json);
      });

      test(
          'throws GetRequestException '
          'when Dio.get throws', () async {
        when(mockDio.get<Json?>(testPath, options: anyNamed('options')))
            .thenThrow(Exception());
        expect(
          sut.getJson(testPath),
          throwsA(isA<GetRequestException>()),
        );
      });
    });

    group('download', () {
      setUp(() {
        when(mockDio.download(urlPath, savePath))
            .thenAnswer((_) => Future.value(downloadResponse));
      });

      test('calls Dio.download', () {
        sut.download(urlPath, savePath);
        verify(mockDio.download(urlPath, savePath));
      });

      test('succeeds when Dio.download succeeds', () {
        expect(
          sut.download(urlPath, savePath),
          completes,
        );
      });

      test(
          'throws DownloadExceptions '
          'when dio.download throws', () async {
        when(mockDio.download(urlPath, savePath)).thenThrow(Exception());
        expect(
          sut.download(urlPath, savePath),
          throwsA(isA<DownloadException>()),
        );
      });
    });
  });
}
