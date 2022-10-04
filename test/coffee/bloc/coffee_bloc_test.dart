import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_coffee/coffee/coffee.dart';

import '../../favorites/bloc/favorites_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CoffeeRepository>(),
])
void main() {
  group('CoffeeBloc', () {
    late MockCoffeeRepository mockCoffeeRepository;
    const imageUrl = 'www.myImage.com/image.jpg';

    setUp(() {
      mockCoffeeRepository = MockCoffeeRepository();
    });

    test('initial state is CoffeeLoading', () {
      expect(
        CoffeeBloc(mockCoffeeRepository).state,
        const CoffeeLoading(),
      );
    });

    blocTest<CoffeeBloc, CoffeeState>(
      'initially emits [CoffeeLoading, CoffeeLoaded]',
      build: () => CoffeeBloc(mockCoffeeRepository),
      expect: () => [const CoffeeLoading(), const CoffeeLoaded()],
    );

    group('LoadRandomCoffee event', () {
      setUp(() {
        when(mockCoffeeRepository.getImageUrl())
            .thenAnswer((_) => Future.value(imageUrl));
      });

      blocTest<CoffeeBloc, CoffeeState>(
        'emits [CoffeeLoading, CoffeeLoaded(imageUrl)]',
        build: () => CoffeeBloc(mockCoffeeRepository),
        act: (sut) => sut.add(const LoadRandomCoffee()),
        skip: 2,
        expect: () => [const CoffeeLoading(), const CoffeeLoaded(imageUrl)],
      );

      blocTest<CoffeeBloc, CoffeeState>(
        'calls getImageUrl',
        build: () => CoffeeBloc(mockCoffeeRepository),
        act: (sut) => sut.add(const LoadRandomCoffee()),
        verify: (_) => verify(mockCoffeeRepository.getImageUrl()),
      );
    });

    group('SaveFavoriteCoffee event', () {
      setUp(() {
        when(mockCoffeeRepository.saveImage(imageUrl))
            .thenAnswer((_) => Future.value());

      });

      blocTest<CoffeeBloc, CoffeeState>(
        'emits [FavoriteCoffeeSaved(imageUrl)]',
        build: () => CoffeeBloc(mockCoffeeRepository),
        act: (sut) => sut.add(const SaveFavoriteCoffee(imageUrl)),
        skip: 2,
        expect: () => [const FavoriteCoffeeSaved(imageUrl)],
      );

      blocTest<CoffeeBloc, CoffeeState>(
        'calls saveImage(imageUrl)',
        build: () => CoffeeBloc(mockCoffeeRepository),
        act: (sut) => sut.add(const SaveFavoriteCoffee(imageUrl)),
        verify: (_) => verify(mockCoffeeRepository.saveImage(imageUrl)),
      );
    });
  });
}
