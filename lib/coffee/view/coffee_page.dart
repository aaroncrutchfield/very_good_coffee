import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/app/view/app.dart';
import 'package:very_good_coffee/coffee/bloc/coffee_bloc.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class CoffeePage extends StatelessWidget {
  const CoffeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => CoffeeBloc(ctx.read<CoffeeRepository>()),
      child: const CoffeeView(),
    );
  }
}

class CoffeeView extends StatelessWidget {
  const CoffeeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoffeeBloc, CoffeeState>(
      listener: (ctx, state) {
        state.whenOrNull(
          favoriteSaved: (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.favoriteSavedMessage),
                backgroundColor: Colors.green,
              ),
            );
          },
        );
      },
      builder: (ctx, state) {
        return Scaffold(
          floatingActionButton: state.whenOrNull(
            loaded: (_) => FloatingActionButton(
              onPressed: () => ctx
                  .read<CoffeeBloc>()
                  .add(SaveFavoriteCoffee(state.imageUrl!)),
              child: const Icon(Icons.favorite, color: Colors.white),
            ),
          ),
          body: state.maybeWhen(
            loading: (_) => const CoffeeLoadingView(),
            orElse: () => CoffeeViewBody(state.imageUrl!),
          ),
        );
      },
    );
  }
}

class CoffeeViewBody extends StatelessWidget {
  const CoffeeViewBody(this.imageUrl, {super.key});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          children: [
            CoffeeImageView(imageUrl),
            const SizedBox(height: 42),
            const RefreshButton(),
          ],
        ),
      ),
    );
  }
}

class CoffeeLoadingView extends StatelessWidget {
  const CoffeeLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class CoffeeImageView extends StatelessWidget {
  const CoffeeImageView(
    this.imageUrl, {
    super.key,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 300,
        child: Image.network(
          'imageUrl',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Text('😭', style: TextStyle(fontSize: 54)),
        ),
      ),
    );
  }
}

class RefreshButton extends StatelessWidget {
  const RefreshButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.read<CoffeeBloc>().add(const LoadRandomCoffee()),
      style: ElevatedButton.styleFrom(
        fixedSize: const Size.fromWidth(124),
        backgroundColor: accentColor,
      ),
      child: Text(context.l10n.refreshButtonLabel),
    );
  }
}
