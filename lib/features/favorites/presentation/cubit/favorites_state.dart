part of 'favorites_cubit.dart';

enum FavoritesStatus { initial, loading, success, failure }

class FavoritesState extends Equatable {
  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.favoriteIds = const [],
    this.favoriteLaunches = const [],
    this.error,
  });

  final FavoritesStatus status;
  final List<String> favoriteIds;
  final List<Launch> favoriteLaunches;
  final String? error;

  @override
  List<Object?> get props => [status, favoriteIds, favoriteLaunches, error];

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<String>? favoriteIds,
    List<Launch>? favoriteLaunches,
    String? error,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      favoriteLaunches: favoriteLaunches ?? this.favoriteLaunches,
      error: error ?? this.error,
    );
  }
}
