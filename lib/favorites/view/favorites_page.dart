import 'dart:io';

import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/favorites/bloc/favorites_bloc.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => FavoritesBloc(ctx.read<CoffeeRepository>()),
      child: const FavoritesView(),
    );
  }
}

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        return state.when(
          loading: FavoritesLoadingView.new,
          loaded: FavoritesListView.new,
        );
      },
    );
  }
}

class FavoritesLoadingView extends StatelessWidget {
  const FavoritesLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class FavoritesListView extends StatelessWidget {
  const FavoritesListView(this.fileList, {super.key});

  final List<File> fileList;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(8),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      crossAxisCount: 2,
      children: fileList.map(FavoritesImageView.new).toList(),
    );
  }
}

class FavoritesImageView extends StatelessWidget {
  const FavoritesImageView(this.file, {super.key});

  final File file;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: FileImage(file),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
