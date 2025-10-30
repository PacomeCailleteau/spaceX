import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:space_x/features/launches/presentation/pages/launch_detail_page.dart';
import 'package:space_x/features/launches/presentation/widgets/launch_list_item.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Launches'),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          final status = state.status;
          final favoriteLaunches = state.favoriteLaunches;

          if (status == FavoritesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (status == FavoritesStatus.failure) {
            return Center(child: Text(state.error ?? 'Failed to load favorites'));
          }

          if (favoriteLaunches.isEmpty) {
            return const Center(
              child: Text('You have no favorite launches yet.'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<FavoritesCubit>().loadFavorites(),
            child: ListView.builder(
              itemCount: favoriteLaunches.length,
              itemBuilder: (context, index) {
                final launch = favoriteLaunches[index];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LaunchDetailPage(launch: launch),
                    ),
                  ),
                  child: LaunchListItem(launch: launch),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
