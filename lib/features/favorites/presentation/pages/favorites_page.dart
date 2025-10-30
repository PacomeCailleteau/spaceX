import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_x/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:space_x/features/launches/presentation/cubit/launches_cubit.dart';
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
        builder: (context, favoritesState) {
          final favoriteLaunchIds = favoritesState.favoriteLaunches;
          return BlocBuilder<LaunchesCubit, LaunchesState>(
            builder: (context, launchesState) {
              final favoriteLaunches = launchesState.launches
                  .where((launch) => favoriteLaunchIds.contains(launch.id))
                  .toList();

              if (favoriteLaunches.isEmpty) {
                return const Center(
                  child: Text('You have no favorite launches yet.'),
                );
              }

              return ListView.builder(
                itemCount: favoriteLaunches.length,
                itemBuilder: (context, index) {
                  final launch = favoriteLaunches[index];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LaunchDetailPage(launch: launch),
                      ),
                    ),
                    child: LaunchListItem(launch: launch),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
