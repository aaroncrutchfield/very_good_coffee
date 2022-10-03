import 'dart:io';

import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_coffee/favorites/favorites.dart';

import '../../helpers/helpers.dart';
import 'favorites_page_test_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CoffeeRepository>(),
  MockSpec<FavoritesBloc>(),
])
void main() {
  group('FavoritesPage', () {
    late CoffeeRepository coffeeRepository;
    late RepositoryProvider<CoffeeRepository> repositoryProvider;

    setUp(() {
      coffeeRepository = MockCoffeeRepository();
      repositoryProvider = RepositoryProvider.value(
        value: coffeeRepository,
        child: const FavoritesPage(),
      );
    });

    testWidgets('renders FavoritesPage', (widgetTester) async {
      await widgetTester.pumpApp(
        repositoryProvider,
      );
      expect(find.byType(FavoritesPage), findsOneWidget);
    });
  });

  group('FavoritesView', () {
    late FavoritesBloc favoritesBloc;
    late BlocProvider<FavoritesBloc> blocProvider;
    final fileList = [File(''), File('')];

    setUp(() {
      favoritesBloc = MockFavoritesBloc();
      blocProvider = BlocProvider.value(
        value: favoritesBloc,
        child: const FavoritesView(),
      );
    });

    testWidgets(
      'renders FavoritesLoadingView on FavoritesLoading state',
      (widgetTester) async {
        when(favoritesBloc.state).thenReturn(const FavoritesLoading());
        await widgetTester.pumpApp(blocProvider);
        expect(find.byType(FavoritesLoadingView), findsOneWidget);
      },
    );

    testWidgets(
      'renders FavoritesListView on FavoritesLoaded state',
      (widgetTester) async {
        when(favoritesBloc.state).thenReturn(const FavoritesLoaded([]));
        await widgetTester.pumpApp(blocProvider);
        expect(find.byType(FavoritesListView), findsOneWidget);
      },
    );

    testWidgets(
      'renders one FavoritesImageView per file',
      (widgetTester) async {
        when(favoritesBloc.state).thenReturn(FavoritesLoaded(fileList));
        await widgetTester.pumpApp(blocProvider);
        expect(find.byType(FavoritesImageView), findsNWidgets(2));
      },
    );
  });
}
