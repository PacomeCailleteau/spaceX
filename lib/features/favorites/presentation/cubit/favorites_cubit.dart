import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/features/favorites/data/favorite_service.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({required this.favoriteService}) : super(const FavoritesState());

  final FavoriteService favoriteService;

  Future<void> loadFavorites() async {
    emit(state.copyWith(status: FavoritesStatus.loading));
    try {
      final favoriteLaunches = await favoriteService.getFavorites();
      emit(state.copyWith(status: FavoritesStatus.success, favoriteLaunches: favoriteLaunches));
    } catch (e) {
      emit(state.copyWith(status: FavoritesStatus.failure, error: e.toString()));
    }
  }

  Future<void> toggleFavorite(String launchId) async {
    try {
      final isFavorite = await favoriteService.isFavorite(launchId);
      if (isFavorite) {
        await favoriteService.removeFavorite(launchId);
      } else {
        await favoriteService.addFavorite(launchId);
      }
      final favoriteLaunches = await favoriteService.getFavorites();
      emit(state.copyWith(favoriteLaunches: favoriteLaunches));
    } catch (e) {
      // Handle error appropriately
    }
  }
}
