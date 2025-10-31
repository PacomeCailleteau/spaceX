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
      body: RefreshIndicator(
        onRefresh: () => context.read<FavoritesCubit>().loadFavorites(),
        child: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            return switch (state) {
              FavoritesInitial() || FavoritesLoading() => const Center(child: CircularProgressIndicator()),
              FavoritesFailure(error: final error) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(error),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<FavoritesCubit>().loadFavorites(),
                        child: const Text('Retry'),
                      )
                    ],
                  ),
                ),
              FavoritesSuccess(favoriteLaunches: final launches) =>
                launches.isEmpty
                    ? LayoutBuilder(builder: (context, constraints) => SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: constraints.maxHeight),
                            child: const Center(child: Text('You have no favorite launches yet.')),
                          ),
                        ))
                    : ListView.builder(
                        itemCount: launches.length,
                        itemBuilder: (context, index) {
                          final launch = launches[index];
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
            };
          },
        ),
      ),
    );
  }
}
