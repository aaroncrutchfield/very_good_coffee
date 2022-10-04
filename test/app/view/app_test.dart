// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:very_good_coffee/app/app.dart';
import 'package:very_good_coffee/coffee/coffee.dart';

import 'app_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CoffeeRepository>(),
  MockSpec<CoffeeBloc>(),
])
void main() {
  // How to confirm app rendering? Tab selection?
  // CoffeeBloc state always comes back as null and
  // throws a Null check operator error
  group('App', () {
    late RepositoryProvider<CoffeeRepository> repositoryProvider;
    late CoffeeRepository mockCoffeeRepository;
    late CoffeeBloc mockCoffeeBloc;

    setUp(() {
      mockCoffeeBloc = MockCoffeeBloc();
      mockCoffeeRepository = MockCoffeeRepository();
      repositoryProvider = RepositoryProvider.value(
        value: mockCoffeeRepository,
        child: BlocProvider.value(
          value: mockCoffeeBloc,
          child: const AppView(),
        ),
      );

      when(mockCoffeeBloc.state)
          .thenReturn(const CoffeeLoaded(''));
    });

    testWidgets('renders CoffeePage when tab tapped', (widgetTester) async {
      await widgetTester.pumpWidget(repositoryProvider);

      await widgetTester.tap(find.byIcon(Icons.coffee));
      await widgetTester.pumpAndSettle();
      expect(find.byType(CoffeePage), findsOneWidget);
    });
  });
}
