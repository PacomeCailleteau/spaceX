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
  }) : super(FavoritesInitial());

  final FavoriteService favoriteService;
  final LaunchService launchService;

  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    try {
      final favoriteIds = await favoriteService.getFavorites();
      final favoriteLaunches = await launchService.getLaunchesByIds(favoriteIds);
      emit(FavoritesSuccess(
        favoriteIds: favoriteIds,
        favoriteLaunches: favoriteLaunches,
      ));
    } catch (e) {
      emit(FavoritesFailure(e.toString()));
    }
  }

  Future<void> toggleFavorite(String launchId) async {
    try {
      final currentState = state;
      if (currentState is! FavoritesSuccess) return;

      final isFavorite = currentState.favoriteIds.contains(launchId);
      if (isFavorite) {
        await favoriteService.removeFavorite(launchId);
      } else {
        await favoriteService.addFavorite(launchId);
      }
      // Refresh the state after modification
      await loadFavorites();
    } catch (e) {
      emit(FavoritesFailure(e.toString()));
    }
  }
}
