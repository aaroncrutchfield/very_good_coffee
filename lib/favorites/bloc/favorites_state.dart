part of 'favorites_bloc.dart';

@freezed
class FavoritesState with _$FavoritesState {
  const factory FavoritesState.loading() = FavoritesLoading;
  const factory FavoritesState.loaded(List<File> files) = FavoritesLoaded;
}
