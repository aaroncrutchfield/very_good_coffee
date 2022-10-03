part of 'coffee_bloc.dart';

@freezed
class CoffeeEvent with _$CoffeeEvent {
  const factory CoffeeEvent.loadRandom() = LoadRandomCoffee;
  const factory CoffeeEvent.saveFavorite(String imageUrl) = SaveFavoriteCoffee;
}
