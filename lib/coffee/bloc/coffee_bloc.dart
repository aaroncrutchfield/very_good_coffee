import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coffee_bloc.freezed.dart';
part 'coffee_event.dart';
part 'coffee_state.dart';

class CoffeeBloc extends Bloc<CoffeeEvent, CoffeeState> {
  CoffeeBloc(this._coffeeRepository) : super(const CoffeeLoading()) {
    on<LoadRandomCoffee>(_loadCoffee);
    on<SaveFavoriteCoffee>(_saveFavoriteCoffee);
    add(const LoadRandomCoffee());
  }

  final CoffeeRepository _coffeeRepository;

  FutureOr<void> _loadCoffee(_, Emitter<CoffeeState> emit) async {
    emit(const CoffeeLoading());

    final imageUrl = await _coffeeRepository.getImageUrl();

    emit(CoffeeLoaded(imageUrl));
  }

  FutureOr<void> _saveFavoriteCoffee(
    SaveFavoriteCoffee event,
    Emitter<CoffeeState> emit,
  ) async {
    await _coffeeRepository.saveImage(event.imageUrl);

    emit(FavoriteCoffeeSaved(state.imageUrl));
  }
}
