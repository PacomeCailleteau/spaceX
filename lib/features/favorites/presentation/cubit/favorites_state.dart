part of 'favorites_cubit.dart';

enum FavoritesStatus { initial, loading, success, failure }

class FavoritesState extends Equatable {
  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.favoriteLaunches = const [],
    this.error,
  });

  final FavoritesStatus status;
  final List<String> favoriteLaunches;
  final String? error;

  @override
  List<Object?> get props => [status, favoriteLaunches, error];

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<String>? favoriteLaunches,
    String? error,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      favoriteLaunches: favoriteLaunches ?? this.favoriteLaunches,
      error: error ?? this.error,
    );
  }
}
