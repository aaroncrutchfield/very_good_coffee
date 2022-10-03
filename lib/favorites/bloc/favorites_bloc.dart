import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorites_bloc.freezed.dart';
part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc(this._coffeeRepository) : super(const FavoritesLoading()) {
    on<LoadFavorites>(_getFavoriteCoffee);
    add(const LoadFavorites());
  }

  final CoffeeRepository _coffeeRepository;

  FutureOr<void> _getFavoriteCoffee(_, Emitter<FavoritesState> emit) async {
    emit(const FavoritesLoading());
    final fileList = await _coffeeRepository.getFavoriteCoffee();
    emit(FavoritesLoaded(fileList));
  }
}
