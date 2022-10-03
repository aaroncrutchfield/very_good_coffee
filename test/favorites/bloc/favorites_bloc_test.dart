import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_coffee/favorites/bloc/favorites_bloc.dart';

import 'favorites_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CoffeeRepository>(),
])
void main() {
  group('FavoritesBloc', () {
    final fileList = <File>[File('app/favorites/20220930034421.jpg')];
    late MockCoffeeRepository mockCoffeeRepository;

    setUp(() {
      mockCoffeeRepository = MockCoffeeRepository();
    });

    test('initial state is FavoritesLoading', () {
      expect(
        FavoritesBloc(mockCoffeeRepository).state,
        const FavoritesLoading(),
      );
    });

    blocTest<FavoritesBloc, FavoritesState>(
      'initially emits [FavoritesLoading, FavoritesLoaded]',
      build: () => FavoritesBloc(mockCoffeeRepository),
      expect: () => [const FavoritesLoading(), const FavoritesLoaded([])],
    );

    group('LoadFavorites event', () {
      setUp(() {
        when(mockCoffeeRepository.getFavoriteCoffee())
            .thenAnswer((realInvocation) => Future.value(fileList));
      });

      blocTest<FavoritesBloc, FavoritesState>(
        'emits [FavoritesLoading, FavoritesLoaded(fileList)]',
        build: () => FavoritesBloc(mockCoffeeRepository),
        act: (sut) => sut.add(const LoadFavorites()),
        skip: 2,
        expect: () => [const FavoritesLoading(), FavoritesLoaded(fileList)],
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'calls getFavoriteCoffee',
        build: () => FavoritesBloc(mockCoffeeRepository),
        act: (sut) => sut.add(const LoadFavorites()),
        verify: (_) => verify(mockCoffeeRepository.getFavoriteCoffee()),
      );
    });
  });
}
