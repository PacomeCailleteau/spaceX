import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/features/favorites/data/favorite_service.dart';
import 'package:space_x/features/launches/data/launch_service.dart';
import 'package:space_x/features/launches/model/launch_model.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({
    required this.favoriteService,
    required this.launchService,
  }) : super(const FavoritesState());

  final FavoriteService favoriteService;
  final LaunchService launchService;

  Future<void> loadFavorites() async {
    emit(state.copyWith(status: FavoritesStatus.loading));
    try {
      final favoriteIds = await favoriteService.getFavorites();
      final favoriteLaunches = await launchService.getLaunchesByIds(favoriteIds);
      emit(state.copyWith(
        status: FavoritesStatus.success,
        favoriteIds: favoriteIds,
        favoriteLaunches: favoriteLaunches,
      ));
    } catch (e) {
      emit(state.copyWith(status: FavoritesStatus.failure, error: e.toString()));
    }
  }

  Future<void> toggleFavorite(String launchId) async {
    try {
      final isFavorite = state.favoriteIds.contains(launchId);
      if (isFavorite) {
        await favoriteService.removeFavorite(launchId);
      } else {
        await favoriteService.addFavorite(launchId);
      }
      // Refresh the state after modification
      await loadFavorites();
    } catch (e) {
      // Handle or log error appropriately
    }
  }
}
