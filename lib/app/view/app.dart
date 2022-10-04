// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:network_service/network_service.dart';
import 'package:path_provider_service/path_provider_service.dart';
import 'package:very_good_coffee/coffee/coffee.dart';
import 'package:very_good_coffee/favorites/favorites.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

const accentColor = Color(0xFF038C25);
const appBarColor = Color(0xFF1b0000);
const titleColor = Colors.white;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => CoffeeRepository(
            NetworkService(baseUrl: 'https://coffee.alexflipnote.dev'),
            const PathProviderService(),
          ),
        ),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: appBarColor),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: accentColor,
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const CoffeeTabView(),
    );
  }
}

class CoffeeTabView extends StatelessWidget {
  const CoffeeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.l10n.counterAppBarTitle,
            style: GoogleFonts.greatVibes().copyWith(
              fontSize: 32,
              color: titleColor,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorWeight: 4,
            indicatorColor: accentColor,
            tabs: [
              Tab(
                text: context.l10n.coffeeTabLabel,
                icon: const Icon(Icons.coffee),
              ),
              Tab(
                text: context.l10n.favoritesTabLabel,
                icon: const Icon(Icons.favorite),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CoffeePage(),
            FavoritesPage(),
          ],
        ),
      ),
    );
  }
}
