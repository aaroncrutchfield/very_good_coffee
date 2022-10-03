import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_coffee/coffee/coffee.dart';

import '../../helpers/helpers.dart';
import 'coffee_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CoffeeRepository>(),
  MockSpec<CoffeeBloc>(),
])
void main() {
  group('CoffeePage', () {
    late CoffeeRepository coffeeRepository;
    late RepositoryProvider<CoffeeRepository> repositoryProvider;

    setUp(() {
      coffeeRepository = MockCoffeeRepository();
      repositoryProvider = RepositoryProvider.value(
        value: coffeeRepository,
        child: const CoffeePage(),
      );
    });

    testWidgets('renders CoffeePage', (widgetTester) async {
      await widgetTester.pumpApp(
        repositoryProvider,
      );
      expect(find.byType(CoffeePage), findsOneWidget);
    });
  });

  group('CoffeeView', () {
    late CoffeeBloc coffeeBloc;
    late BlocProvider<CoffeeBloc> blocProvider;
    const imageUrl = 'www.image.com/myImage.jpg';

    setUp(() {
      coffeeBloc = MockCoffeeBloc();
      blocProvider = BlocProvider.value(
        value: coffeeBloc,
        child: const CoffeeView(),
      );
    });

    testWidgets(
      'renders CoffeeLoadingView on CoffeeLoading state',
      (widgetTester) async {
        when(coffeeBloc.state).thenReturn(const CoffeeLoading());
        await widgetTester.pumpApp(blocProvider);
        expect(find.byType(CoffeeLoadingView), findsOneWidget);
      },
    );

    testWidgets(
      'renders CoffeeViewBody on CoffeeLoaded state',
      (widgetTester) async {
        when(coffeeBloc.state).thenReturn(const CoffeeLoaded(imageUrl));
        await widgetTester.pumpApp(blocProvider);
        expect(find.byType(CoffeeViewBody), findsOneWidget);
      },
    );

    // TODO(acrutchfield): Failing - Find snackbar after animation, https://github.com/aaroncrutchfield/very_good_coffee/issues/1
    testWidgets(
      'renders SnackBar on FavoriteCoffeeSaved state',
      (widgetTester) async {
        when(coffeeBloc.state).thenReturn(const FavoriteCoffeeSaved(imageUrl));
        await widgetTester.pumpApp(blocProvider);
        await widgetTester.tap(find.byType(SnackBar));
        expect(find.byType(SnackBar), findsOneWidget);
      },
    );
  });

  group('FloatingActionButton', () {
    late CoffeeBloc coffeeBloc;
    late BlocProvider<CoffeeBloc> blocProvider;
    const imageUrl = 'www.image.com/myImage.jpg';

    setUp(() {
      coffeeBloc = MockCoffeeBloc();
      blocProvider = BlocProvider.value(
        value: coffeeBloc,
        child: const CoffeeView(),
      );
    });

    testWidgets(
      'does not render on CoffeeLoading state',
      (widgetTester) async {
        when(coffeeBloc.state).thenReturn(const CoffeeLoading());
        await widgetTester.pumpApp(blocProvider);
        expect(find.byType(FloatingActionButton), findsNothing);
      },
    );

    testWidgets(
      'renders FAB on CoffeeLoaded state',
      (widgetTester) async {
        when(coffeeBloc.state).thenReturn(const CoffeeLoaded(imageUrl));
        await widgetTester.pumpApp(blocProvider);
        expect(find.byType(FloatingActionButton), findsOneWidget);
      },
    );

    testWidgets(
      'adds SaveFavoriteCoffee(imageUrl) event to bloc when tapped',
      (widgetTester) async {
        when(coffeeBloc.state).thenReturn(const CoffeeLoaded(imageUrl));
        await widgetTester.pumpApp(blocProvider);
        await widgetTester.tap(find.byType(FloatingActionButton));
        verify(coffeeBloc.add(const SaveFavoriteCoffee(imageUrl)));
      },
    );
  });

  group('RefreshButton', () {
    late CoffeeBloc coffeeBloc;
    late BlocProvider<CoffeeBloc> blocProvider;
    const imageUrl = 'www.image.com/myImage.jpg';

    setUp(() {
      coffeeBloc = MockCoffeeBloc();
      blocProvider = BlocProvider.value(
        value: coffeeBloc,
        child: const CoffeeView(),
      );
    });

    testWidgets(
      'adds LoadRandomCoffee event to bloc when tapped',
      (widgetTester) async {
        when(coffeeBloc.state).thenReturn(const CoffeeLoaded(imageUrl));
        await widgetTester.pumpApp(blocProvider);
        await widgetTester.tap(find.byType(RefreshButton));
        verify(coffeeBloc.add(const LoadRandomCoffee()));
      },
    );
  });
}
