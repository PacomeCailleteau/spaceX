part of 'favorites_cubit.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

final class FavoritesInitial extends FavoritesState {}

final class FavoritesLoading extends FavoritesState {}

final class FavoritesSuccess extends FavoritesState {
  final List<String> favoriteIds;
  final List<Launch> favoriteLaunches;

  const FavoritesSuccess({
    this.favoriteIds = const [],
    this.favoriteLaunches = const [],
  });

  @override
  List<Object> get props => [favoriteIds, favoriteLaunches];
}

final class FavoritesFailure extends FavoritesState {
  final String error;

  const FavoritesFailure(this.error);

  @override
  List<Object> get props => [error];
}
