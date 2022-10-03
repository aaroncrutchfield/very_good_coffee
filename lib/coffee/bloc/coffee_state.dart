part of 'coffee_bloc.dart';

@freezed
class CoffeeState with _$CoffeeState {
  const factory CoffeeState.loading([
    String? imageUrl,
  ]) = CoffeeLoading;

  const factory CoffeeState.loaded([
    String? imageUrl,
  ]) = CoffeeLoaded;

  const factory CoffeeState.favoriteSaved([
    String? imageUrl,
  ]) = FavoriteCoffeeSaved;
}
